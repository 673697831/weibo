//
//  SendWeiboView.m
//  Ricedonate
//
//  Created by megil on 9/1/14.
//  Copyright (c) 2014 megil. All rights reserved.
//

#import "SendWeiboView.h"
#import "ViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface SendWeiboView ()
-(void)getPhoto;
-(void)sendWeibo;
@end

@implementation SendWeiboView
@synthesize picker = __picker;
@synthesize image = __image;
@synthesize input = __input;
@synthesize imageView = __imageView;
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

// 判断是否支持某种多媒体类型：拍照，视频
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0){
        NSLog(@"Media type is empty.");
        return NO;
    }
    NSArray *availableMediaTypes =[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
        
    }];
    return result;
}

// 检查摄像头是否支持录像
- (BOOL) doesCameraSupportShootingVideos{
    return [self cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypeCamera];
}

// 检查摄像头是否支持拍照
- (BOOL) doesCameraSupportTakingPhotos{
    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - 相册文件选取相关
// 相册是否可用
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}

// 是否可以在相册中选择视频
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

// 是否可以在相册中选择视频
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.imageView setImage:self.image];
    NSLog(@"didFinishPickingMediaWithInfo");
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"imagePickerControllerDidCancel");
    [picker dismissViewControllerAnimated:YES completion:^{}];
}


-(void)reset
{
    [self.input setText:@""];
    [self.imageView setImage:nil];
    self.image = nil;
}
-(void)getPhoto
{
    self.picker.delegate = self;//设置为托
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.picker.allowsEditing=YES;//允许编辑图片
    [self presentViewController:self.picker animated:YES completion:^{
        NSLog(@"死棒子");
    }];
}
-(void)sendWeibo
{
    [[ViewController getInstance] sendWeibo:[self.input text] ImageInfo:self.image];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.input = [[UITextView alloc] init];
    self.input.layer.borderColor = [UIColor grayColor].CGColor;
    self.input.layer.borderWidth =1.0;
    self.input.layer.cornerRadius =5.0;
    [self.input setText:@""];
    [self.view addSubview:self.input];
    self.title = @"发送微博";
    //self.input = [[UITextView alloc] initWithFrame:CGRectMake(10,88, 300, 31)];
    sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.frame = CGRectMake(50, 188, 50, 30);
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendWeibo) forControlEvents:UIControlEventTouchUpInside];
    sendButton.backgroundColor = [UIColor orangeColor];
    photoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    photoButton.frame = CGRectMake(50, 300, 50, 30);
    photoButton.backgroundColor = [UIColor orangeColor];
    [photoButton addTarget:self action:@selector(getPhoto) forControlEvents:UIControlEventTouchUpInside];
    [photoButton setTitle:@"拍照" forState:UIControlStateNormal];
    //input.backgroundColor = [UIColor darkTextColor];
    //[self.view addSubview:self.input];
    [self.view addSubview:sendButton];
    [self.view addSubview:photoButton];
    //点击背景时候关闭键盘
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleBackgroundTap:)];
     tapRecognizer.cancelsTouchesInView = NO;
     [self.view addGestureRecognizer:tapRecognizer];
    self.picker = [[UIImagePickerController alloc]init];//创建
    self.imageView = [[UIImageView alloc] init];
    self.imageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.imageView.layer.borderWidth =1.0;
    self.imageView.layer.cornerRadius =5.0;
    [self.view addSubview:self.imageView];
    
    [self.input setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.input attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:70]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.input attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.input attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.input
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:100]];
    
    [sendButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sendButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.input attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sendButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:50]];
    
    [photoButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:photoButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-50]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:photoButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.input attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];
    
    [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.input attribute:NSLayoutAttributeBottom multiplier:1.0 constant:70]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]];
    
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    
    //把手势对象，添加给视图对象
    
    [self.imageView addGestureRecognizer:singleTap];
    // Do any additional setup after loading the view.
}

-(void)onClickImage
{
    [self.imageView setImage:nil];
    self.image = nil;
}

- (void)handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
