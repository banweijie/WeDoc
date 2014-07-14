//
//  WeCsrDciViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-12.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrDciViewController.h"
#import "WeAppDelegate.h"

@interface WeCsrDciViewController () {
    UITableView * sys_tableView_0;
    UITableView * sys_tableView_1;
    UITableView * sys_tableView_2;
    UIScrollView * tableViews;
    UIView * controlPanel;
    UIButton * panel0;
    UIButton * panel1;
    UIButton * panel2;
    UIButton * button0;
    UIButton * button1;
    UIButton * button2;
    UIButton * selectSign;
    NSInteger selectPanel;
    
    NSString * notice;
    NSString * groupIntro;
    BOOL scrolling;
}

@end

@implementation WeCsrDciViewController

/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
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
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == sys_tableView_0) {
        if (indexPath.section == 0) {
            if (indexPath.row == 3) {
                CGSize sizezz = [groupIntro sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                return sizezz.height + 60;
            }
        }
    }
    if (tableView == sys_tableView_1) {
        if (indexPath.section == 0) {
            CGSize sizezz = [notice sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
            return sizezz.height + 40;
        }return [sys_tableView_1 rowHeight];
        if (indexPath.section == 1) return [sys_tableView_1 rowHeight];
    }
    return [sys_tableView_1 rowHeight];
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == sys_tableView_1) {
        if (section == 0) return @"公告";
        if (section == 1) return @"出诊时间";
    }
    return @"";
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == sys_tableView_0) return 20;
    if (tableView == sys_tableView_1) return 40;
    return 1;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    return 1;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == sys_tableView_0) {
        return 1;
    }
    if (tableView == sys_tableView_1) {
        return 2;
    }
    if (tableView == sys_tableView_2) {
        return 0;
    }
    return 10;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == sys_tableView_0) {
        if (section == 0) return 4;
    }
    if (tableView == sys_tableView_1) {
        if (section == 0) return 1;
        if (section == 1) {
            if ([doctorViewing.workPeriod isEqualToString:@"<null>"]) return 0;
            else return [doctorViewing.workPeriod length] / 4;
        }
    }
    return 2;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    UILabel *label, * l1;
    CGSize sizezz;
    if (tableView == sys_tableView_0) {
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        cell.contentView.backgroundColor = We_background_cell_general;
                        cell.textLabel.text = @"医院";
                        cell.textLabel.font = We_font_textfield_zh_cn;
                        cell.textLabel.textColor = We_foreground_black_general;
                        cell.detailTextLabel.text = doctorViewing.hospitalName;
                        cell.detailTextLabel.font = We_font_textfield_zh_cn;
                        cell.detailTextLabel.textColor = We_foreground_gray_general;
                        break;
                    case 1:
                        cell.contentView.backgroundColor = We_background_cell_general;
                        cell.textLabel.text = @"科室";
                        cell.textLabel.font = We_font_textfield_zh_cn;
                        cell.textLabel.textColor = We_foreground_black_general;
                        cell.detailTextLabel.text = doctorViewing.sectionName;
                        cell.detailTextLabel.font = We_font_textfield_zh_cn;
                        cell.detailTextLabel.textColor = We_foreground_gray_general;
                        break;
                    case 2:
                        cell.contentView.backgroundColor = We_background_cell_general;
                        cell.textLabel.text = @"职称";
                        cell.textLabel.font = We_font_textfield_zh_cn;
                        cell.textLabel.textColor = We_foreground_black_general;
                        cell.detailTextLabel.text = we_codings[@"doctorCategory"][doctorViewing.category][@"title"][doctorViewing.title];
                        cell.detailTextLabel.font = We_font_textfield_zh_cn;
                        cell.detailTextLabel.textColor = We_foreground_gray_general;
                        break;
                    case 3:
                        l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 280, 40)];
                        l1.text = @"团队介绍";
                        l1.font = We_font_textfield_zh_cn;
                        l1.textColor = We_foreground_black_general;
                        [cell.contentView addSubview:l1];
                        sizezz = [groupIntro sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                        label = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, sizezz.width, sizezz.height)];
                        label.numberOfLines = 0;
                        label.lineBreakMode = NSLineBreakByWordWrapping;
                        label.text = groupIntro;
                        label.font = We_font_textfield_zh_cn;
                        label.textColor = We_foreground_gray_general;
                        [cell.contentView addSubview:label];
                    default:
                        break;
                }
                break;
                
            default:
                break;
        }
    }
    if (tableView == sys_tableView_1) {
        switch (indexPath.section) {
            case 0:
                sizezz = [notice sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
                label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, sizezz.width, sizezz.height)];
                label.numberOfLines = 0;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.text = notice;
                label.font = We_font_textfield_zh_cn;
                label.textColor = We_foreground_black_general;
                [cell.contentView addSubview:label];
                break;
            case 1:
                cell.contentView.backgroundColor = We_background_cell_general;
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [WeAppDelegate transitionDayOfWeekFromChar:[doctorViewing.workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 1, 1)]], [WeAppDelegate transitionPeriodOfDayFromChar:[doctorViewing.workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 2, 1)]]];
                cell.textLabel.font = We_font_textfield_zh_cn;
                cell.textLabel.textColor = We_foreground_black_general;
                cell.detailTextLabel.text = [WeAppDelegate transitionTypeOfPeriodFromChar:[doctorViewing.workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 3, 1)]];
                cell.detailTextLabel.font = We_font_textfield_zh_cn;
                cell.detailTextLabel.textColor = We_foreground_gray_general;
            default:
                break;
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

