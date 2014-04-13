//
//  WeRegisterInputVeriCodeViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeRegisterInputVeriCodeViewController.h"
#import "AFNetworking.h"
#import "WeAppDelegate.h"

@interface WeRegisterInputVeriCodeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sysNextStep;
@property (weak, nonatomic) IBOutlet UITextField *VeriCode;
@property (weak, nonatomic) IBOutlet UIButton *resendVeriCode;

@end

@implementation WeRegisterInputVeriCodeViewController
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
    if (path.section == 0) {
        return nil;
    }
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 1) {
        //[self performSelector:@selector(unselectCurrentRow) withObject:nil afterDelay:0];
    }
    if (path.section == 2) {
        //[self performSelector:@selector(unselectCurrentRow) withObject:nil afterDelay:0];
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
    if (section == 1) return 30;
    return 0;
}
// 询问每个段落的尾部标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //if (section == 1) return sys_countDown_demo;
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.contentView.backgroundColor = We_background_cell_general;
            cell.textLabel.text = @"验证码";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell addSubview:user_veriCode_input];
        }
    }
    if (indexPath.section == 1) {
        cell.contentView.backgroundColor = We_background_cell_general;
        if (sys_countDown_time == 0) {
            cell.textLabel.text = @"重发验证码";
        }
        else {
            cell.textLabel.text = [NSString stringWithFormat:@"重发验证码(%d)", sys_countDown_time];
        }
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_red_general;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (indexPath.section == 2) {
        cell.contentView.backgroundColor = We_background_red_tableviewcell;
        cell.textLabel.text = @"下一步";
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

/*
 [AREA]
 Functional
 */
- (void)resignFirstResponder:(id)sender {
    NSLog(@"resignFirstResponder:");
    [sender resignFirstResponder];
}
- (NSString *)sys_countDown_string {
    if (sys_countDown_time == 0) return @"";
    else return [NSString stringWithFormat:@"还有%d秒", sys_countDown_time];
}
// 取消Table的当前选中行
- (void) unselectCurrentRow
{
    [sys_tableView deselectRowAtIndexPath: [sys_tableView indexPathForSelectedRow] animated:YES];
}
- (void) sys_countDown_passTime {
    sys_countDown_time --;
    sys_countDown_demo_text.text = [self sys_countDown_string];
    //[sys_tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:<#(id), ...#>, nil withRowAnimation:YES];
     [sys_tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:0 inSection:1], nil] withRowAnimation:UITableViewRowAnimationNone];
    //[sys_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    if (sys_countDown_time == 0) {
        [sys_countDown_timer invalidate];
    }
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
    
    // sys_countDown_time
    sys_countDown_time = 60;
    sys_countDown_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sys_countDown_passTime) userInfo:nil repeats:YES];
    
    // user_veriCode_input init
    user_veriCode_input = [[UITextField alloc] initWithFrame:CGRectMake(100, 9, 220, 30)];
    user_veriCode_input.placeholder = @"请输入收到的短信验证码";
    user_veriCode_input.font = We_font_textfield_en_us;
    user_veriCode_input.autocorrectionType = UITextAutocorrectionTypeNo;
    [user_veriCode_input setClearButtonMode:UITextFieldViewModeWhileEditing];
    [user_veriCode_input addTarget:self action:@selector(resignFirstResponder:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    // sys_countDown_demo init
    sys_countDown_demo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    sys_countDown_demo_text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    sys_countDown_demo_text.text = [self sys_countDown_string];
    sys_countDown_demo_text.font = We_font_textfield_zh_cn;
    sys_countDown_demo_text.textColor = We_foreground_gray_general;
    sys_countDown_demo_text.textAlignment = NSTextAlignmentCenter;
    [sys_countDown_demo addSubview:sys_countDown_demo_text];
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.VeriCode) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSString *errorMessage = @"发送失败，请检查网络";
    NSString *urlString = @"http://115.28.222.1/yijiaren/user/checkVerificationCode.action";
    NSString *parasString = [NSString stringWithFormat:@"verificationCode=%@&", self.VeriCode.text];
    // get the
    NSData * DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:parasString];
    
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
        NSString *result = [HTTPResponse objectForKey:@"result"];
        result = [NSString stringWithFormat:@"%@", result];
        if ([result isEqualToString:@"1"]) {
            return YES;
        }
        if ([result isEqualToString:@"2"]) {
            NSString *fields = [HTTPResponse objectForKey:@"fields"];
            if (fields != NULL) errorMessage = [[HTTPResponse objectForKey:@"fields"] objectForKey:@"phone"];
        }
        if ([result isEqualToString:@"3"]) {
            errorMessage = [HTTPResponse objectForKey:@"info"];
        }
        if ([result isEqualToString:@"4"]) {
            errorMessage = [HTTPResponse objectForKey:@"info"];
        }
    }
    UIAlertView *notPermitted = [[UIAlertView alloc]
                                 initWithTitle:@"验证失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
    return NO;
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
