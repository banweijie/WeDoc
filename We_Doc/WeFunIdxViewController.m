//
//  WeFunIdxViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-20.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunIdxViewController.h"

@interface WeFunIdxViewController () {
    UIActivityIndicatorView * sys_pendingView;
    UITableView * sys_tableView;
    UIButton * refreshButton;
    UIView * contentView;
    
    UISearchBar * searchBar;
    UIButton * coverButton;
    
    NSMutableArray * fundingList;
    
    NSMutableString * sel_keyword;
    NSMutableString * sel_type;
    NSMutableString * sel_topSectionId;
    NSMutableString * sel_topSectionName;
    NSMutableString * sel_secSectionId;
    NSMutableString * sel_secSectionName;
    
    UIButton * lastPressedButton;
    
    UIToolbar * selectView;
    UIToolbar * searchView;
    UIButton * titleButton;
}

@end

@implementation WeFunIdxViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path
{
    WeFunDetViewController * vc = [[WeFunDetViewController alloc] init];
    vc.currentFundingId = [(WeFunding *)fundingList[path.section] fundingId];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[WeFundingCard alloc] initWithWeFunding:(WeFunding *)fundingList[indexPath.section]].frame.size.height;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 10 + 64;
    return 9;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 10 + self.tabBarController.tabBar.frame.size.height;
    }
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
    return [fundingList count];
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
    cell.backgroundColor = [UIColor clearColor];
    
    // 当前处理的众筹
    WeFunding * currentFunding = fundingList[indexPath.section];
    
    [cell.contentView addSubview:[[WeFundingCard alloc] initWithWeFunding:currentFunding]];
    
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
    
    //self.navigationItem.title = @"众筹项目";
    
    titleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [titleButton setFrame:CGRectMake(30, 0, 120, 64)];
    [titleButton setTitle:@"医家仁推荐 v" forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [titleButton.titleLabel setFont:We_font_textfield_huge_zh_cn];
    
    self.navigationItem.titleView = titleButton;
    
    /*
     // 我的众筹按钮
     UIBarButtonItem * myFundingButton = [[UIBarButtonItem alloc] initWithTitle:@"我的参与" style:UIBarButtonItemStylePlain target:self action:@selector(myFundingButton_onPress:)];
     self.navigationItem.rightBarButtonItem = myFundingButton;*/
    
    // 搜索按钮
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];

    // 表格
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [sys_tableView setHidden:YES];
    [self.view addSubview:sys_tableView];
    
    // 搜索按钮
    UIBarButtonItem * searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list-search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButton_onPress)];
    self.navigationItem.rightBarButtonItem = searchButton;
    
    
    // 筛选
    selectView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 64, 320, 280)];
    for (int i = 0; i < 7; i++) {
        WeInfoedButton * optionButton = [WeInfoedButton buttonWithType:UIButtonTypeRoundedRect];
        [optionButton setFrame:CGRectMake(0, 40 * i, 320, 40)];
        [optionButton setTintColor:We_foreground_black_general];
        [optionButton setUserData:[NSString stringWithFormat:@"%d", i]];
        [optionButton addTarget:self action:@selector(optionButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [optionButton setTintColor:We_foreground_red_general];
            lastPressedButton = optionButton;
        }
        if (i == 0) [optionButton setTitle:@"医家仁推荐" forState:UIControlStateNormal];
        if (i == 1) [optionButton setTitle:@"全部" forState:UIControlStateNormal];
        if (i == 2) [optionButton setTitle:@"科研类" forState:UIControlStateNormal];
        if (i == 3) [optionButton setTitle:@"公益类" forState:UIControlStateNormal];
        if (i == 4) [optionButton setTitle:@"招募类" forState:UIControlStateNormal];
        if (i == 5) [optionButton setTitle:@"进行中" forState:UIControlStateNormal];
        if (i == 6) [optionButton setTitle:@"已结束" forState:UIControlStateNormal];
        [selectView addSubview:optionButton];
    }
    [selectView setHidden:YES];
    [self.view addSubview:selectView];
    
    
    //
    searchView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 64, 320, 45)];
    [searchView setHidden:YES];
    [self.view addSubview:searchView];
    
    // search bar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    searchBar.placeholder = @"搜索";
    searchBar.translucent = YES;
    searchBar.backgroundImage = [UIImage new];
    searchBar.scopeBarBackgroundImage = [UIImage new];
    [searchBar setTranslucent:YES];
    searchBar.delegate = self;
    [searchView addSubview:searchBar];
    
    // cover button
    coverButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    coverButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    coverButton.frame = CGRectMake(0, 64 + 45, 320, self.view.frame.size.height);
    [coverButton addTarget:self action:@selector(coverButtonOnPress:) forControlEvents:UIControlEventTouchUpInside];
    coverButton.hidden = YES;
    [self.view addSubview:coverButton];
    
    
    // 转圈圈
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    // 刷新按钮
    refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshButton.frame = self.view.frame;
    [refreshButton setTitle:@"获取众筹列表失败，点击刷新" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTintColor:We_foreground_red_general];
    [self.view addSubview:refreshButton];
    
    // 访问获取众筹列表接口
    [self api_data_listHomeFundings];
}

