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
    NSLog(@"didFinishPickingMediaWithInfo");
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"imagePickerControllerDidCancel");
}


-(void)reset
{
    [self.input setText:@""];
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
    self.title = @"发送微博";
    self.input = [[UITextView alloc] initWithFrame:CGRectMake(10,88, 300, 31)];
    [self.input setText:@""];
    self.input.layer.borderColor = [UIColor grayColor].CGColor;
    self.input.layer.borderWidth =1.0;
    self.input.layer.cornerRadius =5.0;
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
    [self.view addSubview:self.input];
    [self.view addSubview:sendButton];
    [self.view addSubview:photoButton];
    //点击背景时候关闭键盘
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleBackgroundTap:)];
     tapRecognizer.cancelsTouchesInView = NO;
     [self.view addGestureRecognizer:tapRecognizer];
    self.picker = [[UIImagePickerController alloc]init];//创建
    // Do any additional setup after loading the view.
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