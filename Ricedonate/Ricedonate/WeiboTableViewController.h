//
//  WeiboTableViewController.h
//  Ricedonate
//
//  Created by megil on 8/29/14.
//  Copyright (c) 2014 megil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
@interface WeiboTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
{
    UserInfo *userInfo;
    NSMutableArray * array;
}

-(void)setUserInfo:(NSDictionary *)tmpInfo;
@end
