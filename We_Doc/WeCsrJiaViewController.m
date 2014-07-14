//
//  WeCsrJiaViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-17.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCsrJiaViewController.h"

@interface WeCsrJiaViewController () {
    UIView * sys_explaination_view;
    UILabel * sys_explaination_label;
    UITableView * sys_tableView;
    
    // 日历
    UIScrollView * sys_calenderView;
    UIButton * lastMonth;
    UIButton * nextMonth;
    UILabel * calenderTitle;
    int currentYear;
    int currentMonth;
    NSMutableArray * calenderDayView;
    NSMutableArray * calenderDayDate;
    NSMutableArray * calenderDayPart1;
    NSMutableArray * calenderDayPart2;
    
    NSInteger centerYear;
    NSInteger centerMonth;
    NSMutableArray * calenderViews;
}
#define cacheWidth 5
@end

@implementation WeCsrJiaViewController

@synthesize favorDoctor;
/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = We_alpha_cell_general;
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
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) return sys_calenderView.frame.size.height;
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 40 + 64;
    return 40;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"医生业务设置";
    if (section == 1) return @"出诊时间";
    if (section == 2) return @"选择加号时间";
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    //if (section == 1) return 30;
    if (section == 0) return 60;
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 100;
    return 10;
}
-(UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section{
    if (section == 0) return sys_explaination_view;
    return nil;
}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 4;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    if (section == 1) return [self.favorDoctor.workPeriod length] / 4;
    if (section == 2) return 1;
    if (section == 3) return 1;
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.contentView.backgroundColor = We_background_cell_general;
        
        cell.textLabel.text = @"加号预诊费";
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元/次", favorDoctor.plusPrice];
        cell.detailTextLabel.font = We_font_textfield_zh_cn;
        cell.detailTextLabel.textColor = We_foreground_black_general;
    }
    if (indexPath.section == 1) {
        cell.contentView.backgroundColor = We_background_cell_general;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [WeAppDelegate transitionDayOfWeekFromChar:[favorDoctor.workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 1, 1)]], [WeAppDelegate transitionPeriodOfDayFromChar:[favorDoctor.workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 2, 1)]]];
        cell.textLabel.font = We_font_textfield_zh_cn;
        cell.textLabel.textColor = We_foreground_black_general;
        cell.detailTextLabel.text = [WeAppDelegate transitionTypeOfPeriodFromChar:[favorDoctor.workPeriod substringWithRange:NSMakeRange(4 * indexPath.row + 3, 1)]];
        cell.detailTextLabel.font = We_font_textfield_zh_cn;
        cell.detailTextLabel.textColor = We_foreground_gray_general;
    }
    if (indexPath.section == 2) {
        [cell.contentView addSubview:sys_calenderView];
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

- (void)press:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)newCalenderAtBias:(NSInteger)Bias withFrame:(CGRect)frame {
    int month = centerMonth;
    int year = centerYear;
    month = month + Bias;
    while (month < 0) {
        month += 12; year --;
    }
    while (month > 12) {
        month -= 12; year ++;
    }
    UIView * newCalenderView = [[UIView alloc] initWithFrame:frame];
    UILabel * monthRepresent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    monthRepresent.text = [NSString stringWithFormat:@"%d年%d月", year, month];
    [newCalenderView addSubview:monthRepresent];
    return newCalenderView;
}

