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
    UITableView * sys_tableView;
    UITextField * user_phone_input;
    UITextField * user_password_input;
    UIView * user_forgetPassView;
    UIView * sys_titles;
    UILabel * title_en;
    UILabel * title_zh;
}

@end

@implementation WeRegWlcViewController


/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
// 调整格子的透明度
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
    if (path.section == 1) {
        if (path.row == 0) {
            [user_phone_input becomeFirstResponder];
        }
        if (path.row == 1) {
            [user_password_input becomeFirstResponder];
        }
    }
    if (path.section == 2) {
        [self send_login:self];
    }
    if (path.section == 3) {
        [self send_register:self];
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
    if (section == 0) return 230;
    if (section == 1) return 2;
    if (section == 2) return 37;
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 300;
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
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.backgroundColor = [UIColor clearColor];
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    cell.imageView.image = [UIImage imageNamed:@"login-phonenum"];
                    [cell.contentView addSubview:user_phone_input];
                    break;
                case 1:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.backgroundColor = [UIColor clearColor];
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    cell.imageView.image = [UIImage imageNamed:@"login-password"];
                    [cell.contentView addSubview:user_password_input];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.backgroundColor = [UIColor clearColor];
                    cell.textLabel.text = @"登录";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_red_general;
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    break;
                default:
                    break;
            }
            break;
        case 3:
            cell.contentView.backgroundColor = We_foreground_red_general;
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"初次使用？现在注册";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_white_general;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        default:
            break;
    }
    return cell;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    
    [self.view setBackgroundColor:[UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1.0]];
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // Title
    sys_titles = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 140)];
    
    title_en = [[UILabel alloc] initWithFrame:CGRectMake(90, 68 - (568 - self.view.frame.size.height) / 2, 150, 100)];
    title_en.text = @"A+Dr";
    [title_en setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:57]];
    [title_en setTextColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0]];
    [title_en setTextAlignment:NSTextAlignmentCenter];
    [sys_titles addSubview:title_en];
    
    title_zh = [[UILabel alloc] initWithFrame:CGRectMake(90, 115 - (568 - self.view.frame.size.height) / 2, 150, 100)];
    title_zh.text = @"医  家  仁";
    [title_zh setFont:[UIFont fontWithName:@"Heiti SC" size:16]];
    [title_zh setTextColor:[UIColor colorWithRed:134.0/255 green:11.0/255 blue:38.0/255 alpha:0.9]];
    [title_zh setTextAlignment:NSTextAlignmentCenter];
    [sys_titles addSubview:title_zh];
    
    We_init_textFieldInCell_pholder(user_phone_input, @"请输入您的手机号码", We_font_textfield_zh_cn);
    
    We_init_textFieldInCell_pholder(user_password_input, @"请输入您的登录密码", We_font_textfield_zh_cn);
    user_password_input.secureTextEntry = YES;
    
    user_phone_input.text = @"18810521309";
    user_password_input.text = @"52yuqing";
    
    // user_forgetpass
    user_forgetPassView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    UIButton * user_forgetpass = [UIButton buttonWithType:UIButtonTypeSystem];
    [user_forgetpass setFrame:CGRectMake(220, 0, 100, 35)];
    [user_forgetpass setTitle:@"忘记密码" forState:UIControlStateNormal];
    [user_forgetpass setBackgroundColor:[UIColor clearColor]];
    [user_forgetpass setTintColor:UIColorFromRGB(51, 51, 51, 1)];
    [user_forgetPassView addSubview:user_forgetpass];
    
    // cancel_button
    UIBarButtonItem * user_cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(segue_to_MapIdx:)];
    self.navigationItem.leftBarButtonItem = user_cancel;
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 568) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.scrollEnabled = NO;
    [self.view addSubview:sys_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:nil action:nil];
}


