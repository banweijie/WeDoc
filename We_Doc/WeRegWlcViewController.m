//
//  WeWelcomeViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeRegWlcViewController.h"
#import "WeAppDelegate.h"

@interface WeRegWlcViewController () {
    UIActivityIndicatorView * sys_pendingView;
    
    WeInfoedTextField * user_phone_input;
    WeInfoedTextField * user_password_input;
    
    UIView * user_forgetPassView;
    UIView * sys_titles;
    UILabel * title_en;
    UILabel * title_zh;
}

@end

@implementation WeRegWlcViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 1) {
        if (path.row == 0) {
            [user_phone_input becomeFirstResponder];
        }
        if (path.row == 1) {
            [user_password_input becomeFirstResponder];
        }
        return nil;
    }
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 2) {
        [self api_user_login:user_phone_input.text password:user_password_input.text];
    }
    if (path.section == 3) {
        WeRegIpnViewController * vc = [[WeRegIpnViewController alloc] init];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 0;
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    return 20;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == 0) return 230 - (568 - self.view.frame.size.height);
    if (section == 1) return 2;
    if (section == 2) return 37;
    return 10;
}
// 询问每个段落的尾部标题
- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部
-(UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section{
    if (section == 0) return sys_titles;
    if (section == 2) return user_forgetPassView;
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 4;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        default:
            return 0;
    }
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    cell.opaque = NO;
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.backgroundColor = We_background_cell_general;
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    cell.imageView.image = [UIImage imageNamed:@"login-phonenum"];
                    [user_phone_input setUserData:indexPath];
                    [cell.contentView addSubview:user_phone_input];
                    break;
                case 1:
                    cell.backgroundColor = We_background_cell_general;
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    cell.imageView.image = [UIImage imageNamed:@"login-password"];
                    [user_password_input setUserData:indexPath];
                    [cell.contentView addSubview:user_password_input];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"登录";
                    cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:15];
                    cell.textLabel.textColor = We_foreground_red_general;
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    break;
                default:
                    break;
            }
            break;
        case 3:
            cell.backgroundColor = We_background_red_tableviewcell;
            cell.textLabel.text = @"初次使用？现在注册";
            cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:16];
            cell.textLabel.textColor = We_foreground_white_general;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        default:
            break;
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
    // 页面标题
    self.navigationItem.title = @"欢迎使用";
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // Title
    sys_titles = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 140)];
    
    title_en = [[UILabel alloc] initWithFrame:CGRectMake(90, 68 - (568 - self.view.frame.size.height) * 2 / 5, 150, 100)];
    title_en.text = @"A+Dr";
    [title_en setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:57]];
    [title_en setTextColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0]];
    [title_en setTextAlignment:NSTextAlignmentCenter];
    [sys_titles addSubview:title_en];
    
    title_zh = [[UILabel alloc] initWithFrame:CGRectMake(90, 115 - (568 - self.view.frame.size.height) * 2 / 5, 150, 100)];
    title_zh.text = @"医  家  仁";
    [title_zh setFont:[UIFont fontWithName:@"Heiti SC" size:16]];
    [title_zh setTextColor:[UIColor colorWithRed:134.0/255 green:11.0/255 blue:38.0/255 alpha:0.9]];
    [title_zh setTextAlignment:NSTextAlignmentCenter];
    [sys_titles addSubview:title_zh];
    
    // 用于输入手机号码的文本框
    user_phone_input = [[WeInfoedTextField alloc] initWithFrame:We_frame_textFieldInCell_general];
    [user_phone_input setTextAlignment:NSTextAlignmentRight];
    [user_phone_input setText:@"18810521309"];
    [user_phone_input setFont:We_font_textfield_zh_cn];
    [user_phone_input setPlaceholder:@"请输入您的手机号码"];
    [user_phone_input setTextColor:We_foreground_black_general];
    [user_phone_input setDelegate:self];
    [user_phone_input setReturnKeyType:UIReturnKeyNext];
    
    // 用于输入登录密码的文本框
    user_password_input = [[WeInfoedTextField alloc] initWithFrame:We_frame_textFieldInCell_general];
    [user_password_input setTextAlignment:NSTextAlignmentRight];
    [user_password_input setText:@"52yuqing"];
    [user_password_input setFont:We_font_textfield_zh_cn];
    [user_password_input setPlaceholder:@"请输入您的登录密码"];
    [user_password_input setTextColor:We_foreground_black_general];
    [user_password_input setDelegate:self];
    [user_password_input setReturnKeyType:UIReturnKeyDefault];
    [user_password_input setSecureTextEntry:YES];
    
    // user_forgetpass
    user_forgetPassView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    UIButton * user_forgetpass = [UIButton buttonWithType:UIButtonTypeSystem];
    [user_forgetpass setFrame:CGRectMake(220, 0, 100, 35)];
    [user_forgetpass setTitle:@"忘记密码" forState:UIControlStateNormal];
    [user_forgetpass setBackgroundColor:[UIColor clearColor]];
    [user_forgetpass setTintColor:UIColorFromRGB(51, 51, 51, 1)];
    [user_forgetPassView addSubview:user_forgetpass];
    
    // 取消按钮
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton_onPress:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    // sys_tableView
    self.sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.sys_tableView.delegate = self;
    self.sys_tableView.dataSource = self;
    self.sys_tableView.backgroundColor = [UIColor clearColor];
    self.sys_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.sys_tableView.scrollEnabled = NO;
    self.sys_tableView_originHeight = self.sys_tableView.frame.size.height;
    [self.view addSubview:self.sys_tableView];
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
}

