//
//  WeCahCahViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-24.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCahCahViewController.h"

@interface WeCahCahViewController () {
    UITableView * sys_tableView;
    UITextField * user_date_input;
    UITextField * user_hospitalName_input;
    UITextField * user_diseaseName_input;
    UITextView * user_treatment_input;
    UIActivityIndicatorView * sys_pendingView;
}

@end

@implementation WeCahCahViewController

/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
// 将展示某个Cell触发的事件
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
    if (tv == sys_tableView) {
        if (path.section == 0 && path.row == 0) {
            [user_date_input becomeFirstResponder];
        }
        if (path.section == 0 && path.row == 1) {
            [user_hospitalName_input becomeFirstResponder];
        }
        if (path.section == 0 && path.row == 2) {
            [user_diseaseName_input becomeFirstResponder];
        }
        if (path.section == 4 && path.row < [caseRecordChanging.recordDrugs count]) {
            recordDrugChanging = caseRecordChanging.recordDrugs[path.row];
            
            WeCahCahAddDruViewController * vc = [[WeCahCahAddDruViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (path.section == 5 && path.row == 0) {
            recordDrugChanging = nil;
            
            WeNavViewController * nav = [[WeNavViewController alloc] init];
            WeCahCahAddDruViewController * vc = [[WeCahCahAddDruViewController alloc] init];
            
            [nav pushViewController:vc animated:NO];
            [self presentViewController:nav animated:YES completion:nil];
        }
        if (path.section == 6 && path.row == 0) {
            [self removeCaseHistory:self];
        }
        if (path.section == 1) {
            [user_treatment_input becomeFirstResponder];
        }
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) return 200;
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 11 + 64;
    if (section == 2) return 40;
    if (section == 4) return 40;
    if (section == 6) return 40;
    return 10;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return @"相关检查结果";
    }
    if (section == 4) {
        return @"药物";
    }
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 111;
    return 1;
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
    if (tv == sys_tableView) {
        return 7;
    }
    return 0;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (tv == sys_tableView) {
        if (section == 0) return 3;
        if (section == 1) return 1;
        if (section == 2) return MAX([caseRecordChanging.examinations count], 1);
        if (section == 3) return 1;
        if (section == 4) return MAX([caseRecordChanging.recordDrugs count], 1);
        if (section == 5) return 1;
        if (section == 6) return 1;
    }
    return 0;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    
    if (tv == sys_tableView) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.text = @"就诊时间";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell.contentView addSubview:user_date_input];
        }
        if (indexPath.section == 0 && indexPath.row == 1) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.text = @"就诊地点";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell.contentView addSubview:user_hospitalName_input];
        }
        if (indexPath.section == 0 && indexPath.row == 2) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.text = @"疾病名称";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            [cell.contentView addSubview:user_diseaseName_input];
        }
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.backgroundColor = We_foreground_white_general;
            [cell.contentView addSubview:user_treatment_input];
        }
        if (indexPath.section == 2 && indexPath.row == 0 && [caseRecordChanging.examinations count] == 0) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.text = @"目前尚未有检查结果";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
        }
        if (indexPath.section == 3 && indexPath.row == 0) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_red_general;
            cell.textLabel.text = @"添加检查结果";
        }
        if (indexPath.section == 4 && indexPath.row == 0 && [caseRecordChanging.recordDrugs count] == 0) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.text = @"目前尚未有药物记录";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
        }
        if (indexPath.section == 4 && [caseRecordChanging.recordDrugs count] > 0) {
            WeRecordDrug * recordDrug = caseRecordChanging.recordDrugs[indexPath.row];
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.text = recordDrug.recordDrugName;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            cell.detailTextLabel.text = recordDrug.dosage;
            cell.detailTextLabel.font = We_font_textfield_zh_cn;
            cell.detailTextLabel.textColor = We_foreground_gray_general;
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        if (indexPath.section == 5 && indexPath.row == 0) {
            cell.backgroundColor = We_foreground_white_general;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_red_general;
            cell.textLabel.text = @"添加药物";
        }
        if (indexPath.section == 6 && indexPath.row == 0) {
            cell.backgroundColor = We_foreground_red_general;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_white_general;
            cell.textLabel.text = @"删除";
        }
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
    
    // 输入框初始化
    We_init_textFieldInCell_general(user_date_input, caseRecordChanging.date, We_font_textfield_en_us);
    We_init_textFieldInCell_general(user_hospitalName_input, caseRecordChanging.hospitalName, We_font_textfield_zh_cn);
    We_init_textFieldInCell_general(user_diseaseName_input, caseRecordChanging.diseaseName, We_font_textfield_zh_cn);
    We_init_textView_huge(user_treatment_input, caseRecordChanging.treatment, We_font_textfield_zh_cn)
    if ([user_treatment_input.text isEqualToString:@"<null>"]) {
        user_treatment_input.text = @"诊治过程";
    }
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    // 保存按键
    UIBarButtonItem * user_save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(user_save_onPress:)];
    self.navigationItem.rightBarButtonItem = user_save;
}

