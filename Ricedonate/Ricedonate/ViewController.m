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
#define BUTTON_GET 0   //获取
#define BUTTON_SEND 1  //发送
#define BUTTON_IDENT 2 //验证
#define BUTTON_LOGINOUT 3 //登出
@interface ViewController ()
-(UIButton *)createButton:(CGRect)frame Title:(NSString *)titleName Tag:(int)tag;
-(void)weiboYanZheng;
-(void)displayWeibo:(NSDictionary *)dic;
-(void)requestWeibo;
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//构造按钮
-(UIButton *)createButton:(CGRect)frame Title:(NSString *)titleName Tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    [button setTitle:titleName forState:UIControlStateNormal];
    [button setTag:tag];
    button.backgroundColor = [UIColor orangeColor];
    return button;
}

-(void)weiboYanZheng
{
    NSLog(@"lllllll");
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
    if ([userInfo getStatus] < 0) {
        NSLog(@"还没登陆微博");
        return;
    }
    NSString *access_token = [userInfo get_token];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"access_token":access_token};
    [manager GET:@"https://api.weibo.com/2/statuses/user_timeline.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
        [self displayWeibo:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
}

-(void)displayWeibo:(NSDictionary *)dic
{
    NSArray *weibos = [dic objectForKey:@"statuses"];
    [userInfo set_weibo_list:weibos];
    if (!weiboListView) {
        weiboListView = [[WeiboTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    //[weiboListView setUserInfo:dic];
    [self.navigationController pushViewController:weiboListView animated:YES];
}

- (void)viewDidLoad
{
    userInfo = [[UserInfo alloc] init];
    NSLog(@"viewDidLoad %@", userInfo);
    int width = 68;
    int height = 38;
    CGRect frame = CGRectMake(120, 120, width, height);
    buttonGetWeibo = [self createButton:frame Title:@"获取微博" Tag:BUTTON_GET];
    [buttonGetWeibo addTarget:self action:@selector(requestWeibo) forControlEvents:UIControlEventTouchUpInside];
    frame.origin.y = frame.origin.y + 50;
    buttonSendWeibo = [self createButton:frame Title:@"发送微博" Tag:BUTTON_SEND];
    frame.origin.y = frame.origin.y + 50;
    buttonYanZheng = [self createButton:frame Title:@"微博验证" Tag:BUTTON_IDENT];
    [buttonYanZheng addTarget:self action:@selector(weiboYanZheng) forControlEvents:UIControlEventTouchUpInside];
    frame.origin.y = frame.origin.y + 50;
    buttonLoginOut = [self createButton:frame Title:@"账号登出" Tag:BUTTON_LOGINOUT];
    [self.view addSubview:buttonSendWeibo];
    [self.view addSubview:buttonGetWeibo];
    [self.view addSubview:buttonYanZheng];
    [self.view addSubview:buttonLoginOut];
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
    [userInfo set_token:token];
}

- (NSString *)getUserToken
{
    return [userInfo get_token];
}
- (void)sendPro
{
 
    
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
