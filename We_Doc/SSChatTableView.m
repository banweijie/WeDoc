//
//  SSTableView.m
//  We_Doc
//
//  Created by WeDoctor on 14-5-10.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "SSChatTableView.h"
#import "SSChatHeaderTableViewCell.h"

@implementation SSChatTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UITableView DataSource & Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Header
    if (indexPath.row == 0) return [SSChatHeaderTableViewCell height];
}

// 询问共有多少个段落
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 1;
}
// 询问每个段落有多少条目
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [we_patients count];
            break;
        default:
            return 0;
    }
}
// 编辑时进行的动作
-(void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (![self deletePatientAtIndex:indexPath.row]) return;
        [we_patients removeObjectAtIndex:indexPath.row];
        [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
// 返回是否可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
    UILabel * l3;
    PAImageView *avatarView;
    NSDictionary * lastMsg;
    [[cell imageView] setContentMode:UIViewContentModeCenter];
    switch (indexPath.section) {
        case 0:
            cell.contentView.backgroundColor = We_background_cell_general;
            // l1 - user name
            l1 = [[UILabel alloc] initWithFrame:CGRectMake(75, 9, 240, 23)];
            l1.text = we_patients[indexPath.row][@"patient"][@"name"];
            if ([l1.text isEqualToString:@""]) l1.text = @"尚未设置名称";
            l1.font = We_font_textfield_zh_cn;
            l1.textColor = We_foreground_black_general;
            [cell.contentView addSubview:l1];
            // l2 - lastMsg - content
            l2 = [[UILabel alloc] initWithFrame:CGRectMake(75, 33, 240, 23)];
            lastMsg = [we_msgsForPatient[[WeAppDelegate toString:we_patients[indexPath.row][@"patient"][@"id"]]]lastObject];
            if ([lastMsg[@"type"] isEqualToString:@"C"]) {
                long long restSecond = [we_maxResponseGap intValue] * 3600 - (long long) (([[NSDate date] timeIntervalSince1970] - [[WeAppDelegate toString:lastMsg[@"time"]] longLongValue] / 100));
                l2.text = [NSString stringWithFormat:@"[申请咨询中 剩余%lld小时%lld分钟]",  restSecond / 3600, restSecond % 3600 / 60];
                l2.textColor = We_foreground_red_general;
            }
            else {
                l2.text = @"尚未处理此类型的消息";
            }
            l2.font = We_font_textfield_small_zh_cn;
            [cell.contentView addSubview:l2];
            // l3 - lastMsg - time
            l3 = [[UILabel alloc] initWithFrame:CGRectMake(75, 33, 235, 23)];
            l3.textColor = We_foreground_gray_general;
            l3.font = [UIFont fontWithName:@"Heiti SC" size:10];
            l3.text = [WeAppDelegate transitionToDateFromSecond:[lastMsg[@"time"] longLongValue]];
            l3.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:l3];
            // avatar
            avatarView = [[PAImageView alloc]initWithFrame:CGRectMake(15, 9, 48, 48) backgroundProgressColor:[UIColor clearColor] progressColor:[UIColor lightGrayColor]];
            [avatarView setImageURL:yijiarenAvatarUrl(we_patients[indexPath.row][@"patient"][@"avatar"])];
            [cell.contentView addSubview:avatarView];
            break;
        default:
            break;
    }
    return cell;
}

@end
