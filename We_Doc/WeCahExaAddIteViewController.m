//
//  WeCahExaAddIteViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCahExaAddIteViewController.h"

@interface WeCahExaAddIteViewController () {
    UITableView * sys_tableView;
    UIActivityIndicatorView * sys_pendingView;
    UIPickerView * sys_pickerView;
    UITextField * user_value_input;
}

@end

@implementation WeCahExaAddIteViewController

/*
 [AREA]
 UIPickerView dataSource & delegate interfaces
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == sys_pickerView) {
        return 1;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == sys_pickerView) {
        return [we_secondaryTypeKeyToData[examinationChanging.type.objId] count];
    }
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * newView = (UILabel *)view;
    if (!newView) {
        newView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 32)];
        //newView.font = We_font_textfield_zh_cn;
        newView.text = [NSString stringWithFormat:@"%@ (%@)", we_secondaryTypeKeyToData[examinationChanging.type.objId][row][@"name"], we_secondaryTypeKeyToData[examinationChanging.type.objId][row][@"unit"]];
        newView.adjustsFontSizeToFitWidth = YES;
    }
    return newView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [pickerView reloadAllComponents];
}

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
        if (path.section == 1 && path.row == 0) {
            [user_value_input becomeFirstResponder];
        }
        if (path.section == 2 && path.row == 0) {
            [self removeExaminationItem:self];
        }
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return sys_pickerView.frame.size.height;
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 11 + 64;
    return 10;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
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
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    if (tv == sys_tableView) {
        if (itemChanging == nil) return 2;
        else return 3;
    }
    return 0;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (tv == sys_tableView) {
        if (section == 0) return 1;
        if (section == 1) return 1;
        if (section == 2) return 1;
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
            [cell.contentView addSubview:sys_pickerView];
        }
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.backgroundColor = We_foreground_white_general;
            [cell.contentView addSubview:user_value_input];
        }
        if (indexPath.section == 2 && indexPath.row == 0) {
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
    
    self.navigationItem.title = @"检查条目详情";
    
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
    
    // 选择框初始化
    sys_pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 0, 280, 216)];
    sys_pickerView.delegate = self;
    
    if (itemChanging == nil) {
        We_init_textFieldInCell_forInput(user_value_input, @"", @"请输入该项的值", We_font_textfield_zh_cn);
    }
    else {
        We_init_textFieldInCell_forInput(user_value_input, itemChanging.value, @"请输入该项的值", We_font_textfield_zh_cn);
        for (int i = 0; i < [we_secondaryTypeKeyToData[examinationChanging.type.objId] count]; i++) {
            if ([[WeAppDelegate toString:we_secondaryTypeKeyToData[examinationChanging.type.objId][i][@"id"]] isEqualToString:itemChanging.config.configId]) {
                [sys_pickerView selectRow:i inComponent:0 animated:NO];
            }
        }
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
    
    // 取消按键
    if (itemChanging == nil) {
        UIBarButtonItem * user_cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(user_cancel_onPress:)];
        self.navigationItem.leftBarButtonItem = user_cancel;
    }
}

- (void)user_save_onPress:(id)sender {
    if (itemChanging == nil) {
        [self addExaminationItem:self];
    }
    else {
        [self updateExaminationItem:self];
    }
}

- (void)user_cancel_onPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)removeExaminationItem:(id)sender {
    [sys_pendingView startAnimating];
    [self.view endEditing:YES];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:yijiarenUrl(@"patient", @"removeExaminationItem") parameters:@{
                                                                                 @"eiId":itemChanging.itemId
                                                                            }
          success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
              NSString * errorMessage;
              //NSLog(@"HTTPResponse : %@", HTTPResponse);
              
              NSString *result = [HTTPResponse objectForKey:@"result"];
              result = [NSString stringWithFormat:@"%@", result];
              if ([result isEqualToString:@"1"]) {
                  [examinationChanging.items removeObject:itemChanging];
                  
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
                                           initWithTitle:@"删除药物信息失败"
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
                                           initWithTitle:@"删除药物信息失败"
                                           message:@"未能连接服务器，请重试"
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
     ];
}

- (void)addExaminationItem:(id)sender {
    [sys_pendingView startAnimating];
    [self.view endEditing:YES];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:yijiarenUrl(@"patient", @"addExaminationItem") parameters:@{
                                                                              @"ei.config.id":we_secondaryTypeKeyToData[examinationChanging.type.objId][[sys_pickerView selectedRowInComponent:0]][@"id"],
                                                                              @"ei.value":user_value_input.text,
                                                                              @"examinationId":examinationChanging.examId
                                                                         }
          success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
              NSString * errorMessage;
              //NSLog(@"HTTPResponse : %@", HTTPResponse);
              
              NSString *result = [HTTPResponse objectForKey:@"result"];
              result = [NSString stringWithFormat:@"%@", result];
              if ([result isEqualToString:@"1"]) {
                  WeExaminationItem * newItem = [[WeExaminationItem alloc] initWithNSDictionary:HTTPResponse[@"response"]];
                  newItem.config.name = we_secondaryTypeKeyToData[examinationChanging.type.objId][[sys_pickerView selectedRowInComponent:0]][@"name"];
                  newItem.config.unit = we_secondaryTypeKeyToData[examinationChanging.type.objId][[sys_pickerView selectedRowInComponent:0]][@"unit"];
                  [examinationChanging.items addObject:newItem];
                  
                  [sys_pendingView stopAnimating];
                  [self dismissViewControllerAnimated:YES completion:nil];
                  
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
                                           initWithTitle:@"添加检查条目失败"
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
                                           initWithTitle:@"添加检查条目失败"
                                           message:@"未能连接服务器，请重试"
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
     ];
}

- (void)updateExaminationItem:(id)sender {
    [sys_pendingView startAnimating];
    [self.view endEditing:YES];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:yijiarenUrl(@"patient", @"updateExaminationItem") parameters:@{
                                                                                 @"ei.config.id":we_secondaryTypeKeyToData[examinationChanging.type.objId][[sys_pickerView selectedRowInComponent:0]][@"id"],
                                                                                 @"ei.value":user_value_input.text,
                                                                                 @"examinationId":examinationChanging.examId
                                                                            }
          success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
              NSString * errorMessage;
              //NSLog(@"HTTPResponse : %@", HTTPResponse);
              
              NSString *result = [HTTPResponse objectForKey:@"result"];
              result = [NSString stringWithFormat:@"%@", result];
              if ([result isEqualToString:@"1"]) {
                  itemChanging.config.name = we_secondaryTypeKeyToData[examinationChanging.type.objId][[sys_pickerView selectedRowInComponent:0]][@"name"];
                  itemChanging.config.unit = we_secondaryTypeKeyToData[examinationChanging.type.objId][[sys_pickerView selectedRowInComponent:0]][@"unit"];
                  itemChanging.value = user_value_input.text;
                  
                  [sys_pendingView stopAnimating];
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
                                           initWithTitle:@"更新药物信息失败"
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
                                           initWithTitle:@"更新药物信息失败"
                                           message:@"未能连接服务器，请重试"
                                           delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
              [notPermitted show];
          }
     ];
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
