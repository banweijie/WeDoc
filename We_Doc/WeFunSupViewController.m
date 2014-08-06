//
//  WeFunSupViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunSupViewController.h"

@interface WeFunSupViewController () {
    UITableView * sys_tableView;
    NSMutableArray * levels;
}

@end

@implementation WeFunSupViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path
{
    [tableView deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeFundingLevel * currentLevel = levels[indexPath.section];
    return [WeAppDelegate calcSizeForString:currentLevel.repay Font:We_font_textfield_zh_cn expectWidth:280].height + 80;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 20 + 64;
    return 19;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) return 20;
    return 1;
}
// 询问每个段落的尾部标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return [levels count];
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return 1;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    cell.opaque = NO;
    cell.backgroundColor = We_background_cell_general;
    
    // 当前处理的支持方案
    WeFundingLevel * currentLevel = levels[indexPath.section];

    UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 220 - 16, 60)];
    if ([currentLevel.type isEqualToString:@"E"]) {
        l1.text = currentLevel.way;
    }
    else {
        l1.text = [NSString stringWithFormat:@"支持 ￥%@", currentLevel.money];
    }
    l1.font = We_font_textfield_large_zh_cn;
    l1.textColor = We_foreground_red_general;
    [cell.contentView addSubview:l1];
    
    WeInfoedButton * supportButton = [WeInfoedButton buttonWithType:UIButtonTypeRoundedRect];
    [supportButton setFrame:CGRectMake(220, 15, 80, 30)];
    if ([currentLevel.limit isEqualToString:@"0"]) {
        [supportButton setTitle:[NSString stringWithFormat:@"支持(%@)", currentLevel.supportCount] forState:UIControlStateNormal];
    }
    else {
        [supportButton setTitle:[NSString stringWithFormat:@"支持(%@/%@)", currentLevel.supportCount, currentLevel.limit] forState:UIControlStateNormal];
    }
    [supportButton setBackgroundColor:We_foreground_red_general];
    [supportButton setTintColor:We_foreground_white_general];
    [supportButton.titleLabel setFont:We_font_textfield_zh_cn];
    //[supportButton setUserData:currentLevel];
    supportButton.userData = currentLevel;
    [supportButton.layer setCornerRadius:supportButton.frame.size.height / 2];
    //[supportButton addTarget:self action:@selector(supportButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:supportButton];
    
    CGSize sizezz = [currentLevel.repay sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 60, sizezz.width, sizezz.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = currentLevel.repay;
    label.font = We_font_textfield_zh_cn;
    label.textColor = We_foreground_gray_general;
    [cell.contentView addSubview:label];
    
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
    
    // 标题
    [self.navigationItem setTitle:@"选择支持方案"];
    
    // 取消按钮
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton_onPress:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    // 取出需要显示的级别
    levels = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.currentFunding.levels count]; i++) {
        WeFundingLevel * currentLevel = self.currentFunding.levels[i];
        if ([currentLevel.type isEqualToString:@"B"] || [currentLevel.type isEqualToString:@"E"]) {
            [levels addObject:currentLevel];
        }
    }
    
    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
}

- (void)cancelButton_onPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
