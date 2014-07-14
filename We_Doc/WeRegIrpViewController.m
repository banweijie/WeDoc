//
//  WeRegisterInputPersonalInfoViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeRegIrpViewController.h"
#import "WeAppDelegate.h"
@interface WeRegIrpViewController ()

@end

@implementation WeRegIrpViewController {
    UITextField * user_loginPassword_input;
    UITextField * user_repeatPassword_input;
    UITableView * sys_tableView;
    UIActivityIndicatorView * sys_pendingView;
}

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 0) {
        if (path.row == 0) [user_loginPassword_input becomeFirstResponder];
        if (path.row == 1) [user_repeatPassword_input becomeFirstResponder];
        return nil;
    }
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 1) {
        [self checkRepeatPassword];
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
    //if (section == 1) return 30;
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
    if (section == 0) return 2;
    if (section == 1) return 1;
    return 0;
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
            cell.textLabel.text = @"登录密码";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell addSubview:user_loginPassword_input];
        }
        if (indexPath.row == 1) {
            cell.backgroundColor = We_background_cell_general;
            cell.textLabel.text = @"重复密码";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell addSubview:user_repeatPassword_input];
        }
    }
    if (indexPath.section == 1) {
        cell.backgroundColor = We_background_red_tableviewcell;
        if ([we_vericode_type isEqualToString:@"NewPassword"]) {
            cell.textLabel.text = @"完成注册";
        }
        else
            if ([we_vericode_type isEqualToString:@"ModifyPassword"]) {
                cell.textLabel.text = @"修改密码";
            }
        cell.textLabel.font = We_font_button_zh_cn;
        cell.textLabel.textColor = We_foreground_white_general;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}

#pragma mark - Functional

- (void) checkRepeatPassword {
    if ([user_loginPassword_input.text isEqualToString:user_repeatPassword_input.text]) {
        [self api_user_doRegister];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"输入的密码有误" message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
    }
}

#pragma mark - APIs

- (void)api_user_doRegister {
    [sys_pendingView startAnimating];
    [WeAppDelegate postToServerWithField:@"user" action:@"doRegister"
                              parameters:@{
                                           @"password":[user_loginPassword_input.text md5],
                                           @"userType":@"P"
                                           }
                                 success:^(id response) {
                                     WeRegWlcViewController * vc = self.navigationController.viewControllers[0];
                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                     [vc api_user_login:self.user_phone_value password:user_loginPassword_input.text];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                   initWithTitle:@"注册失败"
                                                                   message:errorMessage
                                                                   delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                     [notPermitted show];
                                     [sys_pendingView stopAnimating];
                                 }];
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
    
    // user_loginPassword_input init
    user_loginPassword_input = [[UITextField alloc] initWithFrame:CGRectMake(100, 9, 220, 30)];
    user_loginPassword_input.placeholder = @"请输入想要设置的密码";
    user_loginPassword_input.font = We_font_textfield_en_us;
    user_loginPassword_input.secureTextEntry = YES;
    user_loginPassword_input.autocorrectionType = UITextAutocorrectionTypeNo;
    [user_loginPassword_input setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    // user_repeatPassword_input init
    user_repeatPassword_input = [[UITextField alloc] initWithFrame:CGRectMake(100, 9, 220, 30)];
    user_repeatPassword_input.placeholder = @"请重复输入的密码";
    user_repeatPassword_input.font = We_font_textfield_en_us;
    user_repeatPassword_input.secureTextEntry = YES;
    user_repeatPassword_input.autocorrectionType = UITextAutocorrectionTypeNo;
    [user_repeatPassword_input setClearButtonMode:UITextFieldViewModeWhileEditing];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
