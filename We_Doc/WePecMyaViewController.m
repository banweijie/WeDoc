//
//  WePecMyaViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-7-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePecMyaViewController.h"

#import "WePecRechViewController.h"

#import "MJRefresh.h"

#define LABEX 5
#define LABEY 5

@interface WePecMyaViewController () <MJRefreshBaseViewDelegate>{
    UIActivityIndicatorView * sys_pendingView;
    UITableView * sys_tableView;

    NSString * amount;
    
    NSMutableArray *acountListArr;
    
    
    MJRefreshFooterView *_footer;//底部上拉刷新
    
    int from;//请求数据from开始
    int num;//请求num条数据
}

@end

@implementation WePecMyaViewController

#pragma mark - TableView
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
//    if (path.section==1 && path.row==0) {
//        WePecRechViewController *rech=[[WePecRechViewController alloc]init];
//        
//        [self.navigationController pushViewController:rech animated:YES];
//    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        return 60;
    }
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 20 ;
    if (section == 2) return 40;
    return 20;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    if (section==2) {
        return @"历史账单";
    }
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
// 询问每个段落的尾部标题
- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部
-(UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section{
    
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 2;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
//        case 1:
//            return 1;
//            break;
        case 1:
            return acountListArr.count;
            break;
    }
    return 1;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.font = We_font_textfield_zh_cn;
    cell.detailTextLabel.font = We_font_textfield_zh_cn;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"余额";
        cell.detailTextLabel.text = amount;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.detailTextLabel.textColor = We_foreground_gray_general;
    }
//    if (indexPath.section == 1 && indexPath.row == 0) {
//        cell.textLabel.text = @"充值";
//        cell.textLabel.textColor = We_foreground_white_general;
//        cell.backgroundColor = We_background_red_tableviewcell;
//    }
    if (indexPath.section == 1) {
        
//        cell.textLabel.text = acountListArr[indexPath.row][@"description"];
        UILabel *desc=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 20)];
        desc.font=We_font_textfield_zh_cn;
        [desc setTextColor:We_foreground_black_general];
        [desc setTextAlignment:NSTextAlignmentLeft];
        desc.text=acountListArr[indexPath.row][@"description"];
        [cell.contentView addSubview:desc];
        

        UILabel * l2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 200, 20)];
        [l2 setFont:We_font_textfield_tiny_zh_cn];
        [l2 setTextColor:We_foreground_gray_general];
        [l2 setTextAlignment:NSTextAlignmentLeft];
        long long tim=[acountListArr[indexPath.row][@"time"] longLongValue];
        [l2 setText:[WeAppDelegate transitionToDateFromSecond:(tim/1000)]];
        [cell.contentView addSubview:l2];
        
        UILabel * l3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 260, 30)];
        [l3 setFont:[UIFont boldSystemFontOfSize:16]];
        [l3 setTextColor:We_foreground_black_general];
        [l3 setTextAlignment:NSTextAlignmentRight];
        float mon=[acountListArr[indexPath.row][@"amount"] floatValue];
        if (mon>=0) {
            [l3 setText:[NSString stringWithFormat:@"+%2.f",mon]];
        }
        else
        {
            [l3 setText:[NSString stringWithFormat:@"%.2f",mon]];
        }
        
        [cell.contentView addSubview:l3];
        
        cell.backgroundColor = We_background_cell_general;
        
    }
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    num=10;
    
    acountListArr =[NSMutableArray array];
    
    self.navigationItem.title = @"财务信息";
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64-49) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:sys_tableView];
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = sys_tableView;
    footer.delegate = self;
    _footer = footer;
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-44-49-20)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    
}

#pragma mark - apis
- (void)api_user_viewAccount {
    [sys_pendingView startAnimating];
    [WeAppDelegate postToServerWithField:@"user" action:@"viewAccount"
                              parameters:@{
                                           }
                                 success:^(NSDictionary * response) {
                                     
                                     
                                     
                                     amount = [WeAppDelegate toString:response[@"amount"]];
                                   
                                     NSArray *arr= response[@"details"];
                                     if (acountListArr.count==0) {
                                         [acountListArr addObjectsFromArray:arr];
                                     }
                                     [sys_tableView reloadData];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                   initWithTitle:@"查询余额失败"
                                                                   message:errorMessage
                                                                   delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                     [notPermitted show];
                                     [sys_pendingView stopAnimating];
                                 }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self api_user_viewAccount];
}
#pragma mark - 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (!_footer.hidden) {
        from+=10;
    }else
    {
        from=0;
    }
    if (refreshView==_footer) {
        [WeAppDelegate postToServerWithField:@"user" action:@"listAccountDetails"
                                  parameters:@{
                                               @"from":@(from),
                                               @"num":@(num)
                                               }
                                     success:^(NSDictionary * response) {
                                         
                                         if ([response count]) {
                                             NSArray *arr= response[@"response"];
                                             
                                             [acountListArr addObjectsFromArray:arr];
                                             
                                             [sys_tableView reloadData];
                                             
                                             [sys_pendingView stopAnimating];
                                             
                                             _footer.hidden=(arr.count <10);
                                             return ;
                                         }
                                          [sys_pendingView stopAnimating];
                                     }
         
                                     failure:^(NSString * errorMessage) {
                                         UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                       initWithTitle:@"刷新列表失败"
                                                                       message:errorMessage
                                                                       delegate:nil
                                                                       cancelButtonTitle:@"OK"
                                                                       otherButtonTitles:nil];
                                         [notPermitted show];
                                         [sys_pendingView stopAnimating];
                                     }];

    }
    
    [sys_tableView reloadData];
         
    [refreshView endRefreshing];

}



@end