#pragma mark - textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == user_phone_input) {
        [user_password_input becomeFirstResponder];
    }
    if (textField == user_password_input) {
        [user_password_input resignFirstResponder];
        //[self api_user_login];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Callbacks
- (void)cancelButton_onPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Apis

// 访问登录接口
- (void)api_user_login:(NSString *)phone password:(NSString *)password {
    [sys_pendingView startAnimating];
    [WeAppDelegate postToServerWithField:@"user" action:@"login"
                              parameters:@{
                                           @"phone":phone,
                                           @"password":[password md5]
                                           }
                                 success:^(NSDictionary * response) {
                                     [self api_doctor_listPatients];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                  initWithTitle:@"登陆失败"
                                                                  message:errorMessage
                                                                  delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                                     [notPermitted show];
                                     [sys_pendingView stopAnimating];
                                 }];
}

// 访问获取保健医列表接口
- (void)api_doctor_listPatients {
    [WeAppDelegate postToServerWithField:@"doctor" action:@"listPatients"
                              parameters:@{
                                           }
                                 success:^(NSArray * response) {
                                     NSLog(@"response");
                                     favorPatientList = [[NSMutableDictionary alloc] init];
                                     for (int i = 0; i < [response count]; i++) {
                                         WeFavorPatient * newFavorPatient = [[WeFavorPatient alloc] initWithNSDictionary:response[i]];
                                         favorPatientList[newFavorPatient.userId] = newFavorPatient;
                                     }
                                     [self api_user_refreshUser];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                   initWithTitle:@"获取病人列表失败"
                                                                   message:errorMessage
                                                                   delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                     [notPermitted show];
                                     [sys_pendingView stopAnimating];
                                 }];
}

// 访问获取用户信息接口
- (void)api_user_refreshUser {
    [WeAppDelegate postToServerWithField:@"user" action:@"refreshUser"
                              parameters:@{
                                           }
                                 success:^(NSDictionary * response) {
                                     WeDoctor * newUser = [[WeDoctor alloc] initWithNSDictionary:response];
                                     [self api_message_getUnviewedMsg:newUser];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                  initWithTitle:@"获取用户信息失败"
                                                                  message:errorMessage
                                                                  delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                                     [notPermitted show];
                                     [sys_pendingView stopAnimating];
                                 }];
}

// 访问获取未读信息接口
- (void)api_message_getUnviewedMsg:(WeDoctor *)newUser {
    [WeAppDelegate postToServerWithField:@"message" action:@"getUnviewedMsg"
                              parameters:@{
                                           }
                                 success:^(NSArray * response) {
                                     NSLog(@"%@", [response class]);
                                     if (![response isKindOfClass:[NSArray class]]) {
                                         NSLog(@"!!!!");
                                         lastMessageId = (long long) response;
                                     }
                                     else {
                                         for (int i = 0; i < [response count]; i++) {
                                             WeMessage * message = [[WeMessage alloc] initWithNSDictionary:response[i]];
                                             if ([message.messageId longLongValue] > lastMessageId) {
                                                 lastMessageId = [message.messageId longLongValue];
                                                 NSLog(@"%lld", lastMessageId);
                                             }
                                             NSMutableArray * result = [globalHelper search:[WeMessage class]
                                                                                      where:[NSString stringWithFormat:@"messageId = %@", message.messageId]
                                                                                    orderBy:nil offset:0 count:0];
                                             if ([result count] == 0) {
                                                 // 文字消息
                                                 if ([message.messageType isEqualToString:@"T"]) {
                                                     [globalHelper insertToDB:message];
                                                 }
                                                 // 图片消息
                                                 else if ([message.messageType isEqualToString:@"I"]) {
                                                     [globalHelper insertToDB:message];
                                                     [WeAppDelegate DownloadImageWithURL:yijiarenImageUrl(message.content)
                                                                       successCompletion:^(id image) {
                                                                           NSLog(@"!!!");
                                                                           message.imageContent = (UIImage *)image;
                                                                           [globalHelper updateToDB:message where:nil];
                                                                       }];
                                                 }
                                                 // 语音消息
                                                 else if ([message.messageType isEqualToString:@"A"]) {
                                                     [globalHelper insertToDB:message];
                                                     [WeAppDelegate DownloadFileWithURL:yijiarenImageUrl(message.content)
                                                                      successCompletion:^(NSURL * filePath) {
                                                                          [VoiceConverter amrToWav:filePath.path wavSavePath:[NSString stringWithFormat:@"%@%@.wav", NSTemporaryDirectory(), message.messageId]];
                                                                          message.audioContent = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@%@.wav", NSTemporaryDirectory(), message.messageId]];
                                                                          [globalHelper updateToDB:message where:nil];
                                                                      }];
                                                 }
                                                 else if ([message.messageType isEqualToString:@"X"]) {
                                                     [globalHelper insertToDB:message];
                                                 }
                                                 else if ([message.messageType isEqualToString:@"R"]) {
                                                     [globalHelper insertToDB:message];
                                                 }
                                             }
                                         }
                                     }
                                     currentUser = newUser;
                                     if (self.originTargetViewController != nil) {
                                         [self.tabBarController setSelectedViewController:self.originTargetViewController];
                                     }
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                   initWithTitle:@"获取未读信息失败"
                                                                   message:errorMessage
                                                                   delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                     [notPermitted show];
                                     [sys_pendingView stopAnimating];
                                 }];
}

- (void)send_forgetpass:(id)sender {
    NSLog(@"forget password:");
}
@end
