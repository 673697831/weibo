//
//  UserInfo.m
//  Ricedonate
//
//  Created by megil on 8/28/14.
//  Copyright (c) 2014 megil. All rights reserved.
//

#import "UserInfo.h"
@interface UserInfo ()
-(void)findMaxIndex;
@end
@implementation UserInfo
@synthesize accessToken = __accessToken;
@synthesize weiboList = __weiboList;
@synthesize status = __status;
@synthesize lastWeibo = __lastWeibo;
@synthesize totalNumber = __totalNumber;
-(void)findMaxIndex
{
    for (NSDictionary *dic in self.weiboList) {
        int64_t num = [[dic objectForKey:@"id"] longLongValue];
        if (self.lastWeibo == 0 || num < self.lastWeibo) {
            self.lastWeibo = num;
        }
    }
   // NSLog(@"%@", __lastWeibo);
}

-(id)init
{
    self = [super init];
    self.lastWeibo = 0;
    self.status = -1;
    self.totalNumber = 0;
    self.weiboList = [[NSMutableArray alloc] init];
    return self;
}

-(void)reset
{
    self.lastWeibo = 0;
    self.totalNumber = 0;
}

-(void)addWeibo:(NSArray *)array
{
    for (NSDictionary *dic in array) {
        int64_t num = [[dic objectForKey:@"id"] longLongValue];
        if (num != self.lastWeibo) {
            [self.weiboList addObject:dic];
        }
    }
    [self findMaxIndex];
}
-(void)resetWeibo:(NSArray *)array
{
    [self.weiboList removeAllObjects];
    [self addWeibo:array];
}

@end


