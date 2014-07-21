//
//  WeFunSelViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunSelViewController.h"

@interface WeFunSelViewController () {
    UITableView * sys_tableView;
    
    NSMutableString * sel_type;
    NSMutableString * sel_topSectionId;
    NSMutableString * sel_topSectionName;
    NSMutableString * sel_secSectionId;
    NSMutableString * sel_secSectionName;
}

@end

@implementation WeFunSelViewController

@synthesize lastSel_type;
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        WeFunSelTypeViewController * vc = [[WeFunSelTypeViewController alloc] init];
        vc.lastSel_type = sel_type;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        WeFunSelTopSecViewController * vc = [[WeFunSelTopSecViewController alloc] init];
        vc.lastSel_topSectionId = sel_topSectionId;
        vc.lastSel_topSectionName = sel_topSectionName;
        vc.lastSel_secSectionId = sel_secSectionId;
        vc.lastSel_secSectionName = sel_secSectionName;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        WeFunIdxViewController * vc = (WeFunIdxViewController *) self.originVC;
        [lastSel_type setString:sel_type];
        [lastSel_topSectionId setString:sel_topSectionId];
        [lastSel_topSectionName setString:sel_topSectionName];
        [lastSel_secSectionId setString:sel_secSectionId];
        [lastSel_secSectionName setString:sel_secSectionName];
        [vc api_data_listFunding];
        [self dismissViewControllerAnimated:YES completion:nil];
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
    return 2;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 2;
    if (section == 1) return 1;
    return 1;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
        }
    }
    cell.opaque = NO;
    cell.backgroundColor = We_background_cell_general;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell.textLabel setText:@"众筹类别"];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        [cell.detailTextLabel setText:[WeAppDelegate transitionOfFundingType:sel_type]];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        [cell.textLabel setText:@"医生科室"];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        if ([sel_secSectionId isEqualToString:@""]) {
            [cell.detailTextLabel setText:sel_topSectionName];
        }
        else {
            [cell.detailTextLabel setText:sel_secSectionName];
        }
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [cell.textLabel setText:@"开始筛选"];
        [cell.textLabel setFont:We_font_textfield_large_zh_cn];
        [cell.textLabel setTextColor:We_foreground_white_general];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell setBackgroundColor:We_background_red_tableviewcell];
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
    [self.navigationItem setTitle:@"筛选设置"];
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
    
    // 取消按钮
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton_onPress:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    // 重设按钮
    UIBarButtonItem * resetButton = [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(resetButton_onPress:)];
    self.navigationItem.rightBarButtonItem = resetButton;
    
    // 筛选条件初始化
    sel_type = [NSMutableString stringWithString:lastSel_type];
    sel_topSectionId = [NSMutableString stringWithString:lastSel_topSectionId];
    sel_topSectionName = [NSMutableString stringWithString:lastSel_topSectionName];
    sel_secSectionId = [NSMutableString stringWithString:lastSel_secSectionId];
    sel_secSectionName = [NSMutableString stringWithString:lastSel_secSectionName];
}

- (void)viewWillAppear:(BOOL)animated {
    [sys_tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelButton_onPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetButton_onPress:(id)sender {
    [self resetSelectCondition];
}

- (void)resetSelectCondition {
    [sel_type setString:@""];
    [sel_topSectionId setString:@""];
    [sel_topSectionName setString:@"全部"];
    [sel_secSectionId setString:@""];
    [sel_secSectionName setString:@"全部"];
    [sys_tableView reloadData];
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
