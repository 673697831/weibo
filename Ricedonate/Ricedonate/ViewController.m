//
//  ViewController.m
//  Ricedonate
//
//  Created by megil on 8/28/14.
//  Copyright (c) 2014 megil. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#define kAppKey         @"3770602938"
#define kRedirectURI    @"http://www.sina.com"
#define TIMELINEURI @"https://api.weibo.com/2/statuses/user_timeline.json"
#define UPDATEURI @"https://api.weibo.com/2/statuses/update.json"
#define UPLOADURI @"https://api.weibo.com/2/statuses/upload.json"
#define BUTTON_GET 0   //获取
#define BUTTON_SEND 1  //发送
#define BUTTON_IDENT 2 //验证
#define BUTTON_LOGINOUT 3 //登出
#define REQUEST_NUM 20
#define BUTTONWIDTH 38
@interface ViewController ()
-(UIButton *)createButton:(CGRect)frame Title:(NSString *)titleName Tag:(int)tag Count:(int)count;
-(void)weiboYanZheng;
-(void)requestWeibo;
-(void)openSendWeibo;
-(void)sendWeiboWithImage:(NSString *)text ImageInfo:(UIImage *)image;
-(void)sendWeibowithoutImage:(NSString *)text;
@end

@implementation ViewController
@synthesize userInfo = __userInfo;
@synthesize sendWeiboView = __sendWeiboView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    viewControllerInstance = self;
    
    return self;
}

//构造按钮
-(UIButton *)createButton:(CGRect)frame Title:(NSString *)titleName Tag:(int)tag Count:(int)count
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    [button setTitle:titleName forState:UIControlStateNormal];
    [button setTag:tag];
    button.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:button];
    
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:100 + count *(10 + BUTTONWIDTH)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
//                                                          attribute:NSLayoutAttributeHeight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:nil
//                                                          attribute:NSLayoutAttributeNotAnAttribute
//                                                         multiplier:1.0
//                                                           constant:100]];
    return button;
}

-(void)weiboYanZheng
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

-(void)requestWeibo
{
    if ([self.userInfo status] < 0) {
        NSLog(@"还没登陆微博");
        return;
    }
    NSString *access_token = [self.userInfo accessToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"access_token":access_token, @"count":@REQUEST_NUM};
    [manager GET:TIMELINEURI parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
        int total_number = [[responseObject objectForKey:@"total_number"] intValue];
        self.userInfo.totalNumber = total_number;
        NSArray *weibos = [responseObject objectForKey:@"statuses"];
        [self.userInfo resetWeibo:weibos];
        //self.userInfo.weiboList = weibos;
        if (!weiboListView) {
            weiboListView = [[WeiboTableViewController alloc] initWithStyle:UITableViewStylePlain];
        }
        //[weiboListView setUserInfo:dic];
        //[self.navigationController pushViewController:weiboListView animated:YES];
        [self presentViewController:weiboListView animated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
}

-(void)openSendWeibo
{
    if (!self.sendWeiboView) {
        self.sendWeiboView = [[SendWeiboView alloc] init];
    }
    [self.navigationController pushViewController:self.sendWeiboView animated:YES];
}
-(void)sendWeibo:(NSString *)text ImageInfo:(UIImage *)image
{
    //NSLog(@"cccccccccc%@ %@", data, text);
    if ([self.userInfo status] < 0) {
        NSLog(@"还没登陆微博");
        return;
    }
    
    if (!text || [text isEqual:@""]) {
        NSLog(@"还没输入微博内容");
        return;
    }
    
    if (!image) {
        [self sendWeibowithoutImage:text];
    }
    else
    {
        [self sendWeiboWithImage:text ImageInfo:image];
    }
    [self.sendWeiboView reset];
//    NSString *text = @"ewighieowioghweihgowg";
    
}

-(void)sendWeiboWithImage:(NSString *)text ImageInfo:(UIImage *)image
{
    NSString *access_token = [self.userInfo accessToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"access_token":access_token, @"status":text};
    [manager POST:UPLOADURI parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *data=UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"status.jpg" mimeType:@"image/jpeg"];}
          success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
              NSLog(@"%@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)sendWeibowithoutImage:(NSString *)text
{
    NSString *access_token = [self.userInfo accessToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"access_token":access_token, @"status":text};
    [manager POST:UPDATEURI parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
       NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)refreshWeibo
{
    if ([self.userInfo status] < 0) {
        NSLog(@"还没登陆微博");
        return;
    }
    //NSString *index =@"3522703174183305";
    NSString *access_token = [self.userInfo accessToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"access_token":access_token, @"count":@REQUEST_NUM};
    [manager GET:TIMELINEURI parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
        NSArray *weibos = [responseObject objectForKey:@"statuses"];
        [self.userInfo reset];
        int total_number = [[responseObject objectForKey:@"total_number"] intValue];
        self.userInfo.totalNumber = total_number;
        //self.userInfo.weiboList = weibos;
        [self.userInfo resetWeibo:weibos];
        [weiboListView Update];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)addWeibo
{
    if ([self.userInfo status] < 0) {
        NSLog(@"还没登陆微博");
        return;
    }
    NSString *access_token = [self.userInfo accessToken];
    int64_t num = [self.userInfo lastWeibo];
    NSString *index = [NSString stringWithFormat:@"%lld", num];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"access_token":access_token, @"count":@REQUEST_NUM, @"max_id":index};
    [manager GET:TIMELINEURI parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
        NSArray *weibos = [responseObject objectForKey:@"statuses"];
        int total_number = [[responseObject objectForKey:@"total_number"] intValue];
        self.userInfo.totalNumber = total_number;
        [self.userInfo addWeibo:weibos];
        [weiboListView Update];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)viewDidLoad
{
    self.userInfo = [[UserInfo alloc] init];
    int width = 68;
    int height = 38;
    int count = 0;
    CGRect frame = CGRectMake(120, 120, width, height);
    buttonGetWeibo = [self createButton:frame Title:@"获取微博" Tag:BUTTON_GET Count:count];
    count ++;
    [buttonGetWeibo addTarget:self action:@selector(requestWeibo) forControlEvents:UIControlEventTouchUpInside];
    frame.origin.y = frame.origin.y + 50;
    buttonSendWeibo = [self createButton:frame Title:@"发送微博" Tag:BUTTON_SEND Count:count];
    count ++;
    [buttonSendWeibo addTarget:self action:@selector(openSendWeibo) forControlEvents:UIControlEventTouchUpInside];
    frame.origin.y = frame.origin.y + 50;
    buttonYanZheng = [self createButton:frame Title:@"微博验证" Tag:BUTTON_IDENT Count:count];
    count ++;
    [buttonYanZheng addTarget:self action:@selector(weiboYanZheng) forControlEvents:UIControlEventTouchUpInside];
    frame.origin.y = frame.origin.y + 50;
    buttonLoginOut = [self createButton:frame Title:@"账号登出" Tag:BUTTON_LOGINOUT Count:count];
//    [self.view addSubview:buttonSendWeibo];
//    [self.view addSubview:buttonGetWeibo];
//    [self.view addSubview:buttonYanZheng];
//    [self.view addSubview:buttonLoginOut];
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUserToken:(NSString *)token
{
    self.userInfo.accessToken = token;
}

- (NSString *)getUserToken
{
    return [self.userInfo accessToken];
}
+ (ViewController *)getInstance
{
    return viewControllerInstance;
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
