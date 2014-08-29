//
//  TextWeibo.h
//  Ricedonate
//
//  Created by megil on 8/28/14.
//  Copyright (c) 2014 megil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
#define kAppKey         @"3770602938"
#define kRedirectURI    @"http://www.sina.com"

@interface TestWeibo : NSObject<WeiboSDKDelegate>
-(void)testWBAuthorizeRequest;
@end
