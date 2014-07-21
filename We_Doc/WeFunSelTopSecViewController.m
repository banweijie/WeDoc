//
//  WeFunSelTopSecViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunSelTopSecViewController.h"

@interface WeFunSelTopSecViewController () {
    UITableView * sys_tableView;
    UIActivityIndicatorView * sys_pendingView;
    UIButton * refreshButton;
    
    NSArray * topSectionList;
}

@end

@implementation WeFunSelTopSecViewController

@synthesize lastSel_topSectionId;
@synthesize lastSel_topSectionName;
@synthesize lastSel_secSectionId;
@synthesize lastSel_secSectionName;

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [lastSel_topSectionId setString:@""];
        [lastSel_topSectionName setString:@"全部"];
        [lastSel_secSectionId setString:@""];
        [lastSel_secSectionName setString:@"全部"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        WeFunSelSecSecViewController * vc = [[WeFunSelSecSecViewController alloc] init];
        vc.lastSel_topSectionId = lastSel_topSectionId;
        vc.lastSel_topSectionName = lastSel_topSectionName;
        vc.lastSel_secSectionId = lastSel_secSectionId;
        vc.lastSel_secSectionName = lastSel_secSectionName;
        vc.sel_topSectionId = [NSString stringWithFormat:@"%@", topSectionList[indexPath.row - 1][@"id"]];
        vc.sel_topSectionName = [NSString stringWithFormat:@"%@", topSectionList[indexPath.row - 1][@"text"]];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView rowHeight];
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
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 20 + self.tabBarController.tabBar.frame.size.height;
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
    return 1;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return [topSectionList count] + 1;
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
    
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"全部"];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        if ([lastSel_topSectionId isEqualToString:@""]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
    else {
        [cell.textLabel setText:[WeAppDelegate toString:topSectionList[indexPath.row - 1][@"text"]]];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        if ([lastSel_topSectionId isEqualToString:[WeAppDelegate toString:topSectionList[indexPath.row - 1][@"id"]]]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
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
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 标题
    [self.navigationItem setTitle:@"一级科室"];
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor blackColor];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:0.5];
    [self.view addSubview:sys_pendingView];
    
    // 刷新按钮
    refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshButton.frame = self.view.frame;
    [refreshButton setTitle:@"获取一级科室列表失败，点击刷新" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTintColor:We_foreground_red_general];
    [self.view addSubview:refreshButton];
    
    // 获取一级科室列表
    [self api_data_listSections];
}

// 刷新按钮被按下
- (void)refreshButton_onPress:(id)sender {
    [self api_data_listSections];
}

// 获取一级科室列表接口
- (void)api_data_listSections {
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];
    [sys_pendingView startAnimating];
    
    [WeAppDelegate postToServerWithField:@"data" action:@"listSections"
                              parameters:nil
                                 success:^(id response) {
                                     topSectionList = response;
                                     [sys_tableView reloadData];
                                     [sys_tableView setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     [refreshButton setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
