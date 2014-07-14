//
//  WeCsrAddViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-12.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrAddViewController.h"
#import "WeAppDelegate.h"

@interface WeCsrAddViewController () {
    UITableView * sys_tableView;
    NSMutableArray * doctorList;
    UISearchBar * searchBar;
    UITextField * user_searchContent_input;
    UIView * loadingViewContainer;
    UIActivityIndicatorView * loadingView;
    UIActivityIndicatorView * sys_pendingView;
    UIButton * coverButton;
    BOOL hasMore;
    BOOL isWaiting;
}

@end

@implementation WeCsrAddViewController

#define defaultNum 10

/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = We_alpha_cell_general;;
    cell.opaque = YES;
    NSLog(@"%d %d", indexPath.section, indexPath.row);
    if (indexPath.section == [doctorList count] - 1) {
        if (!isWaiting) {
            isWaiting = YES;
            if (hasMore) [self queryMoreDoctors:self];
        }
    }
}
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    doctorViewing = doctorList[path.section];
    [self performSegueWithIdentifier:@"CsrAdd_pushto_CsrDci" sender:self];
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) return tv.rowHeight * 1.5;
    else return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    return 10;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [doctorList count] - 1) {
        if (hasMore) return 1 + 40 + 10 + self.tabBarController.tabBar.frame.size.height;
        else return 1 + 10 + self.tabBarController.tabBar.frame.size.height;
    }
    return 1;
}
//
- (UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section{
    if (hasMore && section == [doctorList count] - 1) return loadingViewContainer;
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return [doctorList count];
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return 2;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    UILabel * l1;
    UILabel * l2;
    __block UIImageView *avatarView;
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    if (indexPath.section == [doctorList count]) {
        UIActivityIndicatorView * tmp = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [tmp setFrame:cell.frame];
        [tmp startAnimating];
        [cell.contentView addSubview:tmp];
        cell.backgroundView = [[UIView alloc] init];
        cell.backgroundColor = [UIColor clearColor];
    }
    else {
        WeDoctor * doctor = doctorList[indexPath.section];
        if (indexPath.row == 0) {
            cell.contentView.backgroundColor = We_background_cell_general;
            // l1 - user name
            l1 = [[UILabel alloc] initWithFrame:CGRectMake(75, 12, 240, 23)];
            if ([doctor.userName isEqualToString:@""]) {
                l1.text = @"尚未设置名称";
            }
            else {
                l1.text = [NSString stringWithFormat:@"%@ %@", doctor.userName, we_codings[@"doctorCategory"][doctor.category][@"title"][doctor.title]];
            }
            l1.font = We_font_textfield_zh_cn;
            l1.textColor = We_foreground_black_general;
            [cell.contentView addSubview:l1];
            // l2 - lastMsg - content
            l2 = [[UILabel alloc] initWithFrame:CGRectMake(75, 33, 240, 23)];
            l2.text = [NSString stringWithFormat:@"%@ %@", doctor.hospitalName, doctor.sectionName];
            l2.textColor = We_foreground_gray_general;
            l2.font = We_font_textfield_small_zh_cn;
            [cell.contentView addSubview:l2];
            // avatar
            avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 48, 48)];
            [avatarView setImageWithURL:[NSURL URLWithString:yijiarenAvatarUrl(doctor.avatarPath)]];
            avatarView.layer.cornerRadius = 24;
            avatarView.clipsToBounds = YES;
            [cell.contentView addSubview:avatarView];
        }
        if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"docinfo-crowdfunding"];
            cell.textLabel.text = @"众筹项目名称";
            cell.textLabel.font = We_font_textfield_small_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            cell.detailTextLabel.text = @"￥10,000已筹 / 52赞";
            cell.detailTextLabel.font = We_font_textfield_small_zh_cn;
            cell.detailTextLabel.textColor = We_foreground_gray_general;
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

