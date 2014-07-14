//
//  WeConsultDetailViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-7-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeConsultDetailViewController.h"

@interface WeConsultDetailViewController () {
    UIActivityIndicatorView * sys_pendingView;
    UITableView * sys_tableView;
    UIButton * refreshButton;
    
    WeConsult * currentConsult;
}

@end

@implementation WeConsultDetailViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path {
    return path;
}

// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path {
    if (path.section == 1 && path.row == 0) {
        [self api_doctor_acceptConsult];
    }
    if (path.section == 2 && path.row == 0) {
        [self api_doctor_denyConsult];
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}

// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tv.rowHeight;
}

// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 10 + 64;
    return 9;
}

// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}

// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 10;
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
    return 3;
}

// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 2;
    if (section == 1) return 1;
    if (section == 2) return 1;
    return 1;
}

// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        if (indexPath.section == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        }
    }
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    
    [cell.textLabel setFont:We_font_textfield_zh_cn];
    [cell.textLabel setTextColor:We_foreground_black_general];
    [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
    [cell.detailTextLabel setTextColor:We_foreground_gray_general];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell.textLabel setText:@"性别"];
        [cell.detailTextLabel setText:[WeAppDelegate transitionGenderFromChar:currentConsult.gender]];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        [cell.textLabel setText:@"年龄"];
        [cell.detailTextLabel setText:currentConsult.age];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [cell.textLabel setText:@"接受咨询"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setTextColor:We_foreground_white_general];
        [cell setBackgroundColor:We_background_red_general];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        [cell.textLabel setText:@"拒绝咨询"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setTextColor:We_foreground_red_general];
        [cell setBackgroundColor:We_background_cell_general];
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
    
    self.navigationItem.title = @"咨询详情";
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:sys_tableView];
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    // 刷新按钮
    refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshButton.frame = self.view.frame;
    [refreshButton setTitle:@"获取咨询失败，点击刷新" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTintColor:We_foreground_red_general];
    [self.view addSubview:refreshButton];
    
    [self api_message_getConsultById];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - callbacks
- (void)refreshButton_onPress:(id)sender {
    [self api_message_getConsultById];
}

#pragma mark - api
- (void)api_message_getConsultById {
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];
    [sys_pendingView startAnimating];
    
    [WeAppDelegate postToServerWithField:@"message" action:@"getConsultById"
                              parameters:@{
                                           @"consultId":self.consultId
                                           }
                                 success:^(id response) {
                                     currentConsult = [[WeConsult alloc] initWithNSDictionary:response];
                                     [sys_tableView reloadData];
                                     [sys_tableView setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     NSLog(@"%@", errorMessage);
                                     [refreshButton setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }];
}

- (void)api_doctor_acceptConsult {
    [sys_pendingView startAnimating];
    
    [WeAppDelegate postToServerWithField:@"doctor" action:@"acceptConsult"
                              parameters:@{
                                           @"consultId":self.consultId
                                           }
                                 success:^(id response) {
                                     self.currentPatient.consultStatus = @"C";
                                     [self.navigationController popViewControllerAnimated:YES];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     NSLog(@"%@", errorMessage);
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                   initWithTitle:@"接受咨询失败"
                                                                   message:errorMessage
                                                                   delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                     [notPermitted show];
                                     [sys_pendingView stopAnimating];
                                 }];
}

- (void)api_doctor_denyConsult {
    [sys_pendingView startAnimating];
    
    [WeAppDelegate postToServerWithField:@"doctor" action:@"denyConsult"
                              parameters:@{
                                           @"consultId":self.consultId
                                           }
                                 success:^(id response) {
                                     self.currentPatient.consultStatus = @"N";
                                     [self.navigationController popViewControllerAnimated:YES];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     NSLog(@"%@", errorMessage);
                                     UIAlertView * notPermitted = [[UIAlertView alloc]
                                                                   initWithTitle:@"拒绝咨询失败"
                                                                   message:errorMessage
                                                                   delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                     [notPermitted show];
                                     [sys_pendingView stopAnimating];
                                 }];
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
