//
//  WePecExpAddViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-19.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePecExpAddViewController.h"
#import "WeAppDelegate.h"
#import "SRMonthPicker.h"
#import "WeSelectSelViewController.h"

@interface WePecExpAddViewController ()<SelectSelDelegrate> {
    UITableView * sys_tableView;
    UITextField * user_exp_startyear;
    UITextField * user_exp_startmonth;
    UITextField * user_exp_endyear;
    UITextField * user_exp_endmonth;
    UITextField * user_exp_hospital;
    UITextField * user_exp_department;
    UITextField * user_exp_minister;
    
    NSString *minss;
}
@end

@implementation WePecExpAddViewController

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
    if (path.section == 1 && path.row == 2)
    {
        WeSelectSelViewController * wesel=[[WeSelectSelViewController alloc]init];
        wesel.delegrate=self;
        
        [self.navigationController pushViewController:wesel animated:YES];
        
    }
    return nil;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    
}
-(void)selectInTableView:(NSString *)str sele:(NSString *)sel
{
    user_exp_minister.text=str;
    minss=sel;
    
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
//    we_codings[@"doctorCategory"];//职称字典
    NSDate *now = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:now];
    int y = [dd year];
    int m = [dd month];
    if ([user_exp_startyear.text intValue]>y || ([user_exp_startyear.text intValue]==y && [user_exp_startmonth.text intValue]>m)) {
        UIAlertView *notPermitted = [[UIAlertView alloc]
                                     initWithTitle:@"保存失败"
                                     message:@"起始时间不能大于当前时间"
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [notPermitted show];
        return;
    }
    if ([user_exp_endyear.text intValue]>y || ([user_exp_endyear.text intValue]==y && [user_exp_endmonth.text intValue]>m)) {
        if (![user_exp_endyear.text intValue]==9999) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"保存失败"
                                         message:@"结束时间不能大于当前时间"
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            [notPermitted show];
            return;
        }
    }

    
    NSString *errorMessage = @"发送失败，请检查网络";
    NSString *urlString = yijiarenUrl(@"doctor", @"addExperience");
    NSString *parasString = [NSString stringWithFormat:@"fromMonth=%@&fromYear=%@&endMonth=%@&endYear=%@&hospital=%@&title=%@&section=%@", user_exp_startmonth.text, user_exp_startyear.text, user_exp_endmonth.text, user_exp_endyear.text, user_exp_hospital.text, minss, user_exp_department.text];
    NSData * DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:parasString];
    
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
        NSString *result = [HTTPResponse objectForKey:@"result"];
        result = [NSString stringWithFormat:@"%@", result];
        if ([result isEqualToString:@"1"]) {
            [user_exps addObject:[NSDictionary dictionaryWithObjectsAndKeys:user_exp_startmonth.text, @"fromMonth", user_exp_startyear.text, @"fromYear", user_exp_endmonth.text, @"endMonth", user_exp_endyear.text,  @"endYear", user_exp_hospital.text, @"hospital", minss, @"title", user_exp_department.text, @"section", [NSString stringWithFormat:@"%@", [[HTTPResponse objectForKey:@"response"] objectForKey:@"id"]], @"id", nil]];

            [self dismissViewControllerAnimated:YES completion:nil];
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
- (void)monthPickerDidChangeDate:(SRMonthPicker *)monthPicker {
//    NSLog(@"monthpicker~");
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
    
    // cancel button
    UIBarButtonItem * user_cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(user_cancel_onpress:)];
    self.navigationItem.leftBarButtonItem = user_cancel;
    
    // save button
    UIBarButtonItem * user_save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(user_save_onpress:)];
    self.navigationItem.rightBarButtonItem = user_save;
    
    // textFields
    We_init_textFieldInCell_pholder(user_exp_startyear, @"", We_font_textfield_zh_cn)
    We_init_textFieldInCell_pholder(user_exp_startmonth, @"", We_font_textfield_zh_cn)
    We_init_textFieldInCell_pholder(user_exp_endyear, @"", We_font_textfield_zh_cn)
    We_init_textFieldInCell_pholder(user_exp_endmonth, @"", We_font_textfield_zh_cn)
    We_init_textFieldInCell_pholder(user_exp_hospital, @"如：北京三医", We_font_textfield_zh_cn)
    We_init_textFieldInCell_pholder(user_exp_department, @"如：皮肤科", We_font_textfield_zh_cn)
    We_init_textFieldInCell_pholder(user_exp_minister, @"如：主任", We_font_textfield_zh_cn)
    user_exp_minister.userInteractionEnabled=NO;
    user_exp_startyear.keyboardType=UIKeyboardTypeNumberPad;
    user_exp_startmonth.keyboardType=UIKeyboardTypeNumberPad;
    user_exp_endyear.keyboardType=UIKeyboardTypeNumberPad;
    user_exp_endmonth.keyboardType=UIKeyboardTypeNumberPad;

    
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


@end
