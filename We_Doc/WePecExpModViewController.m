//
//  WePecExpModViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-19.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePecExpModViewController.h"
#import "WeAppDelegate.h"

@interface WePecExpModViewController () {
    UITableView * sys_tableView;
    UITextField * user_exp_startyear;
    UITextField * user_exp_startmonth;
    UITextField * user_exp_endyear;
    UITextField * user_exp_endmonth;
    UITextField * user_exp_hospital;
    UITextField * user_exp_department;
    UITextField * user_exp_minister;
}

@end

@implementation WePecExpModViewController

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
    if (path.section == 0 && path.row == 0) [user_exp_startyear becomeFirstResponder];
    if (path.section == 0 && path.row == 1) [user_exp_startmonth becomeFirstResponder];
    if (path.section == 0 && path.row == 2) [user_exp_endyear becomeFirstResponder];
    if (path.section == 0 && path.row == 3) [user_exp_endmonth becomeFirstResponder];
    if (path.section == 1 && path.row == 0) [user_exp_hospital becomeFirstResponder];
    if (path.section == 1 && path.row == 1) [user_exp_department becomeFirstResponder];
    if (path.section == 1 && path.row == 2) [user_exp_minister becomeFirstResponder];
    return nil;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tv.rowHeight;
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
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 300;
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
            return 4;
            break;
        case 1:
            return 3;
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
            switch (indexPath.row) {
                case 0:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"开始年份";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_exp_startyear];
                    break;
                case 1:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"开始月份";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_exp_startmonth];
                    break;
                case 2:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"结束年份";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_exp_endyear];
                    break;
                case 3:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"结束月份";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_exp_endmonth];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"医院";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_exp_hospital];
                    break;
                case 1:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"科室";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_exp_department];
                    break;
                case 2:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"职称";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_exp_minister];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return cell;
}

/*
 [AREA]
 Response functions
 */
- (void) user_cancel_onpress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void) user_save_onpress:(id)sender {
    NSString *errorMessage = @"发送失败，请检查网络";
    NSString *urlString = @"http://115.28.222.1/yijiaren/doctor/updateExperience.action";
    NSString *parasString = [NSString stringWithFormat:@"fromMonth=%@&fromYear=%@&endMonth=%@&endYear=%@&hospital=%@&title=%@&section=%@&deId=%@", user_exp_startmonth.text, user_exp_startyear.text, user_exp_endmonth.text, user_exp_endyear.text, user_exp_hospital.text, user_exp_minister.text, user_exp_department.text, [WeAppDelegate toString:[[user_exps objectAtIndex:we_expToModify_id] objectForKey:@"id"]]];
    NSData * DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:parasString];
    
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
        NSString *result = [HTTPResponse objectForKey:@"result"];
        result = [NSString stringWithFormat:@"%@", result];
        if ([result isEqualToString:@"1"]) {
            [user_exps setObject:[NSDictionary dictionaryWithObjectsAndKeys:user_exp_startmonth.text, @"fromMonth", user_exp_startyear.text, @"fromYear", user_exp_endmonth.text, @"endMonth", user_exp_endyear.text,  @"endYear", user_exp_hospital.text, @"hospital", user_exp_minister.text, @"title", user_exp_department.text, @"section", [WeAppDelegate toString:[[user_exps objectAtIndex:we_expToModify_id] objectForKey:@"id"]], @"id", nil] atIndexedSubscript:we_expToModify_id];
            [self.navigationController popViewControllerAnimated:YES];
            return;
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
                                 initWithTitle:@"保存失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
}

/*
 [AREA]
 Functions
 */

/*
 [AREA]
 Overrided functions
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)tf {
    return YES;
}
// 任何文本框结束编辑后都会调用此方法
-(void)textFieldDidEndEditing:(UITextField *)sender
{
    
}

// 点击键盘上的return后调用的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
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
    
    // save button
    UIBarButtonItem * user_save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(user_save_onpress:)];
    self.navigationItem.rightBarButtonItem = user_save;
    
    NSLog(@"%d %s", we_expToModify_id, object_getClassName([[user_exps objectAtIndex:we_expToModify_id] objectForKey:@"fromYear"]));
    
    // textFields
    We_init_textFieldInCell_general(user_exp_startyear, [WeAppDelegate toString:[[user_exps objectAtIndex:we_expToModify_id] objectForKey:@"fromYear"]], We_font_textfield_zh_cn)
    We_init_textFieldInCell_general(user_exp_startmonth, [WeAppDelegate toString:[[user_exps objectAtIndex:we_expToModify_id] objectForKey:@"fromMonth"]], We_font_textfield_zh_cn)
    We_init_textFieldInCell_general(user_exp_endyear, [WeAppDelegate toString:[[user_exps objectAtIndex:we_expToModify_id] objectForKey:@"endYear"]], We_font_textfield_zh_cn)
    We_init_textFieldInCell_general(user_exp_endmonth, [WeAppDelegate toString:[[user_exps objectAtIndex:we_expToModify_id] objectForKey:@"endMonth"]], We_font_textfield_zh_cn)
    We_init_textFieldInCell_general(user_exp_hospital, [WeAppDelegate toString:[[user_exps objectAtIndex:we_expToModify_id] objectForKey:@"hospital"]], We_font_textfield_zh_cn)
    We_init_textFieldInCell_general(user_exp_department, [WeAppDelegate toString:[[user_exps objectAtIndex:we_expToModify_id] objectForKey:@"section"]], We_font_textfield_zh_cn)
    We_init_textFieldInCell_general(user_exp_minister, [WeAppDelegate toString:[[user_exps objectAtIndex:we_expToModify_id] objectForKey:@"title"]], We_font_textfield_zh_cn)
    
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
