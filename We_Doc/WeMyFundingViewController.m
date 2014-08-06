//
//  WeMyFundingViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-8-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeMyFundingViewController.h"

@interface WeMyFundingViewController () {
    UIActivityIndicatorView * sys_pendingView;
    UITableView * sys_tableView;
    UIButton * refreshButton;
    
    NSMutableArray * fundingList;
}

@end

@implementation WeMyFundingViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path
{
    /*WeFunDetViewController * vc = [[WeFunDetViewController alloc] init];
    vc.currentFundingId = [(WeFunding *)fundingList[path.section] fundingId];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:path animated:YES];*/
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[WeFundingCard alloc] initWithWeFunding:(WeFunding *)fundingList[indexPath.section]].frame.size.height;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 10 + 64;
    return 9;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 10 + self.tabBarController.tabBar.frame.size.height;
    }
    return 1;
}
// 询问每个段落的尾部标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return [fundingList count];
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return 1;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    cell.opaque = NO;
    cell.backgroundColor = [UIColor clearColor];
    
    // 当前处理的众筹
    WeFunding * currentFunding = fundingList[indexPath.section];
    
    [cell.contentView addSubview:[[WeFundingCard alloc] initWithWeFunding:currentFunding]];
    
    return cell;
}

#pragma mark - View related

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 刷新按钮
    refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshButton.frame = self.view.frame;
    [refreshButton setTitle:@"获取加号记录列表失败，点击刷新" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButton_onPress) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTintColor:We_foreground_red_general];
    [self.view addSubview:refreshButton];
    
    [self api_doctor_listFunding];
}

#pragma mark - Callbacks

- (void)refreshButton_onPress {
    [self api_doctor_listFunding];
}

#pragma mark - APIs

- (void)api_doctor_listFunding {
    [sys_pendingView startAnimating];
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];
    
    [WeAppDelegate postToServerWithField:@"doctor"
                                  action:@"listFunding"
                              parameters:nil
                                 success:^(id response) {
                                     fundingList = [[NSMutableArray alloc] init];
                                     for (int i = 0; i < [response count]; i++) {
                                         [fundingList addObject:[[WeFunding alloc] initWithNSDictionary:response[i]]];
                                     }
                                     
                                     [sys_tableView setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     NSLog(@"\nerror:%@", errorMessage);
                                     [refreshButton setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
     ];
}

@end