- (void)transferTo:(NSInteger)targetPanel {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    [UIView commitAnimations];
    
    [tableViews scrollRectToVisible:CGRectMake(320 * targetPanel, 0, 320, tableViews.frame.size.height) animated:YES];
}

- (void)transferTo0:(id)sender {
    [self transferTo:0];
}

- (void)transferTo1:(id)sender {
    [self transferTo:1];
}

- (void)transferTo2:(id)sender {
    [self transferTo:2];
}

- (void)press:(id)sender {
}

- (void)appointing:(id)sender {
    [self performSegueWithIdentifier:@"CsrDci_pushto_CsrJia" sender:self];
}

- (void)consulting:(id)sender {
    WeCsrCosViewController * vc = [[WeCsrCosViewController alloc] init];
    vc.pushType = @"consultingRoom";
    vc.favorDoctor = doctorViewing;
    //doctorViewing = favorDoctors[we_doctorChating];
    
    WeNavViewController * nav = [[WeNavViewController alloc] init];
    [nav pushViewController:vc animated:NO];
    
    [self presentViewController:nav animated:YES completion:nil];
    return;
    
    
    NSString *urlString = yijiarenUrl(@"patient", @"addConsult");
    NSString *parasString = [NSString stringWithFormat:@"consult.doctor.id=%@&consult.order.id=3&consult.gender=M&consult.age=20", doctorViewing.userId];
    NSData * DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:parasString];
    
    NSString *errorMessage = @"连接失败，请检查网络";
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@", HTTPResponse);
        NSString *result = [HTTPResponse objectForKey:@"result"];
        result = [NSString stringWithFormat:@"%@", result];
        if ([result isEqualToString:@"1"]) {
            return;
        }
        if ([result isEqualToString:@"2"]) {
            NSDictionary *fields = [HTTPResponse objectForKey:@"fields"];
            NSEnumerator *enumerator = [fields keyEnumerator];
            id key;
            while ((key = [enumerator nextObject])) {
                NSString * tmp = [fields objectForKey:key];
                if (tmp != NULL) errorMessage = tmp;
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
                                 initWithTitle:@"登陆失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"11111");
    CGRect rect = selectSign.frame;
    rect.origin.x = 15 + 100 * scrollView.contentOffset.x / 320;
    selectSign.frame = rect;
    
    NSInteger targetPanel = (scrollView.contentOffset.x + 160) / 320;
    
    switch (selectPanel) {
        case 0:
            panel0.tintColor = We_foreground_black_general;
            break;
        case 1:
            panel1.tintColor = We_foreground_black_general;
            break;
        case 2:
            panel2.tintColor = We_foreground_black_general;
        default:
            break;
    }
    
    switch (targetPanel) {
        case 0:
            panel0.tintColor = We_foreground_red_general;
            break;
        case 1:
            panel1.tintColor = We_foreground_red_general;
            break;
        case 2:
            panel2.tintColor = We_foreground_red_general;
        default:
            break;
    }
    selectPanel = targetPanel;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    scrolling = NO;
    NSLog(@"!!!!!!!!!!");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", doctorViewing.userName, we_codings[@"doctorCategory"][doctorViewing.category][@"title"][doctorViewing.title]];
    
    notice = doctorViewing.notice;
    if ([notice isEqualToString:@"<null>"]) notice = @"该医生未设置公告";
    
    groupIntro = doctorViewing.groupIntro;
    if ([groupIntro isEqualToString:@"<null>"]) groupIntro = @"该医生未设置团队介绍";
    
    UIBarButtonItem * user_save = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"me-appointment"] style:UIBarButtonItemStylePlain target:self action:@selector(press:)];
    self.navigationItem.rightBarButtonItem = user_save;
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // sys_tableView - 0
    sys_tableView_0 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 578 - 154) style:UITableViewStyleGrouped];
    sys_tableView_0.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView_0.delegate = self;
    sys_tableView_0.dataSource = self;
    sys_tableView_0.backgroundColor = [UIColor clearColor];
    sys_tableView_0.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // sys_tableView - 1
    sys_tableView_1 = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 320, 578 - 154) style:UITableViewStyleGrouped];
    sys_tableView_1.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView_1.delegate = self;
    sys_tableView_1.dataSource = self;
    sys_tableView_1.backgroundColor = [UIColor clearColor];
    sys_tableView_1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // sys_tableView - 2
    sys_tableView_2 = [[UITableView alloc] initWithFrame:CGRectMake(640, 0, 320, 578 - 154) style:UITableViewStyleGrouped];
    sys_tableView_2.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView_2.delegate = self;
    sys_tableView_2.dataSource = self;
    sys_tableView_2.backgroundColor = [UIColor clearColor];
    sys_tableView_2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // tableViews
    tableViews = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 154, 320, 578 - 154)];
    tableViews.contentSize = CGSizeMake(960, 568 - 154);
    [tableViews addSubview:sys_tableView_0];
    [tableViews addSubview:sys_tableView_1];
    [tableViews addSubview:sys_tableView_2];
    tableViews.pagingEnabled = YES;
    tableViews.delegate = self;
    
    // controlPanel
    selectPanel = 0;
    controlPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 156 - 64)];
    
    button0 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button0 setFrame:CGRectMake(0, 2, 89, 48)];
    [button0 setTitle:@"发起咨询" forState:UIControlStateNormal];
    [button0 addTarget:self action:@selector(consulting:) forControlEvents:UIControlEventTouchUpInside];
    button0.tintColor = We_foreground_white_general;
    button0.backgroundColor = [UIColor colorWithRed:90 / 255.0 green:41 / 255.0 blue:45 / 255.0 alpha:1.0];
    button0.titleLabel.font = We_font_textfield_zh_cn;
    [controlPanel addSubview:button0];
    
    button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setFrame:CGRectMake(91, 2, 138, 48)];
    //NSLog(@"%@ %@", we_doctors, we_doctorViewing[@"id"]);
    if (favorDoctorList[doctorViewing.userId] == NULL) {
        [button1 setTitle:@"添加为保健医" forState:UIControlStateNormal];
    }
    else {
        [button1 setTitle:@"已添加为保健医" forState:UIControlStateNormal];
    }
    [button1 addTarget:self action:@selector(transferTo0:) forControlEvents:UIControlEventTouchUpInside];
    button1.tintColor = We_foreground_white_general;
    button1.backgroundColor = We_background_red_general;
    button1.titleLabel.font = We_font_textfield_zh_cn;
    [controlPanel addSubview:button1];
    
    button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setFrame:CGRectMake(231, 2, 89, 48)];
    [button2 setTitle:@"申请加号" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(appointing:) forControlEvents:UIControlEventTouchUpInside];
    button2.tintColor = We_foreground_white_general;
    button2.backgroundColor = [UIColor colorWithRed:90 / 255.0 green:41 / 255.0 blue:45 / 255.0 alpha:1.0];
    button2.titleLabel.font = We_font_textfield_zh_cn;
    [controlPanel addSubview:button2];
    
    panel0 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [panel0 setFrame:CGRectMake(0, 50, 120, 42)];
    [panel0 setTitle:@"基本资料" forState:UIControlStateNormal];
    [panel0 addTarget:self action:@selector(transferTo0:) forControlEvents:UIControlEventTouchUpInside];
    panel0.tintColor = We_foreground_red_general;
    panel0.backgroundColor = We_background_general;
    panel0.titleLabel.font = We_font_textfield_zh_cn;
    [controlPanel addSubview:panel0];
    
    panel1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [panel1 setFrame:CGRectMake(120, 50, 80, 42)];
    [panel1 setTitle:@"业务公告" forState:UIControlStateNormal];
    [panel1 addTarget:self action:@selector(transferTo1:) forControlEvents:UIControlEventTouchUpInside];
    panel1.tintColor = We_foreground_black_general;
    panel1.backgroundColor = We_background_general;
    panel1.titleLabel.font = We_font_textfield_zh_cn;
    [controlPanel addSubview:panel1];
    
    panel2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [panel2 setFrame:CGRectMake(200, 50, 120, 42)];
    [panel2 setTitle:@"众筹项目" forState:UIControlStateNormal];
    [panel2 addTarget:self action:@selector(transferTo2:) forControlEvents:UIControlEventTouchUpInside];
    panel2.tintColor = We_foreground_black_general;
    panel2.backgroundColor = We_background_general;
    panel2.titleLabel.font = We_font_textfield_zh_cn;
    [controlPanel addSubview:panel2];
    
    selectSign = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [selectSign setFrame:CGRectMake(15, 92 - 5, 90, 5)];
    selectSign.backgroundColor = We_foreground_red_general;
    [controlPanel addSubview:selectSign];
    
    [self.view addSubview:tableViews];
    [self.view addSubview:controlPanel];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (selectPanel > 0) sys_tableView_0.hidden = YES;
    if (selectPanel > 1) sys_tableView_1.hidden = YES;
    [super viewWillDisappear:animated];
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
