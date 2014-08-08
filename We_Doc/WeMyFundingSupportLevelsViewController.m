//
//  WeMyFundingSupportLevelsViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-8-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeMyFundingSupportLevelsViewController.h"

@interface WeMyFundingSupportLevelsViewController () {
    UIActivityIndicatorView * sys_pendingView;
    UITableView * sys_tableView;
    UIButton * refreshButton;

    NSMutableArray * levels;
}

@end

@implementation WeMyFundingSupportLevelsViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path
{
    WeMyFundingSupportsViewController * vc = [[WeMyFundingSupportsViewController alloc] init];
    vc.currentLevel = levels[path.section];
    vc.currentFunding = self.currentFunding;
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeFundingLevel * currentLevel = levels[indexPath.section];
    return [WeAppDelegate calcSizeForString:currentLevel.repay Font:We_font_textfield_zh_cn expectWidth:280].height + 80;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 20 + 64;
    return 19;
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
    return [levels count];
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
    cell.backgroundColor = We_background_cell_general;
    
    // 当前处理的支持方案
    WeFundingLevel * currentLevel = levels[indexPath.section];
    
    UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 220 - 16, 60)];
    if ([currentLevel.type isEqualToString:@"C"]) {
        l1.text = [NSString stringWithFormat:@"咨询档 ￥%@", currentLevel.money];
    }
    else if ([currentLevel.type isEqualToString:@"E"]) {
        l1.text = currentLevel.way;
    }
    else {
        l1.text = [NSString stringWithFormat:@"支持 ￥%@", currentLevel.money];
    }
    l1.font = We_font_textfield_large_zh_cn;
    l1.textColor = We_foreground_red_general;
    [cell.contentView addSubview:l1];
    
    UILabel * supportButton = [[UILabel alloc] init];
    [supportButton setFrame:CGRectMake(180, 15, 120, 30)];
    if ([currentLevel.limit isEqualToString:@"0"]) {
        [supportButton setText:[NSString stringWithFormat:@"当前支持(%@)", currentLevel.supportCount]];
    }
    else {
        [supportButton setText:[NSString stringWithFormat:@"当前支持(%@/%@)", currentLevel.supportCount, currentLevel.limit]];
    }
    [supportButton setTextAlignment:NSTextAlignmentCenter];
    [supportButton setBackgroundColor:We_foreground_red_general];
    [supportButton setTextColor:We_foreground_white_general];
    [supportButton setFont:We_font_textfield_zh_cn];
    [supportButton.layer setCornerRadius:supportButton.frame.size.height / 2];
    [supportButton.layer setMasksToBounds:YES];
    [cell.contentView addSubview:supportButton];
    
    NSString * repayText;
    if ([currentLevel.type isEqualToString:@"C"]) {
        repayText = @"用户通过支持众筹获得一次咨询机会";
    }
    else {
        repayText = currentLevel.repay;
    }
    
    CGSize sizezz = [WeAppDelegate calcSizeForString:repayText Font:We_font_textfield_zh_cn expectWidth:280];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 60, sizezz.width, sizezz.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = repayText;
    label.font = We_font_textfield_zh_cn;
    label.textColor = We_foreground_gray_general;
    [cell.contentView addSubview:label];
    
    return cell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Navigation bar
    self.navigationItem.title = @"支持方案";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"支持方案" style:UIBarButtonItemStylePlain target:self action:nil];
    
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
    
    [self api_data_viewFunding];
}


#pragma mark - Callbacks

- (void)refreshButton_onPress {
    [self api_data_viewFunding];
}

#pragma mark - APIs

- (void)api_data_viewFunding {
    [sys_pendingView startAnimating];
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];

    [WeAppDelegate postToServerWithField:@"data"
                                  action:@"viewFunding"
                              parameters:@{
                                           @"fundingId":self.currentFunding.fundingId
                                           }
                                 success:^(id response) {
                                     NSLog(@"%@", response);
                                     [self.currentFunding setWithNSDictionary:response];
                                     
                                     levels = [[NSMutableArray alloc] init];
                                     for (int i = 0; i < [self.currentFunding.levels count]; i++) {
                                         WeFundingLevel * currentLevel = self.currentFunding.levels[i];
                                         if ([currentLevel.type isEqualToString:@"B"] || [currentLevel.type isEqualToString:@"C"] || [currentLevel.type isEqualToString:@"E"]) {
                                             [levels addObject:currentLevel];
                                         }
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