- (void)viewWillAppear:(BOOL)animated {
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"texture"] forBarMetrics:UIBarMetricsDefault];
    [super viewWillAppear:animated];
    
    [sys_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    coverButton.hidden = NO;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    coverButton.hidden = YES;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sbar {
    [sel_keyword setString:searchBar.text];
    [searchBar resignFirstResponder];
    [searchView setHidden:YES];
    [self api_data_listFunding:@{@"f.words":searchBar.text}];
    if ([searchBar.text isEqualToString:@""]) {
        [titleButton setTitle:@"全部 v" forState:UIControlStateNormal];
    }
    else {
        [titleButton setTitle:[NSString stringWithFormat:@"搜索：%@ v", searchBar.text] forState:UIControlStateNormal];
    }
}

- (void)coverButtonOnPress:(id)sender {
    [self searchButton_onPress];
    [sel_keyword setString:searchBar.text];
    [self api_data_listFunding:@{@"f.words":searchBar.text}];if ([searchBar.text isEqualToString:@""]) {
        [titleButton setTitle:@"全部 v" forState:UIControlStateNormal];
    }
    else {
        [titleButton setTitle:[NSString stringWithFormat:@"搜索：%@ v", searchBar.text] forState:UIControlStateNormal];
    }
}

//
- (void)titleButton_onPress:(id)sender {
    if(!searchView.isHidden)
    {
        [self searchButton_onPress];
    }
    [selectView setHidden:!selectView.isHidden];}

- (void)optionButton_onPress:(WeInfoedButton *)sender {
    NSString * order = sender.userData;
    if (lastPressedButton) {
        [lastPressedButton setTitleColor:We_foreground_black_general forState:UIControlStateNormal];
    }
    lastPressedButton = sender;
    [sender setTitleColor:We_foreground_red_general forState:UIControlStateNormal];
    
    if ([order isEqualToString:@"0"]) {
        [titleButton setTitle:@"医家仁推荐 v" forState:UIControlStateNormal];
        [self api_data_listHomeFundings];
    }
    if ([order isEqualToString:@"1"]) {
        [titleButton setTitle:@"全部 v" forState:UIControlStateNormal];
        [self api_data_listFunding:@{}];
    }
    if ([order isEqualToString:@"2"]) {
        [titleButton setTitle:@"科研类 v" forState:UIControlStateNormal];
        [self api_data_listFunding:@{@"f.type":@"B"}];
    }
    if ([order isEqualToString:@"3"]) {
        [titleButton setTitle:@"公益类 v" forState:UIControlStateNormal];
        [self api_data_listFunding:@{@"f.type":@"A"}];
    }
    if ([order isEqualToString:@"4"]) {
        [titleButton setTitle:@"招募类 v" forState:UIControlStateNormal];
        [self api_data_listFunding:@{@"f.type":@"D"}];
    }
    if ([order isEqualToString:@"5"]) {
        [titleButton setTitle:@"进行中 v" forState:UIControlStateNormal];
        [self api_data_listFunding:@{@"f.status":@"E"}];
    }
    if ([order isEqualToString:@"6"]) {
        [titleButton setTitle:@"已结束 v" forState:UIControlStateNormal];
        [self api_data_listFunding:@{@"f.status":@"G"}];
    }
    [selectView setHidden:YES];
}

- (void)searchButton_onPress {
    [selectView setHidden:YES];
    if (!searchView.isHidden) {
        searchView.hidden=YES;
        coverButton.hidden = YES;
        [searchBar resignFirstResponder];
    }else
    {
        searchView.hidden=NO;
        coverButton.hidden = NO;
        [searchBar becomeFirstResponder];
    }
}

// 刷新按钮被按下
- (void)refreshButton_onPress:(id)sender {
    [self api_data_listFunding];
}

#pragma mark - api

- (void)api_doctor_likeFunding:(WeInfoedButton *)sender {
    [sys_pendingView startAnimating];
    WeFunding * currentFunding = sender.userData;
    
    [WeAppDelegate postToServerWithField:@"doctor" action:@"likeFunding"
                              parameters:@{@"fundingId": currentFunding.fundingId}
                                 success:^(id response) {
                                     currentFunding.likeCount = [NSString stringWithFormat:@"%d", [currentFunding.likeCount intValue] + 1];
                                     [sys_tableView reloadData];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     [[[UIAlertView alloc] initWithTitle:@"点赞失败" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                     [sys_pendingView stopAnimating];
                                 }];
}

// 获取众筹列表接口
- (void)api_data_listFunding:(NSDictionary *)parameters {
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];
    [sys_pendingView startAnimating];
    
    [WeAppDelegate postToServerWithField:@"data" action:@"listFunding"
                              parameters:parameters
                                 success:^(id response) {
                                     fundingList = [[NSMutableArray alloc] init];
                                     NSArray * fundingJsonList = response[@"list"];
                                     for (int i = 0; i < [fundingJsonList count]; i++) {
                                         [fundingList addObject:[[WeFunding alloc] initWithNSDictionary:fundingJsonList[i]]];
                                     }
                                     [sys_tableView reloadData];
                                     [sys_tableView setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     [refreshButton setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }];
}

// 获取众筹列表接口
- (void)api_data_listHomeFundings {
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];
    [sys_pendingView startAnimating];
    
    [WeAppDelegate postToServerWithField:@"data" action:@"listHomeFundings"
                              parameters:nil
                                 success:^(id response) {
                                     fundingList = [[NSMutableArray alloc] init];
                                     NSArray * fundingJsonList = response;
                                     for (int i = 0; i < [fundingJsonList count]; i++) {
                                         [fundingList addObject:[[WeFunding alloc] initWithNSDictionary:fundingJsonList[i]]];
                                     }
                                     [sys_tableView reloadData];
                                     [sys_tableView setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     [refreshButton setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}
@end
