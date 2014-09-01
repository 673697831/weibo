//
//  UserInfo.h
//  Ricedonate
//
//  Created by megil on 8/28/14.
//  Copyright (c) 2014 megil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
{
    NSString *__access_token;
    NSMutableArray *__weiboList;
    int __status;//用户状态
    int64_t __lastWeibo;
    int __totalNumber;
}

-(void)reset;
-(void)addWeibo:(NSArray *) array;
-(void)resetWeibo:(NSArray *)array;
@property(nonatomic, strong) NSString *accessToken;
@property(nonatomic, strong) NSMutableArray *weiboList;
@property(nonatomic, assign) int64_t lastWeibo;
@property(nonatomic, assign) int totalNumber;
@property(nonatomic, assign) int status;

@end
