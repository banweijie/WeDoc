//
//  WeRegisterInputVeriCodeViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeRegIvcViewController.h"
#import "WeAppDelegate.h"

@interface WeRegIvcViewController () {
    UIActivityIndicatorView * sys_pendingView;
}

@end

@implementation WeRegIvcViewController
{
    UITextField * user_veriCode_input;
    int sys_countDown_time;
    UITableView * sys_tableView;
    UIView * sys_countDown_demo;
    NSTimer * sys_countDown_timer;
    UILabel * sys_countDown_demo_text;
}

/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 1) {
        if (sys_countDown_time == 0) return path;
        else return nil;
    }
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 0) {
    }
    if (path.section == 1) {
        sys_countDown_time = 60;
        sys_countDown_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sys_countDown_passTime) userInfo:nil repeats:YES];
    }
    if (path.section == 2) {
        [self api_user_checkVerificationCode];
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 20 + 64;
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
    return 3;
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.backgroundColor = We_background_cell_general;
            //cell.contentView.backgroundColor = We_background_cell_general;
            cell.textLabel.text = @"验证码";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell addSubview:user_veriCode_input];
        }
    }
    if (indexPath.section == 1) {
        cell.backgroundColor = We_background_cell_general;
        [cell.contentView addSubview:sys_countDown_demo_text];
    }
    if (indexPath.section == 2) {
        cell.backgroundColor = We_background_red_tableviewcell;
        cell.textLabel.text = @"下一步";
        cell.textLabel.font = We_font_button_zh_cn;
        cell.textLabel.textColor = We_foreground_white_general;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return cell;
}
/*
 [AREA]
 Functional
 */
- (void) sys_countDown_passTime {
    sys_countDown_time --;
    sys_countDown_demo_text.text = [NSString stringWithFormat:@"重发验证码(%d)", sys_countDown_time];
    
    if (sys_countDown_time == 0) {
        [sys_countDown_timer invalidate];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
    self.navigationItem.title = @"输入验证码";
    
    // sys_countDown_time
    sys_countDown_time = 60;
    sys_countDown_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sys_countDown_passTime) userInfo:nil repeats:YES];
    
    // user_veriCode_input init
    user_veriCode_input = [[UITextField alloc] initWithFrame:We_frame_textFieldInCell_general];
    user_veriCode_input.placeholder = @"请输入收到的短信验证码";
    user_veriCode_input.textAlignment = NSTextAlignmentRight;
    user_veriCode_input.delegate = self;
    user_veriCode_input.font = We_font_textfield_zh_cn;
    
    // sys_countDown_demo init
    sys_countDown_demo_text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    sys_countDown_demo_text.text = [NSString stringWithFormat:@"重发验证码(%d)", sys_countDown_time];
    sys_countDown_demo_text.font = We_font_textfield_zh_cn;
    sys_countDown_demo_text.textColor = We_foreground_gray_general;
    sys_countDown_demo_text.textAlignment = NSTextAlignmentCenter;
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
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

- (void)api_user_checkVerificationCode {
    [sys_pendingView startAnimating];
    
    [WeAppDelegate postToServerWithField:@"user" action:@"checkVerificationCode"
                              parameters:@{
                                           @"verificationCode":user_veriCode_input.text
                                           }
                                 success:^(id response) {
                                     WeRegIrpViewController * vc = [[WeRegIrpViewController alloc] init];
                                     vc.user_phone_value = self.user_phone_value;
                                     
                                     self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:nil action:nil];
                                     [self.navigationController pushViewController:vc animated:YES];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                   initWithTitle:@"验证码验证失败"
                                                                   message:errorMessage
                                                                   delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                     [notPermitted show];
                                     [sys_pendingView stopAnimating];
                                 }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
