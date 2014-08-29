//
//  UserInfo.m
//  Ricedonate
//
//  Created by megil on 8/28/14.
//  Copyright (c) 2014 megil. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
-(id)init
{
    self = [super init];
    [self reset];
    instance = self;
    return self;
}

-(void)set_token:(NSString *)token
{
    access_token = token;
    status = 1;
}

-(NSString *)get_token
{
    return access_token;
}
-(void)reset
{
    status = -1;
}
-(int)getStatus
{
    return status;
}

-(void)set_weibo_list:(NSArray *) array
{
    if (!weibo_list) {
        //weibo_list = [[NSMutableDictionary alloc] initWithDictionary:[dic objectForKey:@"statuses"]];
        weibo_list = [[NSMutableArray alloc]initWithArray:array];
    }
    else
    {
        [weibo_list removeAllObjects];
        //合并两个字典
        [weibo_list addObjectsFromArray:array];
    }    
}

-(NSMutableArray *)get_weibo_list
{
    if (!weibo_list) {
        weibo_list = [[NSMutableArray alloc] init];
    }
    return weibo_list;
}

-(NSString *)returnStringLable:(NSString *)string Row:(int)Row
{
    NSMutableString *tempString = [[NSMutableString alloc]init];
    
//    if ([string isEqualToString:@"time"])
//    {
//        NSString *time_hour;
//        NSString *time_min;
//        if([[[tempDataSourceArray objectAtIndex:Row] objectForKey:@"hour"] intValue]<10)
//        {
//            time_hour = [NSString stringWithFormat:@"0%@",[[tempDataSourceArray objectAtIndex:Row] objectForKey:@"hour"]];
//        }
//        else
//        {
//            time_hour = [NSString stringWithFormat:@"%@",[[tempDataSourceArray objectAtIndex:Row] objectForKey:@"hour"]];
//        }
//        if([[[tempDataSourceArray objectAtIndex:Row] objectForKey:@"min"] intValue]<10)
//        {
//            time_min = [NSString stringWithFormat:@"0%@",[[tempDataSourceArray objectAtIndex:Row] objectForKey:@"min"]];
//        }
//        else
//        {
//            time_min = [NSString stringWithFormat:@"%@",[[tempDataSourceArray objectAtIndex:Row] objectForKey:@"min"]];
//        }
//        tempString = [NSMutableString stringWithFormat:@"%@:%@",time_hour,time_min];
//    }
//    
//    if ([string isEqualToString:@"select"])
//    {
//        tempString = nil;
//        
//        if ([[tempDataSourceArray objectAtIndex:Row] objectForKey:@"select"]== [NSNumber numberWithBool:YES] )
//        {
//            tempString = [NSMutableString stringWithString:@"YES"];
//        }
//        else
//        {
//            tempString = [NSMutableString stringWithString:@"NO"];
//        }
//        
//    }
//    
//    if ([string isEqualToString:@"week"])
//    {
//        tempString = nil;
//        tempString = [NSMutableString stringWithString:@""];
//        
//        if ([[tempDataSourceArray objectAtIndex:Row] objectForKey:@"1"]== [NSNumber numberWithBool:YES] ) {
//            [tempString appendString:@"星期一 "];
//            
//        }
//        if ([[tempDataSourceArray objectAtIndex:Row] objectForKey:@"2"]== [NSNumber numberWithBool:YES] ) {
//            [tempString appendString:@"星期二 "];
//            
//        }
//        
//        if ([[tempDataSourceArray objectAtIndex:Row] objectForKey:@"3"]== [NSNumber numberWithBool:YES] ) {
//            [tempString appendString:@"星期三 "];
//            
//        }
//        if ([[tempDataSourceArray objectAtIndex:Row] objectForKey:@"4"]== [NSNumber numberWithBool:YES] ) {
//            [tempString appendString:@"星期四 "];
//            
//        }
//        if ([[tempDataSourceArray objectAtIndex:Row] objectForKey:@"5"]== [NSNumber numberWithBool:YES] ) {
//            [tempString appendString:@"星期五 "];
//            
//        }
//        if ([[tempDataSourceArray objectAtIndex:Row] objectForKey:@"6"]== [NSNumber numberWithBool:YES] ) {
//            [tempString appendString:@"星期六 "];
//            
//        }
//        if ([[tempDataSourceArray objectAtIndex:Row] objectForKey:@"7"]== [NSNumber numberWithBool:YES] ) {
//            [tempString appendString:@"星期日"];
//            
//        }
//        if (tempString.length >26)
//        {
//            tempString = nil;
//            tempString = [NSMutableString stringWithString:@"每天"];
//        }
//        if (tempString.length < 1)
//        {
//            tempString = nil;
//            tempString = [NSMutableString stringWithString:@"未设置"];
//        }
//    }
    return tempString;
}

+(UserInfo *)getInstance
{
    return instance;
}
@end


