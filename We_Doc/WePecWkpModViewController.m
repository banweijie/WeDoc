//
//  WePecWkpModViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-20.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePecWkpModViewController.h"
#import "WeAppDelegate.h"

@interface WePecWkpModViewController () {
    UITableView * sys_tableView;
    
    UILabel * user_dayOfWeek_label;
    UILabel * user_periodOfDay_label;
    UILabel * user_typeOfPeriod_label;
}

@end

@implementation WePecWkpModViewController

/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    //    if (path.section == 0 && path.row == 0) [user_exp_startyear becomeFirstResponder];
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 0) {
        if (path.row == 0) [self performSegueWithIdentifier:@"PecWkpMod_pushto_SelDay" sender:self];
        if (path.row == 1) [self performSegueWithIdentifier:@"PecWkpMod_pushto_SelPer" sender:self];
        if (path.row == 2) [self performSegueWithIdentifier:@"PecWkpMod_pushto_SelTyp" sender:self];
    }
    if (path.section == 1 && path.row == 0) {
        we_workPeriod = [NSString stringWithFormat:@"%@%@", [we_workPeriod substringToIndex:we_wkpTOModify_id * 4],  [we_workPeriod substringFromIndex:we_wkpTOModify_id * 4 + 4]];
        NSLog(@"%@", we_workPeriod);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    return 2;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
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
            switch (indexPath.row) {
                case 0:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"出诊时间";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_dayOfWeek_label];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                case 1:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"出诊时间段";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_periodOfDay_label];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                case 2:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"出诊类型";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell addSubview:user_typeOfPeriod_label];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            cell.contentView.backgroundColor = We_background_red_general;
            cell.textLabel.text = @"删除本条出诊时间";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_white_general;
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

- (void)user_save_onpress:(id)sender {
    we_workPeriod = [NSString stringWithFormat:@"%@-%@%@%@%@", [we_workPeriod substringToIndex:we_wkpTOModify_id * 4], we_wkp_dayOfWeek, we_wkp_periodOfDay, we_wkp_typeOfPeriod, [we_workPeriod substringFromIndex:we_wkpTOModify_id * 4 + 4]];
    NSLog(@"%@", we_workPeriod);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem * user_save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(user_save_onpress:)];
    self.navigationItem.rightBarButtonItem = user_save;
    
    we_wkp_dayOfWeek = [we_workPeriod substringWithRange:NSMakeRange(we_wkpTOModify_id * 4 + 1, 1)];
    we_wkp_periodOfDay = [we_workPeriod substringWithRange:NSMakeRange(we_wkpTOModify_id * 4 + 2, 1)];
    we_wkp_typeOfPeriod = [we_workPeriod substringWithRange:NSMakeRange(we_wkpTOModify_id * 4 + 3, 1)];
    
    We_init_labelInCell_general(user_dayOfWeek_label, [WeAppDelegate transitionDayOfWeekFromChar:we_wkp_dayOfWeek], We_font_textfield_zh_cn)
    We_init_labelInCell_general(user_periodOfDay_label, [WeAppDelegate transitionPeriodOfDayFromChar:we_wkp_periodOfDay], We_font_textfield_zh_cn)
    We_init_labelInCell_general(user_typeOfPeriod_label, [WeAppDelegate transitionTypeOfPeriodFromChar:we_wkp_typeOfPeriod], We_font_textfield_zh_cn)
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 570) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = We_background_general;
    [self.view addSubview:sys_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    user_dayOfWeek_label.text = [WeAppDelegate transitionDayOfWeekFromChar:we_wkp_dayOfWeek];
    user_periodOfDay_label.text = [WeAppDelegate transitionPeriodOfDayFromChar:we_wkp_periodOfDay];
    user_typeOfPeriod_label.text = [WeAppDelegate transitionTypeOfPeriodFromChar:we_wkp_typeOfPeriod];
    [sys_tableView reloadData];
    [super viewWillAppear:animated];
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
