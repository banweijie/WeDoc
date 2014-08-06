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
    if (path.section == 0 && path.row == 3) {
        [self.navigationController pushViewController:[[WeInpEmaViewController alloc] init] animated:YES];
    }
    /*
    if (path.section == && path.row == 3) {
        WeSelLanViewController * vc = [[WeSelLanViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }*/
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
    if (section == 0) return 100 + 64;
    if (section == 2) return 80;
    return 20;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"以下为必填信息，如修改需要重新提交审核";
    if (section == 2) return @"以下为选填信息";
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    //if (section == 1) return 30;
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 20 + self.tabBarController.tabBar.frame.size.height;
    return 1;
}
// 询问每个段落的尾部标题
- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部
-(UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section{
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 3;
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

// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    cell.opaque = NO;
    cell.backgroundColor = We_background_cell_general;
    
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
                case 3:
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
                    /*
                case 2:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"教育背景";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    cell.detailTextLabel.text = currentUser.degree;
                    if ([currentUser.degree isEqualToString:@""]) cell.detailTextLabel.text = @"选填";
                    cell.detailTextLabel.font = We_font_textfield_zh_cn;
                    cell.detailTextLabel.textColor = We_foreground_gray_general;
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    break;*/
                case 2:
                    cell.backgroundColor = We_background_cell_general;
                    cell.detailTextLabel.text = [WeAppDelegate deCodeOfLanguages:currentUser.languages];
                    cell.detailTextLabel.font = We_font_textfield_zh_cn;
                    cell.detailTextLabel.textColor = We_foreground_gray_general;
                    cell.textLabel.text = @"工作语言";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
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
    [WeAppDelegate postToServerWithField:@"doctor" action:@"applyCheck" parameters:nil success:^(id response) {
        [[[UIAlertView alloc] initWithTitle:@"申请审核成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    } failure:^(NSString * errorMessage) {
        [[[UIAlertView alloc] initWithTitle:@"申请审核失败" message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
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
