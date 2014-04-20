//
//  WePecBusViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-19.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePecBusViewController.h"
#import "WeAppDelegate.h"

@interface WePecBusViewController () {
    UITableView * sys_tableView;
}

@end

@implementation WePecBusViewController
/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    //if (path.section == 0 && path.row == 0) [user_notification_input becomeFirstResponder];
    return nil;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 40;
    return 20;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"出诊时间";
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    //if (section == 1) return 30;
    if (section == 1) return 30;
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 300;
    return 10;
}
// 询问每个段落的尾部标题
- (NSString *)tableView:(UITableView *)tv titleForFooterInSection:(NSInteger)section {
    if (section == 2) return @"患者发出咨询请求后，若您未能在该时限内回复则取消咨询，并将咨询费返还至患者账户";
    return @"";
}
// 询问每个段落的尾部
//-(UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section{
    //if (section == 1) return sys_countDown_demo;
   // return nil;
//}
// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 4;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
        default:
            return 0;
    }
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"周三 下午";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    break;
                case 1:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"周五 上午";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                default:
                    break;
            }
            break;
        case 1:
            cell.contentView.backgroundColor = We_background_cell_general;
            cell.textLabel.text = @"添加出诊时间";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"咨询价格";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    break;
                case 1:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"加号预诊费";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_black_general;
                    break;
                default:
                    break;
            }
            break;
        case 3:
            cell.contentView.backgroundColor = We_background_cell_general;
            cell.textLabel.text = @"咨询回复时限";
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            break;
        default:
            break;
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
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 550) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = We_background_general;
    [self.view addSubview:sys_tableView];
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
