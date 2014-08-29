//
//  WeiboListController.m
//  Ricedonate
//
//  Created by megil on 8/29/14.
//  Copyright (c) 2014 megil. All rights reserved.
//

#import "WeiboListController.h"
#import "UserInfo.h"
@implementation WeiboListController
-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Basic demo";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        
        // Add a series of number
        array = [[NSMutableArray alloc] init];
        UserInfo *userInfo = [UserInfo getInstance];
        NSMutableArray *weibos = [userInfo get_weibo_list];
        
        for (NSDictionary *dic in weibos) {
            NSString *st = [dic objectForKey:@"text"];
            NSLog(@"%@", st);
            [array addObject:st];
        }
//        for (int k=0;k<100;k++) {
//            [array addObject:[NSString stringWithFormat:@"Test row number %d", k]];
//        }
    }
    return self;
}

#pragma mark - Basic use for the info panel

-(void)viewDidLoad {
    [super viewDidLoad];
    infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 4, 140, 20)];
    infoLabel.font = [UIFont boldSystemFontOfSize:12];
    
    infoLabel.textAlignment = UITextAlignmentLeft;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.shadowColor = [UIColor blackColor];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.shadowOffset = CGSizeMake(0, 1);
    // [self.infoPanel addSubview:infoLabel] // this will not work, too early to add
}

-(void)infoPanelWillAppear:(UIScrollView *)scrollView {
    if (![infoLabel superview]) [self.infoPanel addSubview:infoLabel];
}

-(void)infoPanelDidScroll:(UIScrollView *)scrollView atPoint:(CGPoint)point {
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
    infoLabel.text = [NSString stringWithFormat:@"Something about %d", indexPath.row];
}

#pragma mark - Give table some content

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    int rowIndex = [indexPath row];
//    UserInfo *userInfo = [UserInfo getInstance];
//    NSMutableArray *weibos = [userInfo get_weibo_list];
//    NSString *text = weibos[rowIndex];
//    CGSize constraint = CGSizeMake(300, 2000.f);
//    //先设置一个约束，这个是为了在宽度一定的时候计算text内容所占视图的大小
//    //高度尽量设的大一下，因为你不确定text具体内容有多少
//    CGSize size= [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
//    //这里利用NSString的一个方法来计算text所占大小,
//    //感谢NSString为我们封装了这个方法，使得这个功能得以实现
//    
//    CGFloat height = MAX(size.height,40.0f);
//    //这里是为了给单元格高度设置一个最低限度
//    
//    return height;
//}
@end
