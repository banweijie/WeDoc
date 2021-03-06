//
//  WeCahIdxViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-24.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCahIdxViewController.h"

@interface WeCahIdxViewController () {
    UIView * view0;
    UIView * view1;
    UITableView * tableView_view0;
    UITableView * tableView_view1;
    UIActivityIndicatorView * sys_pendingView;
    NSMutableArray * tableViewData0;
    NSMutableArray * tableViewData1;
    
    //
    UIView * ssview0;
    UIButton * ssview0_shadowButton;
    UIPickerView * ssview0_picker;
    NSArray * secondaryTypeKeys;
    UIImageView * bg2;
    
    UIButton * view0AddButton;
    UIButton * view1AddButton;
    
    int restWork;
}

@end

@implementation WeCahIdxViewController

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
    if (tv == tableView_view0) {
        caseRecordChanging = tableViewData0[path.section][path.row];
        
        WeCahCahViewController * vc = [[WeCahCahViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (tv == tableView_view1) {
        examinationChanging = tableViewData1[path.section][path.row];
        
        WeCahExaViewController * vc = [[WeCahExaViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;//tv.rowHeight * 2;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    return 30;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    [view setBackgroundColor:We_background_red_general];
    UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
    l1.font = We_font_textfield_zh_cn;
    l1.textColor = We_foreground_white_general;
    if (tableView == tableView_view0) {
        l1.text = [self getYearAndMonth:[(WeCaseRecord *)tableViewData0[section][0] date]];
    }
    else {
        l1.text = [self getYearAndMonth:[(WeCaseRecord *)tableViewData1[section][0] date]];
    }
    [view addSubview:l1];
    return view;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) {
        return 1 ;//  + self.tabBarController.tabBar.frame.size.height;
    }
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
    if (tv == tableView_view0) {
        return [tableViewData0 count];
    }
    if (tv == tableView_view1) {
        return [tableViewData1 count];
    }
    return 0;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (tv == tableView_view0) {
        return [tableViewData0[section] count];
    }
    if (tv == tableView_view1) {
        return [tableViewData1[section] count];
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
    
    if (tv == tableView_view0) {
        WeCaseRecord * caseRecord = tableViewData0[indexPath.section][indexPath.row];
        cell.backgroundColor = We_foreground_white_general;
        
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 40)];
        l1.font = We_font_textfield_zh_cn;
        l1.textColor = We_foreground_black_general;
        l1.text = caseRecord.diseaseName;
        [cell.contentView addSubview:l1];
        
        UILabel * l2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 200, 40)];
        l2.font = We_font_textfield_zh_cn;
        l2.textColor = We_foreground_gray_general;
        l2.text = caseRecord.hospitalName;
        [cell.contentView addSubview:l2];
        
        UILabel * l3 = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 80, 88)];
        l3.font = We_font_textfield_zh_cn;
        l3.textColor = We_foreground_gray_general;
        l3.text = caseRecord.date;
        [cell.contentView addSubview:l3];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if (tv == tableView_view1) {
        WeExamination * examination = tableViewData1[indexPath.section][indexPath.row];
        cell.backgroundColor = We_foreground_white_general;
        
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 40)];
        l1.font = We_font_textfield_zh_cn;
        l1.textColor = We_foreground_black_general;
        l1.text = we_secondaryTypeKeyToValue[examination.type.objId];
        [cell.contentView addSubview:l1];
        
        UILabel * l2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 200, 40)];
        l2.font = We_font_textfield_zh_cn;
        l2.textColor = We_foreground_gray_general;
        l2.text = examination.hospital;
        [cell.contentView addSubview:l2];
        
        UILabel * l3 = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 80, 88)];
        l3.font = We_font_textfield_zh_cn;
        l3.textColor = We_foreground_gray_general;
        l3.text = examination.date;
        [cell.contentView addSubview:l3];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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

    self.navigationItem.title = @"病历管理";
    
    // 切换“就诊历史"和"检查结果"
    UIView * segControlView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 44)];
    segControlView.backgroundColor = We_background_red_general;
    
    UISegmentedControl * segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"就诊历史", @"检查结果", nil]];
    [segControl setFrame:CGRectMake(20, 7, 280, 30)];
    segControl.backgroundColor = [UIColor clearColor];
    segControl.selectedSegmentIndex = 0;
    segControl.tintColor = We_foreground_white_general;
    segControl.layer.cornerRadius = 5;
    [segControl addTarget:self action:@selector(selectedSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    [segControlView addSubview:segControl];
    
    // 就诊历史页面
    view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 44, 320, self.view.frame.size.height - 64 - 44)];
    
    
    // 就诊历史页面 - 目录
    tableView_view0 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, view0.frame.size.width, view0.frame.size.height) style:UITableViewStyleGrouped];
    tableView_view0.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView_view0.delegate = self;
    tableView_view0.dataSource = self;
    tableView_view0.backgroundColor = [UIColor clearColor];
    tableView_view0.bounces = NO;
    //tableView_view0.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 155)];
    
    // 就诊历史页面 - 背景
    UIImageView * view0Header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 155)];
    view0Header.image = [UIImage imageNamed:@"addcasehistory-bg"];
    view0Header.contentMode = UIViewContentModeCenter;
    [tableView_view0.tableHeaderView addSubview:view0Header];
    [tableView_view0.tableHeaderView addSubview:view0AddButton];
    
    [view0 addSubview:tableView_view0];
    
    // 检查结果页面
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 44, 320, self.view.frame.size.height - 64 - 44)];
    [view1 setHidden:YES];
    
    // 检查结果页面 - 添加按钮
    view1AddButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [view1AddButton setFrame:CGRectMake(10, 95, 300, 50)];
    [view1AddButton setBackgroundImage:[UIImage imageNamed:@"button-addcasehistory"] forState:UIControlStateNormal];