- (void)viewWillAppear:(BOOL)animated {
    [sys_tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)user_save_onPress:(id)sender {
    [self updateCaseHistory:self];
}

- (void)updateCaseHistory:(id)sender {
    [sys_pendingView startAnimating];
    [self.view endEditing:YES];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:yijiarenUrl(@"patient", @"updateRecord") parameters:@{
                                                                     @"record.date":user_date_input.text,
                                                                     @"record.hospital":user_hospitalName_input.text,
                                                                     @"record.disease":user_diseaseName_input.text,
                                                                     @"record.treatment":user_treatment_input.text,
                                                                     @"record.id":caseRecordChanging.caseRecordId
                                                                     }
          success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
              NSString * errorMessage;
              NSLog(@"HTTPResponse : %@", HTTPResponse);
              
              NSString *result = [HTTPResponse objectForKey:@"result"];
              result = [NSString stringWithFormat:@"%@", result];
              if ([result isEqualToString:@"1"]) {
                  caseRecordChanging.date = user_date_input.text;
                  caseRecordChanging.hospitalName = user_hospitalName_input.text;
                  caseRecordChanging.diseaseName = user_diseaseName_input.text;
                  caseRecordChanging.treatment = user_treatment_input.text;
                  
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
              [sys_pendingView stopAnimating];
              UIAlertView *notPermitted = [[UIAlertView alloc]
                                           initWithTitle:@"发送信息失败"
                                           message:errorMessage
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [sys_pendingView stopAnimating];
              UIAlertView *notPermitted = [[UIAlertView alloc]
                                           initWithTitle:@"发送信息失败"
                                           message:@"未能连接服务器，请重试"
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
     ];
}

- (void)removeCaseHistory:(id)sender {
    [sys_pendingView startAnimating];
    [self.view endEditing:YES];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:yijiarenUrl(@"patient", @"removeRecord") parameters:@{
                                                                        @"recordId":caseRecordChanging.caseRecordId
                                                                        }
          success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
              NSString * errorMessage;
              NSLog(@"HTTPResponse : %@", HTTPResponse);
              
              NSString *result = [HTTPResponse objectForKey:@"result"];
              result = [NSString stringWithFormat:@"%@", result];
              if ([result isEqualToString:@"1"]) {
                  [caseRecords removeObject:caseRecordChanging];
                  
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
              [sys_pendingView stopAnimating];
              UIAlertView *notPermitted = [[UIAlertView alloc]
                                           initWithTitle:@"发送信息失败"
                                           message:errorMessage
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [sys_pendingView stopAnimating];
              UIAlertView *notPermitted = [[UIAlertView alloc]
                                           initWithTitle:@"发送信息失败"
                                           message:@"未能连接服务器，请重试"
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
     ];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
