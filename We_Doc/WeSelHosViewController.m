//
//  WeSelHosViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-5-2.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeSelHosViewController.h"
#import "WeAppDelegate.h"
#import <AFNetworking.h>

@interface WeSelHosViewController () {
    BOOL sys_prepared;
    UITableView * sys_tableView;
}

@end

@implementation WeSelHosViewController


/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
// 调整格子的透明度
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.alpha = We_alpha_cell_general;;
    cell.opaque = YES;
}
// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([self save:indexPath.row]) {
            we_hospital = [[we_hospitalList objectForKey:@"100"] objectAtIndex:indexPath.row];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 84;
    return 20;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 300;
    return 10;
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
    return 1;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%d",[[we_hospitalList objectForKey:@"100"] count]);
    return [[we_hospitalList objectForKey:@"100"] count];
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
            cell.backgroundColor = We_background_cell_general;
            if (indexPath.row == 0) cell.contentView.backgroundColor = We_background_cell_general;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            cell.textLabel.text = [[[we_hospitalList objectForKey:@"100"] objectAtIndex:indexPath.row] objectForKey:@"name"];
            if ([[[[we_hospitalList objectForKey:@"100"] objectAtIndex:indexPath.row] objectForKey:@"id"] isEqualToValue:[we_hospital objectForKey:@"id"]]) [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            break;
        default:
            break;
    }
    return cell;
}

- (BOOL)save:(NSInteger)selected {
    NSString * urlString = yijiarenUrl(@"doctor", @"updateInfo");
    NSString * paraString = [NSString stringWithFormat:@"hospitalId=%@", [[[we_hospitalList objectForKey:@"100"] objectAtIndex:selected] objectForKey:@"id"]];
    NSData * DataResponse = [WeAppDelegate postToServer:urlString withParas:paraString];
    
    NSString * errorMessage = @"连接服务器失败，暂时使用本地缓存数据";
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@", HTTPResponse);
        NSString *result = [HTTPResponse objectForKey:@"result"];
        result = [NSString stringWithFormat:@"%@", result];
        if ([result isEqualToString:@"1"]) {
            return YES;
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
    }
    UIAlertView *notPermitted = [[UIAlertView alloc]
                                 initWithTitle:@"更新用户数据失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
    return NO;
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
    
    sys_prepared = NO;
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 568) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    
    NSDictionary * parameters = @{@"areaId" : @"100"};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:yijiarenUrl(@"data", @"listHospitalsOfArea") parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id HTTPResponse) {
             [self.view addSubview:sys_tableView];
             NSLog(@"JSON: %@", HTTPResponse);
             NSString * errorMessage;
             
             NSString *result = [HTTPResponse objectForKey:@"result"];
             result = [NSString stringWithFormat:@"%@", result];
             if ([result isEqualToString:@"1"]) {
                 [we_hospitalList setObject:[HTTPResponse objectForKey:@"response"] forKey:@"100"];
                 NSLog(@"%@", [HTTPResponse objectForKey:@"response"]);
                 NSLog(@"%@", NSStringFromClass([[HTTPResponse objectForKey:@"response"] class]));
                 NSLog(@"%@", we_hospitalList);
                 NSLog(@"%@", [we_hospitalList objectForKey:@"100"]);
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
             UIAlertView *notPermitted = [[UIAlertView alloc]
                                          initWithTitle:@"获取医院列表失败"
                                          message:errorMessage
                                          delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
             [notPermitted show];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             UIAlertView *notPermitted = [[UIAlertView alloc]
                                          initWithTitle:@"获取医院列表失败"
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