- (void)send_login:(id)sender {
    NSLog(@"%@ %@", user_phone_input.text, user_password_input.text);
    if (![self checkUserRights]) return;
    we_logined = YES;
    we_targetTabId = 3;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) checkUserRights {
    NSString *errorMessage = @"连接失败，请检查网络";
    NSString *urlString = @"http://115.28.222.1/yijiaren/user/login.action";
    NSString *md5pw = user_password_input.text;
    md5pw = [md5pw md5];
    NSString *parasString = [NSString stringWithFormat:@"phone=%@&password=%@", user_phone_input.text, md5pw];
    NSData * DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:parasString];
    
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
        NSString *result = [HTTPResponse objectForKey:@"result"];
        result = [NSString stringWithFormat:@"%@", result];
        if ([result isEqualToString:@"1"]) {
            [WeAppDelegate refreshUserData];
            /*
            NSDictionary * response = [HTTPResponse objectForKey:@"response"];
            NSLog(@"%@", response);
            we_notice = [WeAppDelegate toString:[response objectForKey:@"notice"]];
            we_consultPrice = [WeAppDelegate toString:[response objectForKey:@"consultPrice"]];
            we_plusPrice = [WeAppDelegate toString:[response objectForKey:@"plusPrice"]];
            we_maxResponseGap = [WeAppDelegate toString:[response objectForKey:@"maxResponseGap"]];
            we_workPeriod = [WeAppDelegate toString:[response objectForKey:@"workPeriod"]];
            we_workPeriod_save = [NSString stringWithString:we_workPeriod];
            we_hospital = [WeAppDelegate toString:[[response objectForKey:@"hospital"] objectForKey:@"name"]];
            we_section = [WeAppDelegate toString:[[response objectForKey:@"section"] objectForKey:@"text"]];
            we_title = [WeAppDelegate toString:[response objectForKey:@"title"]];
            we_category = [WeAppDelegate toString:[response objectForKey:@"category"]];
            we_skills = [WeAppDelegate toString:[response objectForKey:@"skills"]];
            we_degree = [WeAppDelegate toString:[response objectForKey:@"degree"]];
            we_email = [WeAppDelegate toString:[response objectForKey:@"email"]];
            we_phone = [WeAppDelegate toString:[response objectForKey:@"phone"]];
            we_name = [WeAppDelegate toString:[response objectForKey:@"name"]];
            we_gender = [WeAppDelegate toString:[response objectForKey:@"gender"]];
            NSString *urlString = [NSString stringWithFormat:@"http://115.28.222.1/yijiaren/pics/avatar/%@",[response objectForKey:@"avatar"]];
            NSString *paraString = @"";
            NSData *DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:paraString];
            we_avatar = [UIImage imageWithData:DataResponse];
            we_qc = [WeAppDelegate toString:[response objectForKey:@"qc"]];
            we_pc = [WeAppDelegate toString:[response objectForKey:@"pc"]];
            
            urlString = [NSString stringWithFormat:@"http://115.28.222.1/yijiaren/pics/certs/%@",[response objectForKey:@"wcPath"]];
            paraString = @"";
            DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:paraString];
            we_wcImage = [UIImage imageWithData:DataResponse];
            
            urlString = [NSString stringWithFormat:@"http://115.28.222.1/yijiaren/pics/certs/%@",[response objectForKey:@"pcPath"]];
            paraString = @"";
            DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:paraString];
            we_pcImage = [UIImage imageWithData:DataResponse];
            
            urlString = [NSString stringWithFormat:@"http://115.28.222.1/yijiaren/pics/certs/%@",[response objectForKey:@"qcPath"]];
            paraString = @"";
            DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:paraString];
            we_qcImage = [UIImage imageWithData:DataResponse];*/
            
            return YES;
        }
        if ([result isEqualToString:@"2"]) {
            NSDictionary *fields = [HTTPResponse objectForKey:@"fields"];
            NSEnumerator *enumerator = [fields keyEnumerator];
            id key;
            while ((key = [enumerator nextObject])) {
                NSString * tmp = [fields objectForKey:key];
                if (tmp != NULL) errorMessage = tmp;
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
                                 initWithTitle:@"登陆失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
    return NO;
}

- (void)send_forgetpass:(id)sender {
    NSLog(@"forget password:");
}

- (void)send_register:(id)sender {
    NSLog(@"segue~~:");
    [self performSegueWithIdentifier:@"wlc2ipn" sender:self];
}
- (void)segue_to_MapIdx:(id)sender {
    NSLog(@"segue~~:");
    we_targetTabId = 0;
    //[self performSegueWithIdentifier:@"RegWlc2TabBar" sender:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
