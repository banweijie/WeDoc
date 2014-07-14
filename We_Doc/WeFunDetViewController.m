//
//  WeFunDetViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-21.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunDetViewController.h"

@interface WeFunDetViewController () {
    WeFunding * currentFunding;
    UIActivityIndicatorView * sys_pendingView;
    UIImageView * posterView;
    UITableView * sys_tableView;
    UIView * barView;
    UIButton * refreshButton;
    UIView * contentView;
    
    UILabel * button0label0;
    UILabel * button2label0;
    UILabel * posterTitle;
}

@end

@implementation WeFunDetViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 2 && path.row == 1) {
        WeFunDesViewController * vc = [[WeFunDesViewController alloc] init];
        vc.HTMLContent = currentFunding.description;
        UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithTitle:@"基本信息" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) return 235;
    if (indexPath.section == 0 && indexPath.row == 1) return [tableView rowHeight] * 1.5;
    if (indexPath.section == 0 && indexPath.row == 2) return [tableView rowHeight] * 2;
    if (indexPath.section == 1 && indexPath.row == 0) return [tableView rowHeight] * 1.5;
    if (indexPath.section == 2 && indexPath.row == 0) {
        return [WeAppDelegate calcSizeForString:currentFunding.introduction Font:We_font_textfield_zh_cn expectWidth:280].height + 60;
    }
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
        return self.tabBarController.tabBar.frame.size.height + 50 + 20;
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
    return 3;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 3;
    if (section == 1) return 1;
    if (section == 2) return 2;
    return 1;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell * cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    cell.opaque = NO;
    cell.backgroundColor = We_background_cell_general;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 235)];
        [imageView setImageWithURL:[NSURL URLWithString:yijiarenImageUrl(currentFunding.poster2)]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [cell.contentView addSubview:imageView];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        [cell.textLabel setNumberOfLines:2];
        [cell.textLabel setFont:We_font_textfield_large_zh_cn];
        [cell.textLabel setText:currentFunding.subTitle];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        // 医生名称
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 16, 220, 32)];
        if ([currentFunding.initiator.userName isEqualToString:@""]) {
            l1.text = @"尚未设置名称";
        }
        else {
            l1.text = [NSString stringWithFormat:@"%@ %@", currentFunding.initiator.userName, we_codings[@"doctorCategory"][currentFunding.initiator.category][@"title"][currentFunding.initiator.title]];
        }
        l1.font = We_font_textfield_large_zh_cn;
        l1.textColor = We_foreground_black_general;
        [cell.contentView addSubview:l1];
        
        // 医院科室
        UILabel * l2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 44, 220, 32)];
        l2.text = [NSString stringWithFormat:@"%@ %@", currentFunding.initiator.hospitalName, currentFunding.initiator.sectionName];
        l2.textColor = We_foreground_gray_general;
        l2.font = We_font_textfield_zh_cn;
        [cell.contentView addSubview:l2];
        
        // 医生头像
        UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 64, 64)];
        [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(currentFunding.initiator.avatarPath)]];
        avatarView.layer.cornerRadius = 32;
        avatarView.clipsToBounds = YES;
        [cell.contentView addSubview:avatarView];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        if ([currentFunding.type isEqualToString:@"D"]) {
            UILabel * label0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 80, 20)];
            [label0 setTextAlignment:NSTextAlignmentCenter];
            [label0 setFont:We_font_textfield_small_zh_cn];
            [label0 setAdjustsFontSizeToFitWidth:YES];
            [label0 setText:[NSString stringWithFormat:@"%@/%@ 人", currentFunding.supportCount, currentFunding.goal]];
            [cell.contentView addSubview:label0];
            
            UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 80, 20)];
            [label1 setTextAlignment:NSTextAlignmentCenter];
            [label1 setFont:We_font_textfield_small_zh_cn];
            [label1 setTextColor:We_foreground_gray_general];
            [label1 setText:@"已招募"];
            [cell.contentView addSubview:label1];
        }
        else {
            UILabel * label0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 80, 20)];
            [label0 setTextAlignment:NSTextAlignmentCenter];
            [label0 setFont:We_font_textfield_small_zh_cn];
            [label0 setAdjustsFontSizeToFitWidth:YES];
            [label0 setText:[NSString stringWithFormat:@"￥%@/￥%@", currentFunding.sum, currentFunding.goal]];
            [cell.contentView addSubview:label0];
            
            UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 80, 20)];
            [label1 setTextAlignment:NSTextAlignmentCenter];
            [label1 setFont:We_font_textfield_small_zh_cn];
            [label1 setTextColor:We_foreground_gray_general];
            [label1 setText:@"已筹资"];
            [cell.contentView addSubview:label1];
        }
        {
            UILabel * label0 = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 80, 20)];
            [label0 setTextAlignment:NSTextAlignmentCenter];
            [label0 setFont:We_font_textfield_small_zh_cn];
            [label0 setAdjustsFontSizeToFitWidth:YES];
            [label0 setText:[NSString stringWithFormat:@"%@人", currentFunding.supportCount]];
            [cell.contentView addSubview:label0];
            
            UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, 80, 20)];
            [label1 setTextAlignment:NSTextAlignmentCenter];
            [label1 setFont:We_font_textfield_small_zh_cn];
            [label1 setTextColor:We_foreground_gray_general];
            [label1 setText:@"支持人数"];
            [cell.contentView addSubview:label1];
        }
        {
            UILabel * label0 = [[UILabel alloc] initWithFrame:CGRectMake(80 * 2, 15, 80, 20)];
            [label0 setTextAlignment:NSTextAlignmentCenter];
            [label0 setFont:We_font_textfield_small_zh_cn];
            [label0 setAdjustsFontSizeToFitWidth:YES];
            int restSec =  [currentFunding.endTime longLongValue] / 1000 - [[NSDate date] timeIntervalSince1970];
            [label0 setText:[NSString stringWithFormat:@"%d天", restSec / 86400 + 1]];
            [cell.contentView addSubview:label0];
            
            UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(80 * 2, 35, 80, 20)];
            [label1 setTextAlignment:NSTextAlignmentCenter];
            [label1 setFont:We_font_textfield_small_zh_cn];
            [label1 setTextColor:We_foreground_gray_general];
            [label1 setText:@"剩余时间"];
            [cell.contentView addSubview:label1];
        }
        {
            UILabel * label0 = [[UILabel alloc] initWithFrame:CGRectMake(80 * 3, 15, 80, 20)];
            [label0 setTextAlignment:NSTextAlignmentCenter];
            [label0 setFont:We_font_textfield_small_zh_cn];
            [label0 setAdjustsFontSizeToFitWidth:YES];
            [label0 setText:[NSString stringWithFormat:@"%@", currentFunding.likeCount]];
            [cell.contentView addSubview:label0];
            
            UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(80 * 3, 35, 80, 20)];
            [label1 setTextAlignment:NSTextAlignmentCenter];
            [label1 setFont:We_font_textfield_small_zh_cn];
            [label1 setTextColor:We_foreground_gray_general];
            [label1 setText:@"同业支持"];
            [cell.contentView addSubview:label1];
        }
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        [cell.textLabel setText:@"支持人数"];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ 人", currentFunding.supportCount]];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        [cell.textLabel setText:@"结束时间"];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        NSDate * endDate = [NSDate dateWithTimeIntervalSince1970:[currentFunding.endTime longLongValue] / 1000];
        NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents * the = [calendar components:unitFlags fromDate:endDate];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld年%ld月%ld日", (long)the.year, (long)the.month, (long)the.day]];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        [cell.textLabel setText:@"点赞人数"];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        [cell.detailTextLabel setText:currentFunding.likeCount];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 280, 40)];
        l1.text = @"众筹简介";
        l1.font = We_font_textfield_zh_cn;
        l1.textColor = We_foreground_black_general;
        [cell.contentView addSubview:l1];
        CGSize sizezz = [currentFunding.introduction sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, sizezz.width, sizezz.height)];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = currentFunding.introduction;
        label.font = We_font_textfield_zh_cn;
        label.textColor = We_foreground_gray_general;
        [cell.contentView addSubview:label];
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        [cell.textLabel setText:@"查看详情"];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return cell;
}
/*
// 滑动到一定位置
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 调整背景图片位置
    CGRect frame = posterView.frame;
    frame.origin.y = -scrollView.contentOffset.y;
    posterView.frame = frame;
    [posterView setHidden:(scrollView.contentOffset.y > 235 - 64 - 2)];
    
    // 调整按钮栏位置
    CGRect frame2 = barView.frame;
    frame2.origin.y = MAX(235 - scrollView.contentOffset.y, 64);
    barView.frame = frame2;
    
    // 调整标题栏
    if (scrollView.contentOffset.y > 235 - 64 - 2) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"texture"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationItem setTitle:currentFunding.title];
    }
    else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationItem setTitle:@""];
    }
}
// 滑动结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (scrollView.contentOffset.y < 117) {
        [scrollView scrollRectToVisible:CGRectMake(0, 0, 320, self.view.frame.size.height) animated:YES];
    }
    
    if (scrollView.contentOffset.y > 117 && scrollView.contentOffset.y < 235 - 64) {
        [scrollView scrollRectToVisible:CGRectMake(0, 235 - 64, 320, self.view.frame.size.height) animated:YES];
    }
}*/


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
    self.navigationItem.title = @"读取中...";
    
    // 分享按钮
    /*
    UIBarButtonItem * shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"crowdfunding-detail-share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButton_onPress:)];
    //self.navigationItem.rightBarButtonItem = shareButton;*/
    
    /*
    // 所有内容
    contentView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:contentView];
    
    // 海报背景图片
    posterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 235)];
    [posterView setImageWithURL:[NSURL URLWithString:yijiarenImageUrl(currentFunding.poster2)]];
    [posterView setContentMode:UIViewContentModeScaleAspectFill];
    [contentView addSubview:posterView];
    
    // 高斯模糊
    UIToolbar * toolBar0 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 235 - 80, 320, 80)];
    //[toolBar0 setBackgroundImage:[WeAppDelegate imageWithColor:UIColorFromRGB(33, 33, 33, 0.9)] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [toolBar0 setBarStyle:UIBarStyleBlackTranslucent];
    [toolBar0 setBarTintColor:UIColorFromRGB(255, 255, 255, 0.5)];
    //[posterView addSubview:toolBar0];
    
    // 海报上的标题
    posterTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 235 - 64, 280, 64)];
    [posterTitle setTextAlignment:NSTextAlignmentCenter];
    [posterTitle setText:currentFunding.title];
    [posterTitle setFont:We_font_textfield_huge_zh_cn];
    [posterTitle setTextColor:We_foreground_white_general];
    [posterTitle setNumberOfLines:2];
    [posterView addSubview:posterTitle];
    
    // 海报上的播放按钮
    
    */
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
    
    // barView
    barView = [[UIView alloc] initWithFrame:CGRectMake(0, 235, 320, 50)];
    [contentView addSubview:barView];
    
    // barView - button0
    UIButton * button0 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button0 setFrame:CGRectMake(0, 2, 89, 48)];
    [button0 setBackgroundColor:[UIColor colorWithRed:90 / 255.0 green:42 / 255.0 blue:47 / 255.0 alpha:0.9]];
    [barView addSubview:button0];
    
    // barView - button0 - label0
    button0label0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 89, 30)];
    [button0label0 setText:[NSString stringWithFormat:@"￥%@ ", currentFunding.goal]];
    [button0label0 setTextAlignment:NSTextAlignmentCenter];
    [button0label0 setFont:We_font_textfield_zh_cn];
    [button0label0 setTextColor:We_foreground_white_general];
    [button0 addSubview:button0label0];
    
    // barView - button0 - label1
    UILabel * button0label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 89, 30)];
    [button0label1 setText:@"目标募款"];
    [button0label1 setTextAlignment:NSTextAlignmentCenter];
    [button0label1 setFont:We_font_textfield_small_zh_cn];
    [button0label1 setTextColor:We_foreground_gray_general];
    [button0 addSubview:button0label1];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setFrame:CGRectMake(91, 2, 138, 48)];
    [button1 setImage:[UIImage imageNamed:@"crowdfunding-detail-support"] forState:UIControlStateNormal];
    [button1 setTitle:@" 支持众筹项目" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1_onPress:) forControlEvents:UIControlEventTouchUpInside];
    button1.tintColor = We_foreground_white_general;
    button1.backgroundColor = We_background_red_general;
    button1.titleLabel.font = We_font_textfield_zh_cn;
    [barView addSubview:button1];
    
    // barView - button2
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setFrame:CGRectMake(231, 2, 89, 48)];
    [button2 setBackgroundColor:[UIColor colorWithRed:90 / 255.0 green:42 / 255.0 blue:47 / 255.0 alpha:0.9]];
    [barView addSubview:button2];
    
    // barView - button2 - label0
    button2label0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 89, 30)];
    int restSec =  [currentFunding.endTime longLongValue] / 1000 - [[NSDate date] timeIntervalSince1970];
    [button2label0 setText:[NSString stringWithFormat:@"%d天", restSec / 86400 + 1]];
    [button2label0 setTextAlignment:NSTextAlignmentCenter];
    [button2label0 setFont:We_font_textfield_zh_cn];
    [button2label0 setTextColor:We_foreground_white_general];
    [button2 addSubview:button2label0];
    
    // barView - button2 - label1
    UILabel * button2label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 89, 30)];
    [button2label1 setText:@"剩余时限"];
    [button2label1 setTextAlignment:NSTextAlignmentCenter];
    [button2label1 setFont:We_font_textfield_small_zh_cn];
    [button2label1 setTextColor:We_foreground_gray_general];
    [button2 addSubview:button2label1];
    
    // 支持按钮
    UIButton * supportButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [supportButton setBackgroundColor:We_background_red_general];
    [supportButton setFrame:CGRectMake(0, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - 50, 320, 50)];
    [supportButton setImage:[UIImage imageNamed:@"crowdfunding-detail-support"] forState:UIControlStateNormal];
    [supportButton setTitle:@"支持众筹项目" forState:UIControlStateNormal];
    [supportButton setTintColor:We_foreground_white_general];
    [supportButton addTarget:self action:@selector(supportButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [supportButton.titleLabel setFont:We_font_textfield_large_zh_cn];
    [self.view addSubview:supportButton];
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    // 刷新按钮
    refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshButton.frame = self.view.frame;
    [refreshButton setTitle:@"获取众筹详情失败，点击刷新" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTintColor:We_foreground_red_general];
    [self.view addSubview:refreshButton];
    
    // 访问获取众筹详情列表
    [self api_data_viewFunding];
}

- (void)supportButton_onPress:(id)sender {
    if (currentUser == nil) {
        WeRegWlcViewController * vc = [[WeRegWlcViewController alloc] init];
        vc.originTargetViewController = nil;
        vc.tabBarController = self.tabBarController;
        
        WeNavViewController * nav = [[WeNavViewController alloc] init];
        [nav pushViewController:vc animated:NO];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    else {
        WeFunSupViewController * vc = [[WeFunSupViewController alloc] init];
        vc.currentFunding = currentFunding;
        
        WeNavViewController * nav = [[WeNavViewController alloc] init];
        [nav pushViewController:vc animated:NO];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)button1_onPress:(id)sender {
    if (currentUser == nil) {
        WeRegWlcViewController * vc = [[WeRegWlcViewController alloc] init];
        vc.originTargetViewController = nil;
        vc.tabBarController = self.tabBarController;
        
        WeNavViewController * nav = [[WeNavViewController alloc] init];
        [nav pushViewController:vc animated:NO];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    else {
        WeFunSupViewController * vc = [[WeFunSupViewController alloc] init];
        vc.currentFunding = currentFunding;
        
        WeNavViewController * nav = [[WeNavViewController alloc] init];
        [nav pushViewController:vc animated:NO];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)refreshButton_onPress:(id)sender {
    [self api_data_viewFunding];
}

- (void)api_data_viewFunding {
    [refreshButton setHidden:YES];
    [contentView setHidden:YES];
    [sys_pendingView startAnimating];
    
    [WeAppDelegate postToServerWithField:@"data" action:@"viewFunding"
                              parameters:@{
                                           @"fundingId":_currentFundingId
                                           }
                                 success:^(id response) {
                                     NSLog(@"%@", response);
                                     currentFunding = [[WeFunding alloc] initWithNSDictionary:response];
                                     self.navigationItem.title = currentFunding.title;
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