//    [view1AddButton addTarget:self action:@selector(view1AddButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    
    // 检查结果页面 - 目录
    tableView_view1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, view1.frame.size.width, view1.frame.size.height) style:UITableViewStyleGrouped];
    tableView_view1.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView_view1.delegate = self;
    tableView_view1.dataSource = self;
    tableView_view1.backgroundColor = [UIColor clearColor];
    [view1 addSubview:tableView_view1];
    tableView_view1.bounces = NO;
    //tableView_view1.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 155)];
    
    // 就诊历史页面 - 背景
    UIImageView * view1Header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 155)];
    view1Header.image = [UIImage imageNamed:@"addcasehistory-bg"];
    view1Header.contentMode = UIViewContentModeCenter;
    [tableView_view1.tableHeaderView addSubview:view1Header];
    [tableView_view1.tableHeaderView addSubview:view1AddButton];
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    [self.view addSubview:segControlView];
    [self.view addSubview:view0];
    [self.view addSubview:view1];
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    
    // 获取就诊历史和检查结果
    [sys_pendingView startAnimating];
    restWork = 0;
    
    [self api_message_viewRecordMessage];
}

- (void)viewWillAppear:(BOOL)animated {
    [self preworkOnCaseRecords:self];
    [tableView_view0 reloadData];
    
    [self preworkOnExaminations:self];
    [tableView_view1 reloadData];

    [super viewWillAppear:animated];
}

// 当segControl产生切换
- (void)selectedSegmentChanged:(UISegmentedControl *)segControl {
    //NSLog(@"%d", segControl.selectedSegmentIndex);
    if (segControl.selectedSegmentIndex == 0) {
        [view0 setHidden:NO];
        [view1 setHidden:YES];
    }
    else {
        [view0 setHidden:YES];
        [view1 setHidden:NO];
    }
}

- (NSString *)getYearAndMonth:(NSString *)date {
    return [NSString stringWithFormat:@"%@年%@月", [date substringWithRange:NSMakeRange(0, 4)], [date substringWithRange:NSMakeRange(5, 2)]];
}

- (void)preworkOnCaseRecords:(id)sender {
    [caseRecords sortUsingComparator:^NSComparisonResult(id rA, id rB) {
        return [[(WeCaseRecord *)rB date] compare:[(WeCaseRecord *)rA date]];
    }];
    tableViewData0 = [[NSMutableArray alloc] init];
    int j = -1;
    for (int i = 0; i < [caseRecords count]; i ++) {
        if (i == 0 || ![[self getYearAndMonth:[(WeCaseRecord *)caseRecords[i] date]] isEqualToString:[self getYearAndMonth:[(WeCaseRecord *)caseRecords[i - 1] date]]]) {
            j ++;
            tableViewData0[j] = [[NSMutableArray alloc] init];
        }
        [tableViewData0[j] addObject:caseRecords[i]];
    }
}

- (void)preworkOnExaminations:(id)sender {
    [examinations sortUsingComparator:^NSComparisonResult(id rA, id rB) {
        return [[(WeExamination *)rB date] compare:[(WeExamination *)rA date]];
    }];
    tableViewData1 = [[NSMutableArray alloc] init];
    int j = -1;
    for (int i = 0; i < [examinations count]; i ++) {
        if (i == 0 || ![[self getYearAndMonth:[(WeExamination *)examinations[i] date]] isEqualToString:[self getYearAndMonth:[(WeExamination *)examinations[i - 1] date]]]) {
            j ++;
            tableViewData1[j] = [[NSMutableArray alloc] init];
        }
        [tableViewData1[j] addObject:examinations[i]];
    }
}

#pragma mark - APIs

- (void)api_message_viewRecordMessage {
    [sys_pendingView startAnimating];
    [WeAppDelegate postToServerWithField:@"message" action:@"viewRecordMessage"
                              parameters:@{
                                           @"rmId":_rmId
                                           }
                                 success:^(id response) {
                                     caseRecords=[NSMutableArray array];
                                     for (int i = 0; i < [response[@"records"] count]; i++) {
                                         WeCaseRecord * newCaseRecord = [[WeCaseRecord alloc] initWithNSDictionary:response[@"records"][i]];
                                         [caseRecords addObject:newCaseRecord];
                                     }
                                     [self preworkOnCaseRecords:self];
                                     [tableView_view0 reloadData];
                                      examinations=[NSMutableArray array];
                                     for (int i = 0; i < [response[@"examinations"] count]; i++) {
                                        
                                         WeExamination * newExamination = [[WeExamination alloc] initWithNSDictionary:response[@"examinations"][i]];
                                         [examinations addObject:newExamination];
                                     }
                                     [self preworkOnExaminations:self];
                                     [tableView_view1 reloadData];
                                     
                                     
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     [[[UIAlertView alloc] initWithTitle:@"获取病例信息失败" message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                                     [sys_pendingView stopAnimating];
                                 }];
}

@end
