//
//  WePecDclViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-19.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePecExpViewController.h"
#include "WeAppDelegate.h"
#include "WePecExpModViewController.h"

@interface WePecExpViewController () {
    UITableView *sys_tableView;
    UIBarButtonItem * user_edit;
}

@end

@implementation WePecExpViewController

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
    if (path.section == 0) {
        we_expToModify_id = path.row;
        [self performSegueWithIdentifier:@"PecExpMod" sender:self];
        return nil;
    }
    if (path.section == 1 && path.row == 0) {
        [self performSegueWithIdentifier:@"PecExpAdd" sender:self];
        return nil;
    }
    return nil;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)path
{
    
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 90;//tv.rowHeight * 2;
    else return tv.rowHeight;
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 20 + 64;
    return 20;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tv heightForFooterInSection:(NSInteger)section {
    //if (section == 1) return 30;
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 200;
    return 10;
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
    return 2;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [user_exps count];
            break;
        case 1:
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
    UILabel * l1;
    UILabel * l2;
    switch (indexPath.section) {
        case 0:
            cell.contentView.backgroundColor = We_background_cell_general;
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            l1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 240, 25)];
            l1.text = [NSString stringWithFormat:@"%@ %@ %@", [[user_exps objectAtIndex:indexPath.row] objectForKey:@"hospital"], [[user_exps objectAtIndex:indexPath.row] objectForKey:@"section"], we_codings[@"doctorCategory"][currentUser.category][@"title"][user_exps[indexPath.row][@"title"]]];
            l1.font = We_font_textfield_zh_cn;
            l1.textColor = We_foreground_black_general;
            [cell.contentView addSubview:l1];
            l2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 240, 25)];
            if([ [NSString stringWithFormat:@"%@",[[user_exps objectAtIndex:indexPath.row] objectForKey:@"endYear"]]  isEqualToString:@"9999"])
            {
                l2.text = [NSString stringWithFormat:@"%@年%@月 - 至今", [[user_exps objectAtIndex:indexPath.row] objectForKey:@"fromYear"], [[user_exps objectAtIndex:indexPath.row] objectForKey:@"fromMonth"]];
            }
            else
            {
                l2.text = [NSString stringWithFormat:@"%@年%@月 - %@年%@月", [[user_exps objectAtIndex:indexPath.row] objectForKey:@"fromYear"], [[user_exps objectAtIndex:indexPath.row] objectForKey:@"fromMonth"], [[user_exps objectAtIndex:indexPath.row] objectForKey:@"endYear"], [[user_exps objectAtIndex:indexPath.row] objectForKey:@"endMonth"]];
            }
            
            l2.font = We_font_textfield_zh_cn;
            l2.textColor = We_foreground_gray_general;
            [cell.contentView addSubview:l2];
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.contentView.backgroundColor = We_background_cell_general;
                    cell.textLabel.text = @"添加从医经历";
                    cell.textLabel.font = We_font_textfield_zh_cn;
                    cell.textLabel.textColor = We_foreground_red_general;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return cell;
}
// 编辑时进行的动作
-(void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section != 0) return;
        if (![self user_delete:indexPath.row]) return;
        [user_exps removeObjectAtIndex:indexPath.row];
        [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
// 返回是否可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return NO;
    }
    if([ [NSString stringWithFormat:@"%@",[[user_exps objectAtIndex:indexPath.row] objectForKey:@"endYear"]]  isEqualToString:@"9999"])
    {
        return NO;
    }
    return YES;
}

// Functions
- (void) get_experience {
    NSString *errorMessage = @"连接失败，请检查网络";
    NSString *urlString =yijiarenUrl(@"doctor", @"listExperiencesOfDoctor");
    NSString *parasString = @"";
    NSData * DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:parasString];
    
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
        NSString *result = [HTTPResponse objectForKey:@"result"];
        result = [NSString stringWithFormat:@"%@", result];
        if ([result isEqualToString:@"1"]) {
            user_exps = [[NSMutableArray alloc] initWithArray:[HTTPResponse objectForKey:@"response"]];
//            NSLog(@"%@ %@", user_exps, [NSString stringWithUTF8String:object_getClassName(user_exps)]);
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
                                 initWithTitle:@"获取数据失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
}

- (BOOL) user_delete:(NSInteger)row {
    NSString *errorMessage = @"连接失败，请检查网络";
    NSString *urlString =yijiarenUrl(@"doctor", @"removeExperience");
    NSString *parasString = [NSString stringWithFormat:@"deId=%@", [[user_exps objectAtIndex:row] objectForKey:@"id"]];
    NSData * DataResponse = [WeAppDelegate sendPhoneNumberToServer:urlString paras:parasString];
    
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
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
                                 initWithTitle:@"获取数据失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
    return YES;
}
/*
 [AREA]
 Response functions
 */
- (void) user_edit_onpress:(id)sender {
    if ([user_edit.title isEqualToString:@"删除"]) {
        [sys_tableView setEditing:YES animated:YES];
        user_edit.title = @"结束";
    }
    else {
        [sys_tableView setEditing:NO animated:YES];
        user_edit.title = @"删除";
    }
}

//
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
    
    // edit button
    user_edit = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(user_edit_onpress:)];
    self.navigationItem.rightBarButtonItem = user_edit;
    
    // get experience info
    [self get_experience];
    
    // Background
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-49) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [sys_tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (sys_pathSelected.section == 0) {
        //[segue destinationViewController].user_ExpModified_id = sys_pathSelected.row;
        //[[segue destinationViewController] setId:sys_pathSelected.row];
    }
}*/


@end
