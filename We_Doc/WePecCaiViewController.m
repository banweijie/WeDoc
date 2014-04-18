//
//  WePecCaiViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-13.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePecCaiViewController.h"
#import "WeAppDelegate.h"

@interface WePecCaiViewController ()

@end

@implementation WePecCaiViewController {
    UITextField * user_hospital_input;
    UITextField * user_department_input;
    UITextField * user_minister_input;
    UITextField * user_category_input;
    UITextField * user_speciality_input;
    UITextField * user_degree_input;
    UITextField * user_workphone_input;
    UITextField * user_email_input;
    UITableView * sys_tableView;
    NSString * we_cai_data_hospital;
    NSString * we_cai_data_department;
    NSString * we_cai_data_minister;
    NSString * we_cai_data_category;
    NSString * we_cai_data_specialiy;
    NSString * we_cai_data_degree;
    NSString * we_cai_data_workphone;
    NSString * we_cai_data_email;
}

/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    // 选中该行自动跳转到该行的文本框
    switch (path.section) {
        case 0:
            switch (path.row) {
                case 0:
                    [user_hospital_input becomeFirstResponder];
                    break;
                case 1:
                    [user_department_input becomeFirstResponder];
                    break;
                case 2:
                    [user_minister_input becomeFirstResponder];
                    break;
                default:
                    break;
            }
            return nil;
            break;
        case 1:
            switch (path.row) {
                case 0:
                    [self performSegueWithIdentifier:@"PecCai2PecCtf" sender:self];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"PecCai2PecVctf" sender:self];
                    break;
                default:
                    break;
            }
        case 2:
            switch (path.row) {
                case 0:
                    [user_category_input becomeFirstResponder];
                    break;
                case 1:
                    [user_speciality_input becomeFirstResponder];
                    break;
                case 2:
                    [user_degree_input becomeFirstResponder];
                    break;
                default:
                    break;
            }
            return nil;
            break;
        case 3:
            switch (path.row) {
                case 0:
                    [user_workphone_input becomeFirstResponder];
                    break;
                case 1:
                    [user_email_input becomeFirstResponder];
                    break;
                default:
                    break;
            }
        default:
            break;
    }
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    /*
     if (path.section == 1) {
     [self performSelector:@selector(unselectCurrentRow) withObject:nil afterDelay:0];
     if (![self checkRepeatPassword]) return;
     if (![self submitPassword]) return;
     we_logined = YES;
     we_targetTabId = 2;
     [self segue_to_PmpIdx:nil];
     }*/
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    return 4;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 2;
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
                    cell.textLabel.text = @"医院";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_hospital_input];
                    break;
                case 1:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"科室";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_department_input];
                    break;
                case 2:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"职称";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_minister_input];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"资格证书";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                case 1:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"职业证书";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"类别";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_category_input];
                    break;
                case 1:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"专业特长";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_speciality_input];
                    break;
                case 2:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"学位";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_degree_input];
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"科室电话";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_workphone_input];
                    break;
                case 1:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"邮箱";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_email_input];
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
 Actions of all views
 */
