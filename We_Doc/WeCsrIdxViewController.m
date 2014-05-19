//
//  WeCsrIdxViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-5-5.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrIdxViewController.h"
#import "PAImageView.h"
#import "WeAppDelegate.h"
#import <AFNetworking.h>

@interface WeCsrIdxViewController () {
    UITableView * sys_tableView;
    NSTimer * sys_refreshTimer;
    NSMutableArray * orderedIdOfPatient;
}

@end

@implementation WeCsrIdxViewController

/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = We_alpha_cell_general;;
    cell.opaque = YES;
}
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 0) {
        we_patient_chating = orderedIdOfPatient[path.row];
        [self performSegueWithIdentifier:@"CsrIdx_pushto_CsrCtr" sender:self];
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tv.rowHeight * 1.5;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 0 + 64;
    return 20;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    //if (section == 1) return 30;
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 100;
    return 10;
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
    switch (section) {
        case 0:
            return [orderedIdOfPatient count];
            break;
        default:
            return 0;
    }
}
// 编辑时进行的动作
-(void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (![self deletePatientAtIndex:indexPath.row]) return;
        [orderedIdOfPatient removeObjectAtIndex:indexPath.row];
        [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
// 返回是否可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    UILabel * l1;
    UILabel * l2;
    UILabel * l3;
    WeMessage * lastMsg;
    UIImageView * avatarView;
    WeFavorPatient * patient = favorPatients[orderedIdOfPatient[indexPath.row]];
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    switch (indexPath.section) {
        case 0:
            cell.contentView.backgroundColor = We_background_cell_general;
            // l1 - user name
            l1 = [[UILabel alloc] initWithFrame:CGRectMake(75, 9, 240, 23)];
            l1.text = patient.userName;
            if ([l1.text isEqualToString:@""]) l1.text = @"尚未设置名称";
            l1.font = We_font_textfield_zh_cn;
            l1.textColor = We_foreground_black_general;
            [cell.contentView addSubview:l1];
            
            // l2 - lastMsg - content
            l2 = [[UILabel alloc] initWithFrame:CGRectMake(75, 33, 240, 23)];
            lastMsg = [we_messagesWithPatient[orderedIdOfPatient[indexPath.row]] lastObject];
            if ([lastMsg.messageType isEqualToString:@"C"]) {
                long long restSecond = [currentUser.maxResponseGap intValue] * 3600 - (long long) (([[NSDate date] timeIntervalSince1970] - lastMsg.time));
                l2.text = [NSString stringWithFormat:@"[申请咨询中 剩余%lld小时%lld分钟]",  restSecond / 3600, restSecond % 3600 / 60];
                l2.textColor = We_foreground_red_general;
            }
            else if ([lastMsg.messageType isEqualToString:@"T"]) {
                l2.text = lastMsg.content;
                l2.textColor = We_foreground_black_general;
            }
            else if ([lastMsg.messageType isEqualToString:@"A"]) {
                l2.text = @"[语音]";
                l2.textColor = We_foreground_red_general;
            }
            else if ([lastMsg.messageType isEqualToString:@"I"]) {
                l2.text = @"[图片]";
                l2.textColor = We_foreground_red_general;
            }
            else {
                l2.text = [NSString stringWithFormat:@"尚未处理此类型(%@)的消息:%@", lastMsg.messageType, lastMsg.content];
            }
            l2.font = We_font_textfield_small_zh_cn;
            [cell.contentView addSubview:l2];
            // l3 - lastMsg - time
            l3 = [[UILabel alloc] initWithFrame:CGRectMake(75, 33, 235, 23)];
            l3.textColor = We_foreground_gray_general;
            l3.font = [UIFont fontWithName:@"Heiti SC" size:10];
            l3.text = [WeAppDelegate transitionToDateFromSecond:lastMsg.time];
            l3.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:l3];
            // avatar
            avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 48, 48)];
            //[avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(patient.avatarPath)]];
            avatarView.image = patient.avatar;
            avatarView.layer.cornerRadius = avatarView.frame.size.height / 2;
            avatarView.clipsToBounds = YES;
            [cell.contentView addSubview:avatarView];
            break;
        default:
            break;
    }
    return cell;
}

- (BOOL)deletePatientAtIndex:(NSInteger)index {
    NSString * urlString = yijiarenUrl(@"doctor", @"deletePatient");
    NSString * paraString = [NSString stringWithFormat:@"patientId=%@", we_patients[orderedIdOfPatient[index]][@"id"]];
    NSData * DataResponse = [WeAppDelegate postToServer:urlString withParas:paraString];
    
    NSString * errorMessage = @"连接服务器失败";
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
        NSString *result = [HTTPResponse objectForKey:@"result"];
        result = [NSString stringWithFormat:@"%@", result];
        if ([result isEqualToString:@"1"]) {
            return YES;
        }
        if ([result isEqualToString:@"2"]) {
            NSDictionary *fields = [HTTPResponse objectForKey:@"fields"];
            NSEnumerator *enumerator = [fields keyEnumerator];
            id key;
            while ((key = [enumerator nextObject])) {
                NSString * tmp1 = [fields objectForKey:key];
                if (tmp1 != NULL) errorMessage = tmp1;
            }
        }
        if ([result isEqualToString:@"3"]) {
            errorMessage = [HTTPResponse objectForKey:@"info"];
        }
        if ([result isEqualToString:@"4"]) {
            errorMessage = [HTTPResponse objectForKey:@"info"];
        }
    }
    UIAlertView *notPermitted = [[UIAlertView alloc]
                                 initWithTitle:@"删除病人失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
    return NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 550) style:UITableViewStyleGrouped];
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
    orderedIdOfPatient = [NSMutableArray arrayWithArray:[favorPatients allKeys]];
    [sys_tableView reloadData];
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
