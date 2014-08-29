//
//  AppDelegate.h
//  Ricedonate
//
//  Created by megil on 8/28/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, WeiboSDKDelegate>
{
    ViewController *viewController;
}
@property (strong, nonatomic) UIWindow *window;

@end
