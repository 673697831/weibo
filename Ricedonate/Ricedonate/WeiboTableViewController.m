//
//  WeiboTableViewController.m
//  Ricedonate
//
//  Created by megil on 8/29/14.
//  Copyright (c) 2014 megil. All rights reserved.
//

#import "WeiboTableViewController.h"
#import "ViewController.h"
@interface WeiboTableViewController ()
- (void)refrushArray;
@end

@implementation WeiboTableViewController

- (void)refrushArray
{
    [array removeAllObjects];
    UserInfo *userInfo = [ViewController getInstance].userInfo;
    NSMutableArray *weibos = [userInfo weiboList];
    for (NSDictionary *dic in weibos) {
        NSString *st = [dic objectForKey:@"text"];
        //NSLog(@"%@", st);
        [array addObject:st];
    }
}

- (void)Update
{
    [self.refreshControl endRefreshing];
    [self refrushArray];
    [self.tableView reloadData];
    __isLoading = NO;
}

- (void)testArray
{
    [array removeAllObjects];
    for (int i=0; i<100; i++) {
        [array addObject:[NSString stringWithFormat:@"%d", i]];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
        if (self) {
            self.title = @"微博列表";
            self.tabBarItem.image = [UIImage imageNamed:@"first"];
            array = [[NSMutableArray alloc] init];
            [self refrushArray];
            __isLoading = NO;
        }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(handleData) forControlEvents:UIControlEventValueChanged];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //NSLog(@"cellforrowatindexpath");
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    return cell;
}

- (void) handleData
{
    //NSLog(@"refreshed");
//    [self.refreshControl endRefreshing];
//    
//    //self.count++;
//    [self.tableView reloadData];
    [[ViewController getInstance].userInfo reset];
    [[ViewController getInstance] refreshWeibo];
}

//-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.row!=0)
//    {
//        return 360;
//    }
//    else
//    {
//        return 44;
//    }
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//    NSLog(@"F:%d T:%d", [fromIndexPath row], [toIndexPath row]);
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"F:%f S:%f F:%f", scrollView.contentSize.height, self.tableView.contentSize.height, scrollView.contentOffset.y);
    if (!__isLoading) { // 判断是否处于刷新状态，刷新中就不执行
        
        // 取内容的高度：
        //    如果内容高度大于UITableView高度，就取TableView高度
        //    如果内容高度小于UITableView高度，就取内容的实际高度
        if ([array count] >= [[ViewController getInstance].userInfo totalNumber]) {
            return;
        }
        
        float height = scrollView.contentSize.height > self.tableView.frame.size.height ? self.tableView.frame.size.height : scrollView.contentSize.height;
        
        if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.1) {
            // 调用上拉刷新方法
            [[ViewController getInstance] addWeibo];
            __isLoading = YES;
        }
        
//        if (- scrollView.contentOffset.y / _tableView.frame.size.height > 0.2) {
//            // 调用下拉刷新方法
//        }
    }
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