- (void)segue_to_RegWlc:(id)sender {
    NSLog(@"segue:to_RegWlc~~:");
    [self performSegueWithIdentifier:@"PecIdx2RegWlc" sender:self];
}
- (void)segue_to_PecCai:(id)sender {
    NSLog(@"segue:to_RegWlc~~:");
    [self performSegueWithIdentifier:@"PecIdx2PecCai" sender:self];
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

// 任何文本框结束编辑后都会调用此方法
-(void)textFieldDidEndEditing:(UITextField *)sender
{
    if (sender == user_hospital_input) {
        NSLog(@"%@ %@", user_hospital_input.text, we_cai_data_hospital);
    }
    //[super textFieldDidBeginEditing:sender];
}

// 点击键盘上的return后调用的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // gather information from server
    we_cai_data_hospital = @"北京大学第三医院";
    we_cai_data_department = @"皮肤科";
    we_cai_data_minister = @"主任";
    we_cai_data_category = @"中医";
    we_cai_data_specialiy = @"专治跌打损伤";
    we_cai_data_degree = @"医学博士";
    we_cai_data_workphone = @"18810521309";
    we_cai_data_email = @"stevenhtx1993@163.com";
    
    // user_hospital_input;
    user_hospital_input = [[UITextField alloc] initWithFrame:We_frame_textFieldInCell_general];
    user_hospital_input.text = @"北京大学第三医院";
    user_hospital_input.font = We_font_textfield_zh_cn;
    user_hospital_input.textAlignment = NSTextAlignmentRight;
    [user_hospital_input setClearButtonMode:UITextFieldViewModeWhileEditing];
    user_hospital_input.delegate = self;
    
    // user_department_input;
    user_department_input = [[UITextField alloc] initWithFrame:We_frame_textFieldInCell_general];
    user_department_input.text = @"皮肤科";
    user_department_input.font = We_font_textfield_zh_cn;
    user_department_input.textAlignment = NSTextAlignmentRight;
    [user_department_input setClearButtonMode:UITextFieldViewModeWhileEditing];
    user_department_input.delegate = self;
    
    // user_minister_input;
    user_minister_input = [[UITextField alloc] initWithFrame:We_frame_textFieldInCell_general];
    user_minister_input.text = @"主任";
    user_minister_input.font = We_font_textfield_zh_cn;
    user_minister_input.textAlignment = NSTextAlignmentRight;
    [user_minister_input setClearButtonMode:UITextFieldViewModeWhileEditing];
    user_minister_input.delegate = self;
    
    // user_category_input;
    user_category_input = [[UITextField alloc] initWithFrame:We_frame_textFieldInCell_general];
    user_category_input.text = @"普通外科";
    user_category_input.font = We_font_textfield_zh_cn;
    user_category_input.textAlignment = NSTextAlignmentRight;
    [user_category_input setClearButtonMode:UITextFieldViewModeWhileEditing];
    user_category_input.delegate = self;
    
    // user_speciality_input;
    user_speciality_input = [[UITextField alloc] initWithFrame:We_frame_textFieldInCell_general];
    user_speciality_input.text = @"专治跌打损伤";
    user_speciality_input.font = We_font_textfield_zh_cn;
    user_speciality_input.textAlignment = NSTextAlignmentRight;
    [user_speciality_input setClearButtonMode:UITextFieldViewModeWhileEditing];
    user_speciality_input.delegate = self;
    
    // user_degree_input;
    user_degree_input = [[UITextField alloc] initWithFrame:We_frame_textFieldInCell_general];
    user_degree_input.text = @"医学博士";
    user_degree_input.font = We_font_textfield_zh_cn;
    user_degree_input.textAlignment = NSTextAlignmentRight;
    [user_degree_input setClearButtonMode:UITextFieldViewModeWhileEditing];
    user_degree_input.delegate = self;
    
    // user_workphone_input;
    user_workphone_input = [[UITextField alloc] initWithFrame:We_frame_textFieldInCell_general];
    user_workphone_input.text = @"18810521309";
    user_workphone_input.font = We_font_textfield_zh_cn;
    user_workphone_input.textAlignment = NSTextAlignmentRight;
    [user_workphone_input setClearButtonMode:UITextFieldViewModeWhileEditing];
    user_workphone_input.delegate = self;
    
    
    // user_email_input;
    user_email_input = [[UITextField alloc] initWithFrame:We_frame_textFieldInCell_general];
    user_email_input.text = @"stevenhtx1993@163.com";
    user_email_input.font = We_font_textfield_zh_cn;
    user_email_input.textAlignment = NSTextAlignmentRight;
    [user_email_input setClearButtonMode:UITextFieldViewModeWhileEditing];
    user_email_input.delegate = self;
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 550) style:UITableViewStyleGrouped];
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
