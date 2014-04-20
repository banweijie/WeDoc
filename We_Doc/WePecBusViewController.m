//
//  WePecBusViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-19.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePecBusViewController.h"
#import "WeAppDelegate.h"

@interface WePecBusViewController () {
    UITableView * sys_tableView;
    UIView * sys_explaination_view;
    UILabel * sys_explaination_label;
    UITextField * user_consultPrice_input;
    UITextField * user_plusPrice_input;
    UITextField * user_maxResponseGap_input;
    
    NSString * user_consultPrice_value;
    NSString * user_plusPrice_value;
    NSString * user_maxResponseGap_value;
    NSMutableString * user_workPeriod_value;
    
    UIBarButtonItem * user_save;
    
    NSString * tmp;
}

@end

@implementation WePecBusViewController

/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 2 && path.row == 0) [user_consultPrice_input becomeFirstResponder];
    if (path.section == 2 && path.row == 1) [user_plusPrice_input becomeFirstResponder];
    if (path.section == 3 && path.row == 0) [user_maxResponseGap_input becomeFirstResponder];
    if (path.section == 0) {
        we_wkpTOModify_id = path.row;
        [self performSegueWithIdentifier:@"Push_to_PecWkpMod" sender:self];
    }
    if (path.section == 1) {
        [self performSegueWithIdentifier:@"Modal_to_PecWkpAdd" sender:self];
    }
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
    if (section == 0) return 40;
    return 20;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"出诊时间";
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    //if (section == 1) return 30;
    if (section == 1) return 30;
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 300;
    return 10;
}
// 询问每个段落的尾部标题
- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
    //if (section == 2) return @"患者发出咨询请求后，若您未能在该时限内回复则取消咨询，并将咨询费返还至患者账户";
    return @"";
}
// 询问每个段落的尾部
-(UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section{
    if (section == 3) return sys_explaination_view;
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
            return [we_workPeriod length] / 4;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
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
            cell.contentView.backgroundColor = We_background_cell_general;
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@                                            %@", [WeAppDelegate transitionDayOfWeekFromChar:[we_workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 1, 1)]], [WeAppDelegate transitionPeriodOfDayFromChar:[we_workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 2, 1)]], [WeAppDelegate transitionTypeOfPeriodFromChar:[we_workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 3, 1)]]];
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            break;
        case 1:
            cell.contentView.backgroundColor = We_background_cell_general;
            cell.textLabel.text = @"添加出诊时间";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"咨询价格";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell.contentView addSubview:user_consultPrice_input];
                    break;
                case 1:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"加号预诊费";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell.contentView addSubview:user_plusPrice_input];
                    break;
                default:
                    break;
            }
            break;
        case 3:
            cell.contentView.backgroundColor = We_background_cell_general;
            cell.textLabel.text = @"咨询回复时限";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell.contentView addSubview:user_maxResponseGap_input];
            break;
        default:
            break;
    }
    return cell;
}

/*
 [AREA]
 Overrided functions
 */
// 任何文本框结束编辑后都会调用此方法
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == user_consultPrice_input) {
        user_consultPrice_value = user_consultPrice_input.text;
        user_consultPrice_input.text = [NSString stringWithFormat:@"%@ 元/次", user_consultPrice_value];
    }
    if (textField == user_plusPrice_input) {
        user_plusPrice_value = user_plusPrice_input.text;
        user_plusPrice_input.text = [NSString stringWithFormat:@"%@ 元/次", user_plusPrice_value];
    }
    if (textField == user_maxResponseGap_input) {
        user_maxResponseGap_value = user_maxResponseGap_input.text;
        user_maxResponseGap_input.text = [NSString stringWithFormat:@"%@ 小时", user_maxResponseGap_value];

    }
}

// 点击键盘上的return后调用的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == user_consultPrice_input) {
        user_consultPrice_input.text = user_consultPrice_value;
    }
    if (textField == user_plusPrice_input) {
        user_plusPrice_input.text = user_plusPrice_value;
    }
    if (textField == user_maxResponseGap_input) {
        user_maxResponseGap_input.text = user_maxResponseGap_value;
    }
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
    [sys_tableView reloadData];
    [super viewWillAppear:YES];
}

- (void)user_save_onpress:(id)sender {
    NSString *errorMessage = @"发送失败，请检查网络";
    NSString *urlString = @"http://115.28.222.1/yijiaren/doctor/updateInfo.action";
    NSString *parasString = [NSString stringWithFormat:@"work_period=%@&plus_price=%@&consult_price=%@&max_response_gap=%@", we_workPeriod, user_plusPrice_value, user_consultPrice_value, user_maxResponseGap_value];
    NSData * DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:parasString];
    
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
        NSString *result = [HTTPResponse objectForKey:@"result"];
        result = [NSString stringWithFormat:@"%@", result];
        if ([result isEqualToString:@"1"]) {
            we_workPeriod_save = we_workPeriod;
            we_plusPrice = user_plusPrice_value;
            we_consultPrice = user_consultPrice_value;
            we_maxResponseGap = user_maxResponseGap_value;
            [self.navigationController popViewControllerAnimated:YES];
            return;
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
                                 initWithTitle:@"保存失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    we_workPeriod = we_workPeriod_save;
    
    // save button
    user_save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(user_save_onpress:)];
    self.navigationItem.rightBarButtonItem = user_save;
    
    user_consultPrice_value = we_consultPrice;
    user_plusPrice_value = we_plusPrice;
    user_maxResponseGap_value = we_maxResponseGap;
    
    
    // user_consultPrice_input
    tmp = [NSString stringWithFormat:@"%@ 元/次", user_consultPrice_value];
    We_init_textFieldInCell_general(user_consultPrice_input, tmp, We_font_textfield_zh_cn);
    
    // user_plusPrice_input
    tmp = [NSString stringWithFormat:@"%@ 元/次", user_plusPrice_value];
    We_init_textFieldInCell_general(user_plusPrice_input, tmp, We_font_textfield_zh_cn);
    
    // user_maxResponseGap_input
    tmp = [NSString stringWithFormat:@"%@ 小时", user_maxResponseGap_value];
    We_init_textFieldInCell_general(user_maxResponseGap_input, tmp, We_font_textfield_zh_cn);
    
    // sys_explaination
    sys_explaination_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    sys_explaination_label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 30)];
    sys_explaination_label.lineBreakMode = NSLineBreakByWordWrapping;
    sys_explaination_label.numberOfLines = 0;
    sys_explaination_label.text = @"患者发出咨询请求后，若您未能在该时限内回复则取消咨询，并将咨询费返还至患者账户";
    sys_explaination_label.font = We_font_textfield_zh_cn;
    sys_explaination_label.textColor = We_foreground_gray_general;
    sys_explaination_label.textAlignment = NSTextAlignmentCenter;
    [sys_explaination_view addSubview:sys_explaination_label];
    
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