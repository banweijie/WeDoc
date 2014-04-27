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
}

extern BOOL we_logined;
extern int we_targetTabId;

/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 0) {
        return nil;
    }
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 1) {
        [self performSelector:@selector(unselectCurrentRow) withObject:nil afterDelay:0];
        if (![self checkRepeatPassword]) return;
        if ([we_vericode_type isEqualToString:@"NewPassword"]) {
            if (![self submitPassword]) return;
            if (![self checkUserRights]) return;
            we_logined = YES;
        }
        else
        if ([we_vericode_type isEqualToString:@"ModifyPassword"]) {
            if (![self changePassword]) return;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else return;
        //[self segue_to_PmpIdx:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    //if (section == 1) return 30;
    return 0;
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
            cell.contentView.backgroundColor = We_background_cell_general;
            cell.textLabel.text = @"登录密码";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell addSubview:user_loginPassword_input];
        }
        if (indexPath.row == 1) {
            cell.contentView.backgroundColor = We_background_cell_general;
            cell.textLabel.text = @"重复密码";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell addSubview:user_repeatPassword_input];
        }
    }
    if (indexPath.section == 1) {
        cell.contentView.backgroundColor = We_background_red_tableviewcell;
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


/*
 [AREA]
 Actions of all views
 */
- (void)user_loginPassword_input_return:(id)sender {
    NSLog(@"user_loginPassword_input_return:");
    [user_repeatPassword_input becomeFirstResponder];
}
- (void)resignFirstResponder:(id)sender {
    NSLog(@"resignFirstResponder:");
    [sender resignFirstResponder];
}
- (void)segue_to_PmpIdx:(id)sender {
    NSLog(@"segue:to_PmpIdx~~:");
    [self performSegueWithIdentifier:@"irp2pec" sender:self];
}
/*
 [AREA]
 Functional
 */
// 取消Table的当前选中行
- (void) unselectCurrentRow
{
    [sys_tableView deselectRowAtIndexPath: [sys_tableView indexPathForSelectedRow] animated:NO];
}
- (BOOL) checkRepeatPassword {
    NSLog(@"checkVeriCode");
    NSString *errorMessege = @"输入的密码有误";
    
    if ([user_loginPassword_input.text isEqualToString:user_repeatPassword_input.text]) {
        return YES;
    }
    else {
        errorMessege = @"两次输入的密码不一致";
    }
    // alert error messege
    UIAlertView *notPermitted = [[UIAlertView alloc]
                                 initWithTitle:@"输入的密码有误"
                                 message:errorMessege
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
    return NO;
}

- (BOOL) changePassword {
    NSString *errorMessage = @"发送失败，请检查网络";
    NSString *urlString = @"http://115.28.222.1/yijiaren/user/updateInfo.action";
    NSString *parasString = [NSString stringWithFormat:@"password=%@", [user_loginPassword_input.text md5]];
    NSData * DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:parasString];
    
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
                                 initWithTitle:@"修改密码失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
    return NO;
}

- (BOOL) submitPassword {
    NSString *errorMessage = @"发送失败，请检查网络";
    NSString *urlString = @"http://115.28.222.1/yijiaren/user/doRegister.action";
    NSString *md5pw = user_loginPassword_input.text;
    md5pw = [md5pw md5];
    NSString *parasString = [NSString stringWithFormat:@"userType=D&password=%@", md5pw];
    NSData * DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:parasString];
    
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
                                 initWithTitle:@"创建用户失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
    return NO;
}
- (BOOL) checkUserRights {
    NSString *errorMessage = @"连接失败，请检查网络";
    NSString *urlString = @"http://115.28.222.1/yijiaren/user/login.action";
    NSString *md5pw = user_loginPassword_input.text;
    md5pw = [md5pw md5];
    NSString *parasString = [NSString stringWithFormat:@"phone=%@&password=%@", we_phone_onReg, md5pw];
    NSData * DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:parasString];
    
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
        NSString *result = [HTTPResponse objectForKey:@"result"];
        result = [NSString stringWithFormat:@"%@", result];
        if ([result isEqualToString:@"1"]) {
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
/*
 [AREA]
 View releated
 */
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
    [user_loginPassword_input addTarget:self action:@selector(resignFirstResponder:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    // user_repeatPassword_input init
    user_repeatPassword_input = [[UITextField alloc] initWithFrame:CGRectMake(100, 9, 220, 30)];
    user_repeatPassword_input.placeholder = @"请重复输入的密码";
    user_repeatPassword_input.font = We_font_textfield_en_us;
    user_repeatPassword_input.secureTextEntry = YES;
    user_repeatPassword_input.autocorrectionType = UITextAutocorrectionTypeNo;
    [user_repeatPassword_input setClearButtonMode:UITextFieldViewModeWhileEditing];
    [user_repeatPassword_input addTarget:self action:@selector(resignFirstResponder:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 700) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = We_background_general;
    [self.view addSubview:sys_tableView];
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
