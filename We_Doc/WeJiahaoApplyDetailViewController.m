//
//  WeJiahaoApplyDetailViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-7-16.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeJiahaoApplyDetailViewController.h"

@interface WeJiahaoApplyDetailViewController () {
    UIActivityIndicatorView * sys_pendingView;
    UITableView * sys_tableView;
    
    NSMutableString * dates;
    NSMutableString * datesToDemo;
}

@end

@implementation WeJiahaoApplyDetailViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 1 && path.row == 1) {
        WeCsrJiaChooseTimeViewController * vc = [[WeCsrJiaChooseTimeViewController alloc] init];
        vc.dates = dates;
        vc.datesToDemo = datesToDemo;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (path.section == 3 && path.row == 0) {
        [self api_doctor_updateJiahaoStatus_accept];
    }
    if (path.section == 4 && path.row == 0) {
        [self api_doctor_updateJiahaoStatus_reject:@"true"];
    }
    if (path.section == 5 && path.row == 0) {
        [self api_doctor_updateJiahaoStatus_reject:@"false"];
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) return 90;//tv.rowHeight * 2;
    if (indexPath.section == 1 && indexPath.row == 0) return 64;//tv.rowHeight * 1.5;
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 30;
    if (section == 1) return 50;
    if (section == 2) return 50;
    if (section == 4) return 10;
    if (section == 5) return 10;
    return 30;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    if (section == 1) return @"选择加号时间";
    if (section == 2) return @"加号预诊信息";
    return @"";
}
// 询问每个段落的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) {
        return 20 + self.tabBarController.tabBar.frame.size.height;
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
    return 6;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 3;
    if (section == 1) return 2;
    if (section == 2) return 2;
    if (section == 3) return 1;
    if (section == 4) return 1;
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
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 60, 60)];
        [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(self.currentJiahao.patient.avatarPath)]];
        [avatarView.layer setCornerRadius:30];
        [avatarView.layer setMasksToBounds:YES];
        [cell.contentView addSubview:avatarView];
        
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(80, 14, 200, 60)];
        [l1 setFont:We_font_textfield_large_zh_cn];
        [l1 setTextColor:We_foreground_black_general];
        [l1 setTextAlignment:NSTextAlignmentLeft];
        [l1 setText:self.currentJiahao.patient.userName];
        [cell.contentView addSubview:l1];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        [cell.textLabel setText:@"真实姓名"];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        [cell.detailTextLabel setText:self.currentJiahao.name];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        [cell.textLabel setText:@"身份证号"];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        [cell.detailTextLabel setText:self.currentJiahao.idNum];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setText:@"参考加号时间"];
        [cell.detailTextLabel setNumberOfLines:0];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        if ([self.currentJiahao.datesToDemo isEqualToString:@""]) {
            [cell.detailTextLabel setText:@"任意时刻均可"];
        }
        else {
            [cell.detailTextLabel setText:self.currentJiahao.datesToDemo];
        }
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        [cell.textLabel setNumberOfLines:0];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        if ([datesToDemo isEqualToString:@""]) {
            [cell.textLabel setText:@"尚未选择加号时间"];
        }
        else {
            [cell.textLabel setText:datesToDemo];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        [cell.textLabel setText:@"年龄"];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        [cell.detailTextLabel setText:self.currentJiahao.age];
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        [cell.textLabel setText:@"性别"];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        [cell.detailTextLabel setText:[WeAppDelegate transitionGenderFromChar:self.currentJiahao.gender]];
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        [cell setBackgroundColor:We_background_red_general];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_white_general];
        [cell.textLabel setText:@"接受加号"];
    }
    if (indexPath.section == 4 && indexPath.row == 0) {
        [cell setBackgroundColor:We_background_cell_general];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_red_general];
        [cell.textLabel setText:@"拒绝加号(并退款)"];
    }
    if (indexPath.section == 5 && indexPath.row == 0) {
        [cell setBackgroundColor:We_background_cell_general];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_red_general];
        [cell.textLabel setText:@"拒绝加号(不退款)"];
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
    
    // 标题
    self.navigationItem.title = @"加号申请详情";
    
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
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
    
    // 初始化
    dates = [[NSMutableString alloc] init];
    datesToDemo = [[NSMutableString alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [sys_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - apis
- (void)api_doctor_updateJiahaoStatus_accept {
    [sys_pendingView startAnimating];
    
    [WeAppDelegate postToServerWithField:@"doctor" action:@"updateJiahaoStatus"
                              parameters:@{
                                           @"jiahaoId":self.currentJiahao.jiahaoId,
                                           @"status":@"J",
                                           @"date":dates
                                           }
                                 success:^(id response) {
                                     [self.navigationController popViewControllerAnimated:YES];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     NSLog(@"%@", errorMessage);
                                     [[[UIAlertView alloc] initWithTitle:@"接受加号申请失败" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                     [sys_pendingView stopAnimating];
                                 }];
}
- (void)api_doctor_updateJiahaoStatus_reject:(NSString *)flag {
    [sys_pendingView startAnimating];
    
    [WeAppDelegate postToServerWithField:@"doctor" action:@"updateJiahaoStatus"
                              parameters:@{
                                           @"jiahaoId":self.currentJiahao.jiahaoId,
                                           @"status":@"N",
                                           @"refund":flag
                                           }
                                 success:^(id response) {
                                     [self.navigationController popViewControllerAnimated:YES];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     NSLog(@"%@", errorMessage);
                                     [[[UIAlertView alloc] initWithTitle:@"拒绝加号申请失败" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                     [sys_pendingView stopAnimating];
                                 }];
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
