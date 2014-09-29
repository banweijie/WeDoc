//
//  WePecRechViewController.m
//  AplusDr
//
//  Created by 袁锐 on 14-9-19.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePecRechViewController.h"

@interface WePecRechViewController ()
{
    UIActivityIndicatorView * sys_pendingView;
    UITableView * sys_tableView;
    
    UITextField * user_rech_card;
}
@end

@implementation WePecRechViewController



#pragma mark - TableView delegate
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section==1 && path.row==0) {
        [self api_user_viewAccount];
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 20 + 64;
    if (section == 2 ) return 10;
    return 20;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
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
    return 2;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        }
    return 1;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.font = We_font_textfield_zh_cn;
    cell.detailTextLabel.font = We_font_textfield_zh_cn;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"充值卡号码";
        [cell addSubview:user_rech_card];
        cell.textLabel.textColor = We_foreground_black_general;
        cell.detailTextLabel.textColor = We_foreground_gray_general;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = @"确认";
        cell.textLabel.textColor = We_foreground_white_general;
        cell.backgroundColor = We_background_red_tableviewcell;
    }
    return cell;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"充值";
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    
    //user_rech_card
    user_rech_card = [[UITextField alloc] initWithFrame:We_frame_textFieldInCell_general];
    user_rech_card.placeholder = @"请输入您的充值卡卡号";
    user_rech_card.font = We_font_textfield_zh_cn;
    [user_rech_card setTextAlignment:NSTextAlignmentRight];
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:sys_tableView];
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
}


#pragma mark - apis
- (void)api_user_viewAccount {
    [sys_pendingView startAnimating];
    [WeAppDelegate postToServerWithField:@"user" action:@"rechargeWithCard"
                              parameters:@{
                                           @"code":user_rech_card.text
                                           }
                                 success:^(NSDictionary * response) {
                                     
                                     id money= response[@"amount"];
                                     
                                     [self.navigationController popViewControllerAnimated:YES];
                                     
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                   initWithTitle:@"充值成功"
                                                                   message:[NSString stringWithFormat:@"本次充值 %@ 元",money]
                                                                   delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                     [notPermitted show];
                                     
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                   initWithTitle:@"充值失败"
                                                                   message:errorMessage
                                                                   delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                     [notPermitted show];
                                     [sys_pendingView stopAnimating];
                                 }];
}



@end
