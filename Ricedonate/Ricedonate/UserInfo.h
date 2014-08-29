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
    NSString *access_token;
    //NSMutableDictionary *weibo_list;
    NSMutableArray *weibo_list;
    int status;//用户状态
}

-(void)set_token:(NSString *) token;
-(NSString *)get_token;
-(void)set_weibo_list:(NSArray *) dic;
-(NSMutableArray *)get_weibo_list;
-(void)reset;
-(int)getStatus;
-(NSString *)returnStringLable:(NSString *)string Row:(int)Row;
+(UserInfo *)getInstance;
@property(nonatomic, strong) NSString *_access_token;
@end

static UserInfo *instance;//使类持有该实例
