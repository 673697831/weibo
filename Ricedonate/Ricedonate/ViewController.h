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
@interface ViewController : UIViewController
{
    UserInfo *__userInfo;
    IBOutlet UIButton *buttonGetWeibo;
    IBOutlet UIButton *buttonSendWeibo;
    IBOutlet UIButton *buttonYanZheng;
    IBOutlet UIButton *buttonLoginOut;
    WeiboTableViewController *weiboListView;
}

-(void)setUserToken:(NSString *)token;
-(NSString *)getUserToken;
-(void)refreshWeibo;
-(void)addWeibo;
+(ViewController *)getInstance;
@property(nonatomic, strong) UserInfo *userInfo;
@end

static ViewController *viewControllerInstance;
