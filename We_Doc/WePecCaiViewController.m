//
//  WePecCaiViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-13.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePecCaiViewController.h"
#import "WeAppDelegate.h"
#import <UIImageView+AFNetworking.h>

@interface WePecCaiViewController ()

@end

@implementation WePecCaiViewController {
    UITextField * user_category_input;
    UITextField * user_speciality_input;
    UITextField * user_degree_input;
    UITextField * user_workphone_input;
    UITextField * user_email_input;
    UITableView * sys_tableView;
}

/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (path.section == 0) {
        if (path.row == 0) {
            [self performSegueWithIdentifier:@"selectionOfHospitalInCareerInformation" sender:self];
        }
        if (path.row == 1) {
            [self performSegueWithIdentifier:@"selectionOfSectionInCareerInformation" sender:self];
        }
        if (path.row == 2) {
            [self performSegueWithIdentifier:@"selectionOfTitleInCareerInformation" sender:self];
        }
    }
    if (path.section == 1) {
        if (path.row == 0) {
            [self performSegueWithIdentifier:@"PecCai2PecCtf" sender:self];
        }
        if (path.row == 1) {
            [self performSegueWithIdentifier:@"PecCai2PecVctf" sender:self];
        }
        if (path.row == 2) {
            [self performSegueWithIdentifier:@"PecCai_pushto_PecCaiWkp" sender:self];
        }
    }
    if (path.section == 2) {
        if (path.row == 0) {
            [self performSegueWithIdentifier:@"PecCai_pushto_PecCaiGri" sender:self];
        }
        if (path.row == 1) {
            [self performSegueWithIdentifier:@"inputOfSkillInCareerInfo" sender:self];
        }
        if (path.row == 2) {
            [self performSegueWithIdentifier:@"selectionOfDegreeInCareerInfo" sender:self];
        }
    }
    if (path.section == 3) {
        if (path.row == 0) {
            [self performSegueWithIdentifier:@"inputOfEmailInCareerInfo" sender:self];
        }
    }
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
    return 4;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 1;
            break;
        default:
            return 0;
    }
}
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = 0.85;
    cell.opaque = YES;
}

// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    UIImageView * imageView;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.backgroundColor = We_background_cell_general;
                    cell.detailTextLabel.text = currentUser.hospitalName;
                    cell.detailTextLabel.font = We_font_textfield_zh_cn;
                    cell.detailTextLabel.textColor = We_foreground_gray_general;
                    cell.textLabel.text = @"医院";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                case 1:
                    cell.backgroundColor = We_background_cell_general;
                    cell.detailTextLabel.text = currentUser.sectionName;
                    cell.detailTextLabel.font = We_font_textfield_zh_cn;
                    cell.detailTextLabel.textColor = We_foreground_gray_general;
                    cell.textLabel.text = @"科室";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                case 2:
                    cell.backgroundColor = We_background_cell_general;
                    cell.detailTextLabel.text = we_codings[@"doctorCategory"][currentUser.category][@"title"][currentUser.title];
                    cell.detailTextLabel.font = We_font_textfield_zh_cn;
                    cell.detailTextLabel.textColor = We_foreground_gray_general;
                    cell.textLabel.text = @"职称";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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
                    if ([currentUser.qcPath isEqualToString:@""]) {
                        cell.detailTextLabel.text = @"必填";
                        cell.detailTextLabel.font = We_font_textfield_zh_cn;
                        cell.detailTextLabel.textColor = We_foreground_gray_general;
                    }
                    else {
                        imageView = [[UIImageView alloc]initWithFrame:We_frame_detailImageInCell_general];
                        [imageView setImageWithURL:[NSURL URLWithString:yijiarenCertUrl(currentUser.qcPath)]];
                        [cell.contentView addSubview:imageView];
                    }
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                case 1:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"职业证书";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    if ([currentUser.pcPath isEqualToString:@""]) {
                        cell.detailTextLabel.text = @"必填";
                        cell.detailTextLabel.font = We_font_textfield_zh_cn;
                        cell.detailTextLabel.textColor = We_foreground_gray_general;
                    }
                    else {
                        imageView = [[UIImageView alloc]initWithFrame:We_frame_detailImageInCell_general];
                        [imageView setImageWithURL:[NSURL URLWithString:yijiarenCertUrl(currentUser.pcPath)]];
                        [cell.contentView addSubview:imageView];
                    }
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                case 2:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"工作证照片";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    if ([currentUser.wcPath isEqualToString:@""]) {
                        cell.detailTextLabel.text = @"必填";
                        cell.detailTextLabel.font = We_font_textfield_zh_cn;
                        cell.detailTextLabel.textColor = We_foreground_gray_general;
                    }
                    else {
                        imageView = [[UIImageView alloc]initWithFrame:We_frame_detailImageInCell_general];
                        [imageView setImageWithURL:[NSURL URLWithString:yijiarenCertUrl(currentUser.wcPath)]];
                        [cell.contentView addSubview:imageView];
                    }
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
                    cell.textLabel.text = @"团队介绍";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    cell.detailTextLabel.text = currentUser.groupIntro;
                    if ([cell.detailTextLabel.text isEqualToString:@""]) cell.detailTextLabel.text = @"选填";
                    cell.detailTextLabel.font = We_font_textfield_zh_cn;
                    cell.detailTextLabel.textColor = We_foreground_gray_general;
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                case 1:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"专业特长";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    cell.detailTextLabel.text = currentUser.skills;
                    if ([cell.detailTextLabel.text isEqualToString:@""]) cell.detailTextLabel.text = @"选填";
                    cell.detailTextLabel.font = We_font_textfield_zh_cn;
                    cell.detailTextLabel.textColor = We_foreground_gray_general;
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                case 2:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"学位";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    cell.detailTextLabel.text = we_codings[@"doctorDegree"][currentUser.degree];
                    if ([currentUser.degree isEqualToString:@""]) cell.detailTextLabel.text = @"选填";
                    cell.detailTextLabel.font = We_font_textfield_zh_cn;
                    cell.detailTextLabel.textColor = We_foreground_gray_general;
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"邮箱";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    cell.detailTextLabel.text = currentUser.email;
                    if ([cell.detailTextLabel.text isEqualToString:@""]) cell.detailTextLabel.text = @"选填";
                    cell.detailTextLabel.font = We_font_textfield_zh_cn;
                    cell.detailTextLabel.textColor = We_foreground_gray_general;
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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

// 点击键盘上的return后调用的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (void)user_save_onpress:(id)sender {
    /*
    NSString *errorMessage = @"发送失败，请检查网络";
    NSString *urlString = @"http://115.28.222.1/yijiaren/doctor/updateInfo.action";
    NSString *parasString = [NSString stringWithFormat:@"hospital=%@&section=%@&consult_price=%@&max_response_gap=%@", we_workPeriod, user_plusPrice_value, user_consultPrice_value, user_maxResponseGap_value];
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
    [notPermitted show];*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    // save button
    UIBarButtonItem * user_save = [[UIBarButtonItem alloc] initWithTitle:[WeAppDelegate transition:currentUser.status asin:@"doctorStatus"] style:UIBarButtonItemStylePlain target:self action:@selector(user_save_onpress:)];
    self.navigationItem.rightBarButtonItem = user_save;
}

- (void)viewWillAppear:(BOOL)animated {
    [sys_tableView reloadData];
    [super viewWillAppear:YES];
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
