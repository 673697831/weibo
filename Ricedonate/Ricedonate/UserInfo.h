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
    NSString *__lastWeibo;
    int total_number;
}

-(void)set_token:(NSString *) token;
-(NSString *)get_token;
-(void)set_weibo_list:(NSArray *) array;
-(NSMutableArray *)get_weibo_list;
-(void)reset;
-(int)getStatus;
-(void)setTotalNumber:(int) number;
-(int)getTotalNumber;
-(NSString *)getLastWeibo;
-(void)addWeibo:(NSArray *) array;
-(NSString *)returnStringLable:(NSString *)string Row:(int)Row;
@property(nonatomic, strong) NSString *_access_token;
@end