- (void)resetCenter {
    int Bias = cacheWidth / 2 - sys_calenderView.contentOffset.x / sys_calenderView.frame.size.width;
    NSMutableArray * newCalenderViews;
    for (int i = 0; i < cacheWidth; i++) {
        int j = (i + Bias + cacheWidth) % cacheWidth;
        if (i + Bias < 0) {
            calenderViews[i] = [self newCalenderAtBias:i + cacheWidth - cacheWidth / 2 withFrame:((UIView *)calenderViews[i]).frame];
        }
        else if (i + Bias >= cacheWidth) {
            calenderViews[i] = [self newCalenderAtBias:i - cacheWidth / 2 - cacheWidth withFrame:((UIView *)calenderViews[i]).frame];
        }
        UIView * tmp = calenderViews[i];
        CGRect tmpRect = tmp.frame;
        tmpRect.origin.x += (j - i) * sys_calenderView.frame.size.width;
        tmp.frame = tmpRect;
        newCalenderViews[j] = tmp;
    }
    calenderViews = newCalenderViews;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"!!!!!!!!!!");
    [self resetCenter];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"申请加号";
    
    UIBarButtonItem * user_save = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(press:)];
    self.navigationItem.leftBarButtonItem = user_save;
    
    // sys_explaination
    sys_explaination_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    sys_explaination_label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 240, 30)];
    sys_explaination_label.lineBreakMode = NSLineBreakByWordWrapping;
    sys_explaination_label.numberOfLines = 0;
    sys_explaination_label.text = @"该费用为医生在加号时对病情的预诊费一旦申请加号成功则不可退回";
    sys_explaination_label.font = We_font_textfield_zh_cn;
    sys_explaination_label.textColor = We_foreground_gray_general;
    sys_explaination_label.textAlignment = NSTextAlignmentCenter;
    [sys_explaination_view addSubview:sys_explaination_label];
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
    
    
    // Calender
    NSDate * date = [NSDate date];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents * now = [calendar components:unitFlags fromDate:date];
    
    centerYear = [now year];
    centerMonth = [now month];
    
    sys_calenderView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 8 * 45 + 10)];
    sys_calenderView.contentSize = CGSizeMake(320 * 5, 150);
    [sys_calenderView scrollRectToVisible:CGRectMake(0, 0, 320, 150) animated:NO];
    for (int i = 0; i < cacheWidth; i++) calenderViews[i] = [self newCalenderAtBias:i - cacheWidth / 2 withFrame:CGRectMake(0, 320 * i, 320, 150)];
    for (int i = 0; i < cacheWidth; i++) [sys_calenderView addSubview:calenderViews[i]];
    sys_calenderView.pagingEnabled = YES;
    
    // 上个月
    lastMonth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    lastMonth.frame = CGRectMake(0, 0, 45, 45);
    [lastMonth setImage:[UIImage imageNamed:@"prev"] forState:UIControlStateNormal];
    lastMonth.tintColor = We_foreground_gray_general;
    [lastMonth addTarget:self action:@selector(lastMonth_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [sys_calenderView addSubview:lastMonth];
    
    // 下个月
    nextMonth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextMonth.frame = CGRectMake(275, 0, 45, 45);
    [nextMonth setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    nextMonth.tintColor = We_foreground_gray_general;
    [nextMonth addTarget:self action:@selector(nextMonth_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [sys_calenderView addSubview:nextMonth];
    
    // 标题
    calenderTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    [calenderTitle setText:[NSString stringWithFormat:@"%d年%d月", currentYear, currentMonth]];
    [calenderTitle setFont:We_font_textfield_zh_cn];
    [calenderTitle setTextAlignment:NSTextAlignmentCenter];
    [sys_calenderView addSubview:calenderTitle];
    
    // 周一~周日
    for (int i = 0; i < 7; i++) {
        UILabel * tmp = [[UILabel alloc] initWithFrame:CGRectMake(3 + 45 * i, 45, 44, 44)];
        [tmp setTextAlignment:NSTextAlignmentCenter];
        if (i == 0) tmp.text = @"一";
        if (i == 1) tmp.text = @"二";
        if (i == 2) tmp.text = @"三";
        if (i == 3) tmp.text = @"四";
        if (i == 4) tmp.text = @"五";
        if (i == 5) tmp.text = @"六";
        if (i == 6) tmp.text = @"日";
        [tmp setFont:[UIFont fontWithName:@"Heiti SC" size:13]];
        [tmp setTextColor:We_foreground_red_general];
        [sys_calenderView addSubview:tmp];
    }
    
    calenderDayView = [[NSMutableArray alloc] init];
    calenderDayDate = [[NSMutableArray alloc] init];
    calenderDayPart1 = [[NSMutableArray alloc] init];
    calenderDayPart2 = [[NSMutableArray alloc] init];
    for (int i = 0; i < 6; i++) {
        [calenderDayView addObject:[[NSMutableArray alloc] init]];
        [calenderDayDate addObject:[[NSMutableArray alloc] init]];
        [calenderDayPart1 addObject:[[NSMutableArray alloc] init]];
        [calenderDayPart2 addObject:[[NSMutableArray alloc] init]];
        for (int j = 0; j < 7; j++) {
            UIView * tmpView = [[UIView alloc] initWithFrame:CGRectMake(3 + 45 * j, 45 * (i + 2), 44, 44)];
            [tmpView setBackgroundColor:[UIColor grayColor]];
            [calenderDayView[i] addObject:tmpView];
            
            UILabel * tmpDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
            [tmpDate setFont:[UIFont fontWithName:@"Heiti SC" size:13]];
            [tmpDate setText:@"31"];
            [tmpDate setTextAlignment:NSTextAlignmentCenter];
            [tmpDate setTextColor:We_foreground_white_general];
            [tmpView addSubview:tmpDate];
            [calenderDayDate[i] addObject:tmpDate];
            
            UILabel * tmpPart1 = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 22, 22)];
            [tmpPart1 setFont:[UIFont fontWithName:@"Heiti SC" size:13]];
            [tmpPart1 setText:@"专"];
            [tmpPart1 setTextAlignment:NSTextAlignmentCenter];
            [tmpPart1 setTextColor:We_foreground_white_general];
            [tmpView addSubview:tmpPart1];
            [calenderDayPart1[i] addObject:tmpPart1];
            
            UILabel * tmpPart2 = [[UILabel alloc] initWithFrame:CGRectMake(22, 22, 22, 22)];
            [tmpPart2 setFont:[UIFont fontWithName:@"Heiti SC" size:13]];
            [tmpPart2 setText:@"普"];
            [tmpPart2 setTextAlignment:NSTextAlignmentCenter];
            [tmpPart2 setTextColor:We_foreground_white_general];
            [tmpView addSubview:tmpPart2];
            [calenderDayPart2[i] addObject:tmpPart2];
            
            [sys_calenderView addSubview:tmpView];
        }
    }
    
    currentYear = 2014;
    currentMonth = 6;
    [self setCalender];
}

- (void)lastMonth_onPress:(id)sender {
    NSLog(@"!!!!");
    currentMonth --;
    if (currentMonth < 1) {
        currentYear --;
        currentMonth = 12;
    }
    [self setCalender];
    [sys_tableView reloadData];
}

- (void)nextMonth_onPress:(id)sender {
    NSLog(@"!!!!");
    currentMonth ++;
    if (currentMonth > 12) {
        currentYear ++;
        currentMonth = 1;
    }
    [self setCalender];
    [sys_tableView reloadData];
}

- (void)setCalender {
    calenderTitle.text = [NSString stringWithFormat:@"%d年%d月", currentYear, currentMonth];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    NSDate *formatterDate = [inputFormatter dateFromString:[NSString stringWithFormat:@"%04d-%02d-1 at 10:30", currentYear, currentMonth]];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents * the = [calendar components:unitFlags fromDate:formatterDate];
    
    for (int i = 0; i < 6; i++)
        for (int j = 0; j < 7; j++) {
            UIView * tmpView = calenderDayView[i][j];
            [tmpView setBackgroundColor:We_foreground_white_general];
        }
    
    int i = 0, j = (the.weekday + 5) % 7;
    for (int k = 0; k < [WeAppDelegate calcDaysByYear:currentYear andMonth:currentMonth]; k++) {
        UIView * tmpView = calenderDayView[i][j];
        [tmpView setBackgroundColor:We_foreground_gray_general];
        
        UILabel * tmpDate = calenderDayDate[i][j];
        tmpDate.text = [NSString stringWithFormat:@"%d", k + 1];
        
        UILabel * tmpPart1 = calenderDayPart1[i][j];
        UILabel * tmpPart2 = calenderDayPart2[i][j];
        for (int p = 0; p < [self.favorDoctor.workPeriod length] / 4; p++) {
            NSString * workWeekday = [self.favorDoctor.workPeriod substringWithRange:NSMakeRange(p * 4 + 1, 1)];
            if ([workWeekday intValue] != j + 1) continue;
            NSString * workDayPeriod = [self.favorDoctor.workPeriod substringWithRange:NSMakeRange(p * 4 + 2, 1)];
            NSString * workPeriodType = [self.favorDoctor.workPeriod substringWithRange:NSMakeRange(p * 4 + 3, 1)];
            
            if ([workDayPeriod isEqualToString:@"A"]) {
                if ([workPeriodType isEqualToString:@"T"]) {
                    tmpPart1.text = @"特";
                    tmpPart1.textColor = We_foreground_black_general;
                }
                if ([workPeriodType isEqualToString:@"P"]) {
                    tmpPart1.text = @"普";
                    tmpPart1.textColor = We_foreground_black_general;
                }
                if ([workPeriodType isEqualToString:@"Z"]) {
                    tmpPart1.text = @"专";
                    tmpPart1.textColor = We_foreground_black_general;
                }
            }
            if ([workDayPeriod isEqualToString:@"B"]) {
                if ([workPeriodType isEqualToString:@"T"]) {
                    tmpPart2.text = @"特";
                    tmpPart2.textColor = We_foreground_black_general;
                }
                if ([workPeriodType isEqualToString:@"P"]) {
                    tmpPart2.text = @"普";
                    tmpPart2.textColor = We_foreground_black_general;
                }
                if ([workPeriodType isEqualToString:@"Z"]) {
                    tmpPart2.text = @"专";
                    tmpPart2.textColor = We_foreground_black_general;
                }
            }
        }
        j ++; if (j == 7) { i ++; j = 0; }
    }

    /*
    NSString *newDateString = [outputFormatter stringFromDate:formatterDate];
    */
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