- (void)selection:(id)sender {
    [self performSegueWithIdentifier:@"CsrAdd_pushto_CsrSel" sender:self];
}

- (void)clearSelectionCondition {
    selection_provinceId = @"<null>";
    selection_cityId = @"<null>";
    selection_hospitalId = @"<null>";
    selection_topSectionId = @"<null>";
    selection_sectionId = @"<null>";
    selection_category = @"<null>";
    selection_title = @"<null>";
    selection_recommend = @"<null>";
    selection_keyword = @"<null>";
}

- (void)coverButtonOnPress:(id)sender {
    [searchBar resignFirstResponder];
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
    selection_keyword = sbar.text;
    [searchBar resignFirstResponder];
    [self initialDoctorList:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // get doctor list
    hasMore = YES;
    isWaiting = NO;
    [self clearSelectionCondition];
    [self initialDoctorList:self];
    
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 64 + 85, 310, self.view.frame.size.height - 64 - 85) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    sys_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:sys_tableView];
    
    loadingViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1 + 40 + 10 + self.tabBarController.tabBar.frame.size.height)];
    
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView setFrame:CGRectMake(0, 5, 320, 40)];
    [loadingView startAnimating];
    [loadingViewContainer addSubview:loadingView];
    
    // bar background image
    UIImageView * barBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 85)];
    barBackground.image = [UIImage imageNamed:@"bar"];
    [self.view addSubview:barBackground];
    
    UIButton * sortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sortButton setFrame:CGRectMake(0, 64, 210, 40)];
    [sortButton setTitle:@"已筹募款从多到少" forState:UIControlStateNormal];
    [sortButton.titleLabel setFont:We_font_textfield_zh_cn];
    [sortButton setTintColor:We_foreground_red_general];
    [self.view addSubview:sortButton];
    
    UIButton * selectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [selectButton setFrame:CGRectMake(210, 64, 110, 40)];
    [selectButton setTitle:@"筛选" forState:UIControlStateNormal];
    [selectButton.titleLabel setFont:We_font_textfield_zh_cn];
    [selectButton setTintColor:We_foreground_red_general];
    [selectButton addTarget:self action:@selector(selection:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectButton];
    
    
    // sys_pendingView
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView setAlpha:1.0];
    [sys_pendingView startAnimating];
    [self.view addSubview:sys_pendingView];
    
    // search bar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 104, 320, 45)];
    searchBar.placeholder = @"搜索";
    searchBar.translucent = YES;
    searchBar.backgroundImage = [UIImage new];
    searchBar.scopeBarBackgroundImage = [UIImage new];
    [searchBar setTranslucent:YES];
    searchBar.delegate = self;
    
    // cover button
    coverButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    coverButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    coverButton.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    [coverButton addTarget:self action:@selector(coverButtonOnPress:) forControlEvents:UIControlEventTouchUpInside];
    coverButton.hidden = YES;
    [self.view addSubview:coverButton];
    
    [self.view addSubview:searchBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (selection_changed) {
        selection_changed = false;
        [sys_pendingView startAnimating];
        [self initialDoctorList:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)queryMoreDoctors:(id)sender {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"from":[NSString stringWithFormat:@"%d", [doctorList count]]}];
    NSLog(@"%@", selection_provinceId);
    if (![selection_provinceId isEqualToString:@"<null>"]) parameters[@"provinceId"] = selection_provinceId;
    if (![selection_cityId isEqualToString:@"<null>"]) parameters[@"cityId"] = selection_cityId;
    if (![selection_hospitalId isEqualToString:@"<null>"]) parameters[@"hospitalId"] = selection_hospitalId;
    if (![selection_topSectionId isEqualToString:@"<null>"]) parameters[@"topSectionId"] = selection_topSectionId;
    if (![selection_sectionId isEqualToString:@"<null>"]) parameters[@"sectionId"] = selection_sectionId;
    if (![selection_category isEqualToString:@"<null>"]) parameters[@"category"] = selection_category;
    if (![selection_title isEqualToString:@"<null>"]) parameters[@"title"] = selection_title;
    if (![selection_recommend isEqualToString:@"<null>"]) parameters[@"recommend"] = selection_recommend;
    if (![selection_keyword isEqualToString:@"<null>"]) parameters[@"conditions.words"] = selection_keyword;
    
    NSLog(@"queryMore %@", parameters);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:yijiarenUrl(@"patient", @"searchDoctors") parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
             NSString * errorMessage;
             NSString *result = [HTTPResponse objectForKey:@"result"];
             result = [NSString stringWithFormat:@"%@", result];
             //NSLog(@"Total amount : %@", HTTPResponse[@"info"]);
             if ([result isEqualToString:@"1"]) {
                 //NSLog(@"%@", HTTPResponse[@"response"]);
                 for (int i = 0; i < [HTTPResponse[@"response"] count]; i++) {
                     WeDoctor * doctor = [[WeDoctor alloc] initWithNSDictionary:HTTPResponse[@"response"][i]];
                     [doctorList addObject:doctor];
                 }
                 if ([HTTPResponse[@"info"] integerValue] == [doctorList count]) hasMore = NO;
                 //NSLog(@"%d", [HTTPResponse[@"info"] integerValue]);
                 [sys_tableView reloadData];
                 isWaiting = NO;
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
             NSLog(@"Response error: %@", errorMessage);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }
     ];

}

