//
//  WeMyFundingSupportDetailViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-8-8.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeMyFundingSupportDetailViewController.h"

@interface WeMyFundingSupportDetailViewController () {
    UITableView * sys_tableView;
    
    NSMutableArray * infoList;
}

@end

@implementation WeMyFundingSupportDetailViewController

#pragma mark - UITableView Delegate & DataSource

// 欲选中某个Cell触发的事件
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)path
{
    return path;
}
// 选中某个Cell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path
{
    [tableView deselectRowAtIndexPath:path animated:YES];
}
// 询问每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return [[WeFundingCard alloc] initWithWeFunding:self.currentFunding].frame.size.height;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        return [WeAppDelegate calcSizeForString:self.currentLevel.repay Font:We_font_textfield_zh_cn expectWidth:280].height + 80;
    }
    if (indexPath.section == 2) {
        if ([infoList[indexPath.row] isEqualToString:@"address"]) {
            NSString * tmpString = self.currentFundingSupport.address;
            if ([self.currentFundingSupport.address isEqualToString:@""]) tmpString = @"尚未填写寄送地址";
            return [WeAppDelegate calcSizeForString:tmpString Font:We_font_textfield_zh_cn expectWidth:280].height + 60;
        }
        if ([infoList[indexPath.row] isEqualToString:@"description"]) {
            NSString * tmpString = self.currentFundingSupport.description;
            if ([self.currentFundingSupport.description isEqualToString:@""]) tmpString = @"尚未填写自我介绍";
            return [WeAppDelegate calcSizeForString:tmpString Font:We_font_textfield_zh_cn expectWidth:280].height + 60;
        }
    }
    return [tableView rowHeight];
}
// 询问每个段落的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 20 + 64;
    return 20;
}
// 询问每个段落的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
// 询问每个段落的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
// 询问每个段落的尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 20 + self.tabBarController.tabBar.frame.size.height;
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
    return 3;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    if (section == 1) return 2;
    if (section == 2) return [infoList count];
    return 1;
}
// 询问每个具体条目的内容
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    cell.opaque = NO;
    cell.backgroundColor = We_background_cell_general;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView addSubview:[[WeFundingCard alloc] initWithWeFunding:self.currentFunding]];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [cell.textLabel setText:@"交易号"];
        [cell.textLabel setFont:We_font_textfield_zh_cn];
        [cell.textLabel setTextColor:We_foreground_black_general];
        [cell.detailTextLabel setText:self.currentFundingSupport.orderId];
        [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
        [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 220 - 16, 60)];
        if ([self.currentLevel.type isEqualToString:@"E"]) {
            l1.text = self.currentLevel.way;
        }
        else {
            l1.text = [NSString stringWithFormat:@"支持 ￥%@", self.currentLevel.money];
        }
        l1.font = We_font_textfield_large_zh_cn;
        l1.textColor = We_foreground_red_general;
        [cell.contentView addSubview:l1];
        
        UILabel * infoLabel = [[UILabel alloc] init];
        [infoLabel setFrame:CGRectMake(180, 15, 120, 30)];
        if ([self.currentLevel.limit isEqualToString:@"0"]) {
            [infoLabel setText:[NSString stringWithFormat:@"%@人支持", self.currentLevel.supportCount]];
        }
        else {
            [infoLabel setText:[NSString stringWithFormat:@"%@人支持/限%@人", self.currentLevel.supportCount, self.currentLevel.limit]];
        }
        [infoLabel setTextAlignment:NSTextAlignmentRight];
        [infoLabel setTextColor:We_foreground_black_general];
        [infoLabel setFont:We_font_textfield_zh_cn];
        [cell.contentView addSubview:infoLabel];
        
        CGSize sizezz = [self.currentLevel.repay sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 60, sizezz.width, sizezz.height)];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = self.currentLevel.repay;
        label.font = We_font_textfield_zh_cn;
        label.textColor = We_foreground_gray_general;
        [cell.contentView addSubview:label];
    }
    if (indexPath.section == 2) {
        if ([infoList[indexPath.row] isEqualToString:@"name"]) {
            [cell.textLabel setText:@"真实姓名"];
            if (![self.currentFundingSupport.name isEqualToString:@""]) {
                [cell.detailTextLabel setText:self.currentFundingSupport.name];
            }
            else {
                [cell.detailTextLabel setText:@"尚未填写真实姓名"];
            }
            [cell.textLabel setFont:We_font_textfield_zh_cn];
            [cell.textLabel setTextColor:We_foreground_black_general];
            [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
            [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        }
        if ([infoList[indexPath.row] isEqualToString:@"phone"]) {
            [cell.textLabel setText:@"手机号码"];
            if (![self.currentFundingSupport.phone isEqualToString:@""]) {
                [cell.detailTextLabel setText:self.currentFundingSupport.phone];
            }
            else {
                [cell.detailTextLabel setText:@"尚未填写手机号码"];
            }
            [cell.textLabel setFont:We_font_textfield_zh_cn];
            [cell.textLabel setTextColor:We_foreground_black_general];
            [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
            [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        }
        if ([infoList[indexPath.row] isEqualToString:@"email"]) {
            [cell.textLabel setText:@"电子邮箱"];
            if (![self.currentFundingSupport.email isEqualToString:@""]) {
                [cell.detailTextLabel setText:self.currentFundingSupport.email];
            }
            else {
                [cell.detailTextLabel setText:@"尚未填写电子邮箱"];
            }
            [cell.textLabel setFont:We_font_textfield_zh_cn];
            [cell.textLabel setTextColor:We_foreground_black_general];
            [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
            [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        }
        if ([infoList[indexPath.row] isEqualToString:@"zip"]) {
            [cell.textLabel setText:@"邮政编码"];
            if (![self.currentFundingSupport.zip isEqualToString:@""]) {
                [cell.detailTextLabel setText:self.currentFundingSupport.zip];
            }
            else {
                [cell.detailTextLabel setText:@"尚未填写邮政编码"];
            }
            [cell.textLabel setFont:We_font_textfield_zh_cn];
            [cell.textLabel setTextColor:We_foreground_black_general];
            [cell.detailTextLabel setFont:We_font_textfield_zh_cn];
            [cell.detailTextLabel setTextColor:We_foreground_gray_general];
        }
        if ([infoList[indexPath.row] isEqualToString:@"address"]) {
            UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 220 - 16, 40)];
            [l1 setText:@"寄送地址"];
            l1.font = We_font_textfield_zh_cn;
            l1.textColor = We_foreground_black_general;
            [cell.contentView addSubview:l1];
            
            NSString * tmpString = self.currentFundingSupport.address;
            if ([self.currentFundingSupport.address isEqualToString:@""]) tmpString = @"尚未填写寄送地址";
            
            CGSize sizezz = [tmpString sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, sizezz.width, sizezz.height)];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.text = tmpString;
            label.font = We_font_textfield_zh_cn;
            label.textColor = We_foreground_gray_general;
            [cell.contentView addSubview:label];
        }
        if ([infoList[indexPath.row] isEqualToString:@"description"]) {
            UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 220 - 16, 40)];
            [l1 setText:@"自我简介"];
            l1.font = We_font_textfield_zh_cn;
            l1.textColor = We_foreground_black_general;
            [cell.contentView addSubview:l1];
            
            NSString * tmpString = self.currentFundingSupport.description;
            if ([self.currentFundingSupport.description isEqualToString:@""]) tmpString = @"尚未填写自我介绍";
            
            CGSize sizezz = [tmpString sizeWithFont:We_font_textfield_zh_cn constrainedToSize:CGSizeMake(280, 9999) lineBreakMode:NSLineBreakByWordWrapping];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(16, 40, sizezz.width, sizezz.height)];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.text = tmpString;
            label.font = We_font_textfield_zh_cn;
            label.textColor = We_foreground_gray_general;
            [cell.contentView addSubview:label];
        }
    }
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Navigation bar
    self.navigationItem.title = @"支持详情";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"支持详情" style:UIBarButtonItemStylePlain target:self action:nil];
    
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
    [self.view addSubview:sys_tableView];
    
    
    infoList = [[NSMutableArray alloc] init];
    if (self.currentLevel.needName) [infoList addObject:@"name"];
    if (self.currentLevel.needPhone) [infoList addObject:@"phone"];
    if (self.currentLevel.needEmail) [infoList addObject:@"email"];
    if (self.currentLevel.needAddress) {
        [infoList addObject:@"zip"];
        [infoList addObject:@"address"];
    }
    if (self.currentLevel.needDescription) [infoList addObject:@"description"];
    
}

@end
