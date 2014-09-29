//
//  WeSelDegViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-5-3.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeSelDegViewController.h"
#import "WeAppDelegate.h"

@interface WeSelDegViewController () {
    UITableView * sys_tableView;
    NSArray * degreeKeyArray;
    NSInteger degreeSelected;
    NSMutableString *myLaunges;
}

@end

@implementation WeSelDegViewController

/*
 [AREA]
 UITableView dataSource & delegate interfaces
 */
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
//    [self save:indexPath.row];
    NSString * la = degreeKeyArray[indexPath.row];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    BOOL flag=YES;
//    if ([la isEqualToString:@"A"]) {
//        
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        UIAlertView *alt= [[UIAlertView alloc]initWithTitle:@"提示" message:@"汉语为基本语言，不可取消" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//        [alt show];
//        return;
//    }
    for (int i=0; i<myLaunges.length; i++) {
        NSRange a={i,1};
        if ([la isEqualToString:[myLaunges substringWithRange:a]]) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [myLaunges deleteCharactersInRange:a];
            flag=NO;
            break;
        }
        flag=YES;
    }
    if (flag) {
        [myLaunges insertString:la atIndex:0];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tv.rowHeight;
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
    if (section == [self numberOfSectionsInTableView:tv] - 1) return 300;
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
    return 1;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [degreeKeyArray count];
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
    NSString * la = degreeKeyArray[indexPath.row];
    switch (indexPath.section) {
        case 0:
            cell.backgroundColor = We_background_cell_general;
            cell.textLabel.font = We_font_textfield_zh_cn;
            cell.textLabel.textColor = We_foreground_black_general;
            cell.textLabel.text = we_codings[@"doctorLanguages"][degreeKeyArray[indexPath.row]];
            for (int i=0; i<myLaunges.length; i++) {
                NSRange a={i,1};
                if ([la isEqualToString:[myLaunges substringWithRange:a]]) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
            }
            break;
        default:
            break;
    }
    return cell;
}

- (void)saveButton:(UIBarButtonItem *)button
{
    BOOL flag=YES;
    for (int i=0; i<myLaunges.length; i++) {
        NSRange a={i,1};
        if ([@"A" isEqualToString:[myLaunges substringWithRange:a]]) {
            flag=NO;
            break;
        }
    }
    if (flag) {
        UIAlertView *alt= [[UIAlertView alloc]initWithTitle:@"提示" message:@"汉语为基本语言，不可取消" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alt show];
        return;
    }
   
    
    NSString * urlString = yijiarenUrl(@"doctor", @"updateInfo");
    NSString * paraString = [NSString stringWithFormat:@"languages=%@", myLaunges];
    NSData * DataResponse = [WeAppDelegate postToServer:urlString withParas:paraString];
    
    NSString * errorMessage = @"连接服务器失败";
    if (DataResponse != NULL) {
        NSDictionary *HTTPResponse = [NSJSONSerialization JSONObjectWithData:DataResponse options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@", HTTPResponse);
        NSString *result = [HTTPResponse objectForKey:@"result"];
        result = [NSString stringWithFormat:@"%@", result];
        if ([result isEqualToString:@"1"]) {
            currentUser.languages=myLaunges;
            [self.navigationController popViewControllerAnimated:YES];
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
    }
    UIAlertView *notPermitted = [[UIAlertView alloc]
                                 initWithTitle:@"更新语言信息失败"
                                 message:errorMessage
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [notPermitted show];
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
    
    // sys_tableView
    sys_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-49) style:UITableViewStyleGrouped];
    sys_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sys_tableView.delegate = self;
    sys_tableView.dataSource = self;
    sys_tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sys_tableView];
    
    degreeKeyArray = [we_codings[@"doctorLanguages"] allKeys];//获取所有语言的  编码id
    
    myLaunges=[NSMutableString stringWithString:currentUser.languages];//获取当前的语言编码id串
    

    UIBarButtonItem *save=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton:)];
    self.navigationItem.rightBarButtonItem=save;
    
}

@end