- (void)initialDoctorList:(id)sender {
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    NSLog(@"%@", selection_provinceId);
    if (![selection_provinceId isEqualToString:@"<null>"]) parameters[@"conditions.provinceId"] = selection_provinceId;
    if (![selection_cityId isEqualToString:@"<null>"]) parameters[@"conditions.cityId"] = selection_cityId;
    if (![selection_hospitalId isEqualToString:@"<null>"]) parameters[@"conditions.hospitalId"] = selection_hospitalId;
    if (![selection_topSectionId isEqualToString:@"<null>"]) parameters[@"conditions.topSectionId"] = selection_topSectionId;
    if (![selection_sectionId isEqualToString:@"<null>"]) parameters[@"conditions.sectionId"] = selection_sectionId;
    if (![selection_category isEqualToString:@"<null>"]) parameters[@"conditions.category"] = selection_category;
    if (![selection_title isEqualToString:@"<null>"]) parameters[@"conditions.title"] = selection_title;
    if (![selection_recommend isEqualToString:@"<null>"]) parameters[@"conditions.recommend"] = selection_recommend;
    if (![selection_keyword isEqualToString:@"<null>"]) parameters[@"conditions.words"] = selection_keyword;
    NSLog(@"initial %@", parameters);
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:yijiarenUrl(@"patient", @"searchDoctors") parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
             NSString * errorMessage;
             NSString *result = [HTTPResponse objectForKey:@"result"];
             result = [NSString stringWithFormat:@"%@", result];
             //NSLog(@"Total amount : %@", HTTPResponse[@"info"]);
             if ([result isEqualToString:@"1"]) {
                 //NSLog(@"%@", HTTPResponse[@"response"]);
                 doctorList = [[NSMutableArray alloc] init];
                 for (int i = 0; i < [HTTPResponse[@"response"] count]; i++) {
                     WeDoctor * doctor = [[WeDoctor alloc] initWithNSDictionary:HTTPResponse[@"response"][i]];
                     [doctorList addObject:doctor];
                 }
                 if ([HTTPResponse[@"info"] integerValue] == [doctorList count]) hasMore = NO;
                 //NSLog(@"%d", [HTTPResponse[@"info"] integerValue]);
                 [sys_pendingView stopAnimating];
                 [sys_tableView reloadData];
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
             NSLog(@"Response error: %@", errorMessage);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }
     ];
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
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}
@end
