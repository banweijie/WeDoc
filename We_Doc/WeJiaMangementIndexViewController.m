//
//  WeJiaMangementIndexViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-7-16.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeJiaMangementIndexViewController.h"

@interface WeJiaMangementIndexViewController () {
    UITableView * sys_tableView;
    UIButton * refreshButton;
    UIActivityIndicatorView * sys_pendingView;
    
    NSMutableArray * jiahaoList;
}

@end

@implementation WeJiaMangementIndexViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    WeJiahaoDetailViewController * vc = [[WeJiahaoDetailViewController alloc] init];
    vc.currentJiahao = jiahaoList[path.section][path.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tv.rowHeight * 2;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 30;
    return 30;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    [view setBackgroundColor:We_background_red_general];
    UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
    l1.font = We_font_textfield_zh_cn;
    l1.textColor = We_foreground_white_general;
    l1.text = [[(WeJiahao *)jiahaoList[section][0] date] substringToIndex:10];
    [view addSubview:l1];
    return view;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) {
        return 1 + self.tabBarController.tabBar.frame.size.height;
    }
    return 1;
}
// 询问每个段落的尾部标题
- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部
-(UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section{
    //if (section == 1) return sys_countDown_demo;
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return [jiahaoList count];
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return [jiahaoList[section] count];
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
    
    WeJiahao * currentJiahao = jiahaoList[indexPath.section][indexPath.row];
    
    UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 60, 60)];
    [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(currentJiahao.patient.avatarPath)]];
    [avatarView.layer setCornerRadius:30];
    [avatarView.layer setMasksToBounds:YES];
    [cell.contentView addSubview:avatarView];
    
    UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(80, 14, 200, 20)];
    [l1 setFont:We_font_textfield_large_zh_cn];
    [l1 setTextColor:We_foreground_black_general];
    [l1 setTextAlignment:NSTextAlignmentLeft];
    [l1 setText:currentJiahao.patient.userName];
    [cell.contentView addSubview:l1];
    
    /*
     UILabel * l2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 38, 200, 40)];
     [l2 setFont:We_font_textfield_zh_cn];
     [l2 setTextColor:We_foreground_gray_general];
     [l2 setTextAlignment:NSTextAlignmentLeft];
     [l2 setText:currentOrder.date];
     [cell.contentView addSubview:l2];
     */
    
    UILabel * l3 = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 200, 40)];
    [l3 setNumberOfLines:0];
    [l3 setFont:We_font_textfield_large_zh_cn];
    [l3 setTextColor:We_foreground_gray_general];
    [l3 setTextAlignment:NSTextAlignmentLeft];
    [l3 setText:currentJiahao.dateToDemo];
    [cell.contentView addSubview:l3];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    /*
    UILabel * l3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 260, 40)];
    [l3 setFont:We_font_textfield_large_zh_cn];
    [l3 setTextColor:We_foreground_black_general];
    [l3 setTextAlignment:NSTextAlignmentRight];
    [l3 setText:[NSString stringWithFormat:@"￥%.0f", currentOrder.amount]];
    [cell.contentView addSubview:l3];
    
    UILabel * l4 = [[UILabel alloc] initWithFrame:CGRectMake(20, 38, 260, 40)];
    [l4 setFont:We_font_textfield_zh_cn];
    if ([currentOrder.status isEqualToString:@"C"]) {
        [l4 setTextColor:We_foreground_gray_general];
        [l4 setText:@"交易取消"];
    }
    else if ([currentOrder.status isEqualToString:@"W"]) {
        [l4 setTextColor:We_foreground_red_general];
        [l4 setText:@"等待支付"];
    }
    else if ([currentOrder.status isEqualToString:@"P"]) {
        [l4 setTextColor:We_foreground_black_general];
        [l4 setText:@"交易完成"];
    }
    [l4 setTextAlignment:NSTextAlignmentRight];
    [cell.contentView addSubview:l4];*/
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
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
    // 标题
    self.navigationItem.title = @"加号管理";
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView.layer setCornerRadius:10];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    // 刷新按钮
    refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshButton.frame = self.view.frame;
    [refreshButton setTitle:@"获取加号记录列表失败，点击刷新" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButton_onPress) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTintColor:We_foreground_red_general];
    [self.view addSubview:refreshButton];
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
    
    // 加号申请按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"加号申请" style:UIBarButtonItemStylePlain target:self action:@selector(jiahaoApplyButton_onPress)];
    
    // 访问获取众筹详情列表
    [self api_doctor_listJiahao];
}

- (void)viewWillAppear:(BOOL)animated {
    [self api_doctor_listJiahao];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshButton_onPress {
    [self api_doctor_listJiahao];
}

- (void)jiahaoApplyButton_onPress {
    WeNewJiahaoApplyIndexViewController * vc = [[WeNewJiahaoApplyIndexViewController alloc]  init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)api_doctor_listJiahao {
    [sys_pendingView startAnimating];
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];
    
    [WeAppDelegate postToServerWithField:@"doctor" action:@"listJiahao"
                              parameters:@{
                                           @"status":@"J"
                                           }
                                 success:^(id response) {
                                     jiahaoList = [self preworkOnJiahaoList:[NSMutableArray arrayWithArray:response]];
                                     [sys_tableView reloadData];
                                     [sys_tableView setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     NSLog(@"%@", errorMessage);
                                     [refreshButton setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }];
}

- (NSMutableArray *)preworkOnJiahaoList:(id)response {
    NSMutableArray * sourceData = [[NSMutableArray alloc] init];
    for (int i = 0; i < [response count]; i ++) {
        [sourceData addObject:[[WeJiahao alloc] initWithNSDictionary:response[i]]];
    }
    
    [sourceData sortUsingComparator:^NSComparisonResult(id rA, id rB) {
        return [[(WeJiahao *)rB date] compare: [(WeJiahao *)rA date]];
    }];
    
    NSMutableArray * tableViewData0 = [[NSMutableArray alloc] init];
    tableViewData0 = [[NSMutableArray alloc] init];
    int j = -1;
    for (int i = 0; i < [sourceData count]; i ++) {
        if (i == 0 || ![[[(WeJiahao *)sourceData[i] date] substringToIndex:10] isEqualToString:[[(WeJiahao *)sourceData[i - 1] date] substringToIndex:10]]) {
            j ++;
            tableViewData0[j] = [[NSMutableArray alloc] init];
        }
        [tableViewData0[j] addObject:sourceData[i]];
    }
    
    return tableViewData0;
}
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
