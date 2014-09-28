//
//  WeMyFundingSupportsViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-8-8.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeMyFundingSupportsViewController.h"

@interface WeMyFundingSupportsViewController () {
    UIActivityIndicatorView * sys_pendingView;
    UITableView * sys_tableView;
    UIButton * refreshButton;
    
    NSMutableArray * supports;
}

@end

@implementation WeMyFundingSupportsViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path
{
    WeMyFundingSupportDetailViewController * vc = [[WeMyFundingSupportDetailViewController alloc] init];
    vc.currentFunding = self.currentFunding;
    vc.currentLevel = self.currentLevel;
    vc.currentFundingSupport = supports[path.section];
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView rowHeight];
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 20 + 64;
    return 5;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) return self.tabBarController.tabBar.frame.size.height + 20;
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
    return [supports count];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    cell.opaque = NO;
    cell.backgroundColor = We_background_cell_general;
    
    WeFundingSupport * currentSupport = supports[indexPath.section];
    
    [cell.textLabel setFont:We_font_textfield_zh_cn];
    [cell.textLabel setTextColor:We_foreground_black_general];
    [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
    [cell.detailTextLabel setTextColor:We_foreground_gray_general];
    
    [cell.textLabel setText:currentSupport.supporter.userName];
    [cell.detailTextLabel setText:[WeAppDelegate transitionToDateFromSecond:[currentSupport.supportId longLongValue] / 100000]];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Navigation bar
    self.navigationItem.title = @"支持人列表";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"支持人列表" style:UIBarButtonItemStylePlain target:self action:nil];
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [sys_tableView setHidden:YES];
    [self.view addSubview:sys_tableView];
    
    // 刷新按钮
    refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshButton.frame = self.view.frame;
    [refreshButton setTitle:@"获取众筹支持方案列表失败，点击刷新" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButton_onPress) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTintColor:We_foreground_red_general];
    [self.view addSubview:refreshButton];
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    [self api_doctor_listSupports];
}

#pragma mark - Callbacks

- (void)refreshButton_onPress {
    [self api_doctor_listSupports];
}

#pragma mark - APIs

- (void)api_doctor_listSupports {
    [sys_pendingView startAnimating];
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];
    
    [WeAppDelegate postToServerWithField:@"doctor"
                                  action:@"listSupports"
                              parameters:@{
                                           @"fundingLevelId":self.currentLevel.levelId
                                           }
                                 success:^(id response) {
//                                     NSLog(@"%@", response);
                                     supports = [[NSMutableArray alloc] init];
                                     for (int i = 0; i < [response count]; i++) {
                                         [supports addObject:[[WeFundingSupport alloc] initWithNSDictionary:response[i]]];
                                     }
                                     
                                     
                                     [sys_tableView reloadData];
                                     
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
