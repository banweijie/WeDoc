//
//  WeCsrJiaChooseTimeViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-7-15.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrJiaChooseTimeViewController.h"

@interface WeCsrJiaChooseTimeViewController () {
    UITableView * sys_tableView;
    
    NSMutableArray * yearList;
    NSMutableArray * monthList;
    NSMutableArray * dayList;
    NSMutableArray * weekdayList;
    NSMutableArray * periodList;
    NSMutableArray * typeList;
    NSMutableArray * selectList;
    
    int selectCount;
}

@end

@implementation WeCsrJiaChooseTimeViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    for (int i = 0; i < [selectList count]; i++) selectList[i] = @"NO";
    selectList[path.row] = @"YES";
    [self okButton_onPress];
    [tv deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tv rowHeight];
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 1 + 64;
    return 1;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) {
        return 1 + self.tabBarController.tabBar.frame.size.height;
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
    return 1;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return [yearList count];
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
    [cell.textLabel setFont:We_font_textfield_zh_cn];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@年%@月%@日 %@%@ - %@", yearList[indexPath.row], monthList[indexPath.row], dayList[indexPath.row], [WeAppDelegate transitionDayOfWeekFromChar:weekdayList[indexPath.row]], [WeAppDelegate transitionPeriodOfDayFromChar:periodList[indexPath.row]], [WeAppDelegate transitionTypeOfPeriodFromChar:typeList[indexPath.row]]]];
    
    if ([selectList[indexPath.row] isEqualToString:@"YES"]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
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
    
    self.navigationItem.title = @"选择加号时间";
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    
    yearList = [[NSMutableArray alloc] init];
    monthList = [[NSMutableArray alloc] init];
    dayList = [[NSMutableArray alloc] init];
    weekdayList = [[NSMutableArray alloc] init];
    periodList = [[NSMutableArray alloc] init];
    typeList = [[NSMutableArray alloc] init];
    selectList = [[NSMutableArray alloc] init];
    selectCount = 0;
    NSLog(@"%@",currentUser.workPeriod);
    for (int i = 1; i < 30; i++) {
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:([[NSDate date] timeIntervalSince1970] + 86400 * i)];
        NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents * the = [calendar components:unitFlags fromDate:date];
        
        long long k;
        NSLog(@"%@",[NSString stringWithFormat:@"%dB", (int)([the weekday] + 5) % 7 + 1]);
        if ((k = [currentUser.workPeriod rangeOfString:[NSString stringWithFormat:@"%dA", (int)([the weekday] + 5) % 7 + 1]].location) != NSNotFound) {
            [yearList addObject:[NSString stringWithFormat:@"%d", (int)[the year]]];
            [monthList addObject:[NSString stringWithFormat:@"%02d", (int)[the month]]];
            [dayList addObject:[NSString stringWithFormat:@"%02d", (int)[the day]]];
            [weekdayList addObject:[NSString stringWithFormat:@"%d", (int)([the weekday] + 5) % 7 + 1]];
            [periodList addObject:[NSString stringWithFormat:@"%@", @"A"]];
            [typeList addObject:[NSString stringWithFormat:@"%@", [currentUser.workPeriod substringWithRange:NSMakeRange(k + 2, 1)]]];
            if ([self.dates rangeOfString:[NSString stringWithFormat:@"%04d-%02d-%02dA", (int)[the year], (int)[the month], (int)[the day]]].location != NSNotFound) {
                [selectList addObject:@"YES"];
                selectCount ++;
            }
            else {
                [selectList addObject:@"NO"];
            }
        }
        if ((k = [currentUser.workPeriod rangeOfString:[NSString stringWithFormat:@"%dB", (int)([the weekday] + 5) % 7 + 1]].location) != NSNotFound) {
            [yearList addObject:[NSString stringWithFormat:@"%d", (int)[the year]]];
            [monthList addObject:[NSString stringWithFormat:@"%02d", (int)[the month]]];
            [dayList addObject:[NSString stringWithFormat:@"%02d", (int)[the day]]];
            [weekdayList addObject:[NSString stringWithFormat:@"%d", (int)([the weekday] + 5) % 7 + 1]];
            [periodList addObject:[NSString stringWithFormat:@"%@", @"B"]];
            [typeList addObject:[NSString stringWithFormat:@"%@", [currentUser.workPeriod substringWithRange:NSMakeRange(k + 2, 1)]]];
            if ([self.dates rangeOfString:[NSString stringWithFormat:@"%d-%d-%dB", (int)[the year], (int)[the month], (int)[the day]]].location != NSNotFound) {
                [selectList addObject:@"YES"];
                selectCount ++;
            }
            else {
                [selectList addObject:@"NO"];
            }
        }
    }
    for (int i=yearList.count-1; i>=0; i--) {
        
        NSString *data=[NSString stringWithFormat:@"%@-%@-%@%@",yearList[i],monthList[i],dayList[i],periodList[i]];
        if (([self.paintTime rangeOfString:data].location) == NSNotFound) {
            [yearList removeObjectAtIndex:i];
            [monthList removeObjectAtIndex:i];
            [dayList removeObjectAtIndex:i];
            [weekdayList removeObjectAtIndex:i];
            [periodList removeObjectAtIndex:i];
            [typeList removeObjectAtIndex:i];
        }
    }
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
    
    // 确认按钮
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(okButton_onPress)];
}

- (void)okButton_onPress {
    [self.dates setString:@""];
    [self.datesToDemo setString:@""];
    
    for (int i = 0; i < [selectList count]; i++) if ([selectList[i] isEqualToString:@"YES"]) {
        [self.dates setString:[NSString stringWithFormat:@"%@%@-%@-%@%@", self.dates, yearList[i], monthList[i], dayList[i], periodList[i]]];
        [self.datesToDemo setString:[NSString stringWithFormat:@"%@%@年%@月%@日 %@%@ - %@\n", self.datesToDemo, yearList[i], monthList[i], dayList[i], [WeAppDelegate transitionDayOfWeekFromChar:weekdayList[i]], [WeAppDelegate transitionPeriodOfDayFromChar:periodList[i]], [WeAppDelegate transitionTypeOfPeriodFromChar:typeList[i]]]];
    }
    
    NSLog(@"%@   %@",self.dates,self.datesToDemo);
    [self.navigationController popViewControllerAnimated:YES];
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
