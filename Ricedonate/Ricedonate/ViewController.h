//
//  ViewController.h
//  Ricedonate
//
//  Created by megil on 8/28/14.
//  Copyright (c) 2014 megil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import "UserInfo.h"
#import "WeiboTableViewController.h"
#import "SendWeiboView.h"
@interface ViewController : UIViewController
{
    UserInfo *__userInfo;
    IBOutlet UIButton *buttonGetWeibo;
    IBOutlet UIButton *buttonSendWeibo;
    IBOutlet UIButton *buttonYanZheng;
    IBOutlet UIButton *buttonLoginOut;
    WeiboTableViewController *weiboListView;
    SendWeiboView *__sendWeiboView;
}

-(void)setUserToken:(NSString *)token;
-(NSString *)getUserToken;
-(void)refreshWeibo;
-(void)addWeibo;
-(void)sendWeibo:(NSString *)text ImageInfo:(UIImage *)image;
+(ViewController *)getInstance;
@property(nonatomic, strong) UserInfo *userInfo;
@property(nonatomic, strong) SendWeiboView *sendWeiboView;
@end

static ViewController *viewControllerInstance;
