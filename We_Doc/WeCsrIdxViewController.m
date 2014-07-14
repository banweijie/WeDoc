//
//  WeCsrIdxViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-5-5.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrIdxViewController.h"
#import "WeAppDelegate.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>

@interface WeCsrIdxViewController () {
    UITableView * sys_tableView;
    NSTimer * sys_refreshTimer;
    NSMutableArray * orderedIdOfPatients;
    BOOL selecting;
}

@end

@implementation WeCsrIdxViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path {
    return path;
}

// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path {
    WeCsrCtrViewController * vc = [[WeCsrCtrViewController alloc] init];
    vc.patientChating = favorPatientList[orderedIdOfPatients[path.row]];
    [self.navigationController pushViewController:vc animated:YES];
    [tv deselectRowAtIndexPath:path animated:YES];
}

// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tv.rowHeight * 1.5;
}

// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 64;
    return 9;
}

// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}

// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 10;
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
    return 1;
}

// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return [orderedIdOfPatients count];
}

// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    
    WeFavorPatient * patient = favorPatientList[orderedIdOfPatients[indexPath.row]];
    if (indexPath.section == 0) {
        cell.contentView.backgroundColor = We_background_cell_general;
        // l1 - user name
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(75, 12, 240, 23)];
        l1.text = patient.userName;
        if ([l1.text isEqualToString:@"<null>"]) l1.text = @"尚未设置名称";
        l1.font = We_font_textfield_zh_cn;
        l1.textColor = We_foreground_black_general;
        [cell.contentView addSubview:l1];
        // avatar
        UIImageView * avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 48, 48)];
        //avatarView.image = doctor.avatar;
        [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(patient.avatarPath)]];
        avatarView.layer.cornerRadius = avatarView.frame.size.height / 2;
        avatarView.clipsToBounds = YES;
        [cell.contentView addSubview:avatarView];
    }
    /*
    if (indexPath.row == 2 || (indexPath.row == 1 && doctor.currentFundingId == nil)) {
        cell.imageView.image = [UIImage imageNamed:@"docinfo-chatroom"];
        WeMessage * lastMsg = [we_messagesWithDoctor[orderedIdOfDoctor[indexPath.section]] lastObject];
        if ([lastMsg.messageType isEqualToString:@"c"]) {
            long long restSecond = [doctor.maxResponseGap integerValue] * 3600 - (long long) (([[NSDate date] timeIntervalSince1970] - lastMsg.time));
            cell.textLabel.text = [NSString stringWithFormat:@"[申请咨询中 剩余%lld小时%lld分钟]",  restSecond / 3600, restSecond % 3600 / 60];
            cell.textLabel.textColor = We_foreground_red_general;
        }
        else if ([lastMsg.messageType isEqualToString:@"T"]) {
            cell.textLabel.text = lastMsg.content;
            cell.textLabel.textColor = We_foreground_black_general;
        }
        else if ([lastMsg.messageType isEqualToString:@"A"]) {
            cell.textLabel.text = @"[语音]";
            cell.textLabel.textColor = We_foreground_red_general;
        }
        else if ([lastMsg.messageType isEqualToString:@"I"]) {
            cell.textLabel.text = @"[图片]";
            cell.textLabel.textColor = We_foreground_red_general;
        }
        else {
            cell.textLabel.text = [NSString stringWithFormat:@"尚未处理此类型(%@)的消息:%@", lastMsg.messageType, lastMsg.content];
        }
        cell.detailTextLabel.text = [WeAppDelegate transitionToDateFromSecond:lastMsg.time];
        cell.textLabel.font = We_font_textfield_small_zh_cn;
        cell.detailTextLabel.font = We_font_textfield_small_zh_cn;
    }*/
    return cell;
}

#pragma mark - ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    /*
    UIBarButtonItem * addDoctorButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chatroom-adddoctor"] style:UIBarButtonItemStylePlain target:self action:@selector(addDoctorButton_onPress:)];
    self.navigationItem.rightBarButtonItem = addDoctorButton;
    */
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:sys_tableView];
    
    sys_refreshTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshData:) userInfo:nil repeats:YES];
    [self refreshData:self];
}

- (void)refreshData:(id)sender {
    orderedIdOfPatients = [NSMutableArray arrayWithArray:[favorPatientList allKeys]];
    [sys_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - customs

@end
