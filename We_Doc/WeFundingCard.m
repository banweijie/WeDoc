//
//  WeFundingCard.m
//  We_Doc
//
//  Created by WeDoctor on 14-8-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFundingCard.h"

@implementation WeFundingCard

#define titlePref 20
#define titleTail 20


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithWeFunding:(WeFunding *)currentFunding {
    
    int heightOfTitle = [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height;
    
    self = [super initWithFrame:CGRectMake(10, 0, 300, 220 + 5 + 20 * 2 + heightOfTitle + 40 + 60)];
    [self setBackgroundColor:We_background_cell_general];
    
    // 背景图片
    UIImageView * backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 220)];
    [backGroundImageView setImageWithURL:[NSURL URLWithString:yijiarenImageUrl(currentFunding.poster2)]];
    [backGroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [backGroundImageView setClipsToBounds:YES];
    [self addSubview:backGroundImageView];
    
    // 主标题栏
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(20, 220 + titlePref, 260, heightOfTitle)];
    [title setText:currentFunding.title];
    [title setFont:We_font_textfield_large_zh_cn];
    [title setTextColor:We_foreground_black_general];
    [self addSubview:title];
    
    // 医生信息
    UILabel * docInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 220 + titlePref + heightOfTitle + titleTail, 260, 20)];
    [docInfo setText:[NSString stringWithFormat:@"%@   %@", currentFunding.initiator.userName, currentFunding.initiator.hospitalName]];
    [docInfo setFont:We_font_textfield_zh_cn];
    [docInfo setTextColor:We_foreground_gray_general];
    [self addSubview:docInfo];
    
    // 同业支持
    UILabel * likeInfo = [[UILabel alloc] initWithFrame:CGRectMake(180, 220 + titlePref + heightOfTitle + titleTail, 100, 20)];
    [likeInfo setTextAlignment:NSTextAlignmentRight];
    [likeInfo setText:[NSString stringWithFormat:@"同业支持 %@", currentFunding.likeCount]];
    [likeInfo setFont:We_font_textfield_small_zh_cn];
    [likeInfo setTextColor:We_foreground_red_general];
    [self addSubview:likeInfo];
    
    // 进度条
    UIImageView * progressView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 220 + titlePref + heightOfTitle + titleTail + 20 + 20, 260, 5)];
    [progressView setImage:[WeAppDelegate imageWithColor:We_foreground_gray_general]];
    [self addSubview:progressView];
    
    int progress;
    if ([currentFunding.type isEqualToString:@"D"]) {
        progress = MIN(1, 1.0 * [currentFunding.supportCount intValue] / [currentFunding.goal intValue]);
    }
    else {
        progress = MIN(1, 1.0 * [currentFunding.sum intValue] / [currentFunding.goal intValue]);
    }
    
    UIImageView * progressBar = [[UIImageView alloc] initWithFrame:CGRectMake(20, 220 + titlePref + heightOfTitle + titleTail + 20 + 20, 260.0 * progress, 5)];
    [progressBar setImage:[WeAppDelegate imageWithColor:We_foreground_red_general]];
    [self addSubview:progressBar];
    
    
    /*
    
    
    
    
    
    // 已达
    UILabel * reachedData = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 10, 260, 20)];
    [reachedData setTextAlignment:NSTextAlignmentLeft];
    [reachedData setFont:We_font_textfield_small_zh_cn];
    if ([currentFunding.type isEqualToString:@"D"]) {
        [reachedData setText:[NSString stringWithFormat:@"%.2f%%", [currentFunding.supportCount intValue] * 100.0 / [currentFunding.goal intValue]]];
    }
    else {
        [reachedData setText:[NSString stringWithFormat:@"%.2f%%", [currentFunding.sum intValue] * 100.0 / [currentFunding.goal intValue]]];
    }
    [cell.contentView addSubview:reachedData];
    
    UILabel * reachedLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 20 + 10, 260, 20)];
    [reachedLabel setTextAlignment:NSTextAlignmentLeft];
    [reachedLabel setFont:We_font_textfield_small_zh_cn];
    [reachedLabel setTextColor:We_foreground_gray_general];
    [reachedLabel setText:@"已达"];
    [cell.contentView addSubview:reachedLabel];
    
    // 已筹资
    if ([currentFunding.type isEqualToString:@"D"]) {
        UILabel * reachedData = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 10, 260, 20)];
        [reachedData setTextAlignment:NSTextAlignmentCenter];
        [reachedData setFont:We_font_textfield_small_zh_cn];
        [reachedData setText:[NSString stringWithFormat:@"%@/%@ 人", currentFunding.supportCount, currentFunding.goal]];
        [cell.contentView addSubview:reachedData];
        
        UILabel * reachedLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 20 + 10, 260, 20)];
        [reachedLabel setTextAlignment:NSTextAlignmentCenter];
        [reachedLabel setFont:We_font_textfield_small_zh_cn];
        [reachedLabel setTextColor:We_foreground_gray_general];
        [reachedLabel setText:@"已招募"];
        [cell.contentView addSubview:reachedLabel];
    }
    else {
        UILabel * reachedData = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 10, 260, 20)];
        [reachedData setTextAlignment:NSTextAlignmentCenter];
        [reachedData setFont:We_font_textfield_small_zh_cn];
        [reachedData setText:[NSString stringWithFormat:@"￥%@/￥%@", currentFunding.sum, currentFunding.goal]];
        [cell.contentView addSubview:reachedData];
        
        UILabel * reachedLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 20 + 10, 260, 20)];
        [reachedLabel setTextAlignment:NSTextAlignmentCenter];
        [reachedLabel setFont:We_font_textfield_small_zh_cn];
        [reachedLabel setTextColor:We_foreground_gray_general];
        [reachedLabel setText:@"已筹资"];
        [cell.contentView addSubview:reachedLabel];
    }
    
    // 剩余时间
    UILabel * restData = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 10, 260, 20)];
    [restData setTextAlignment:NSTextAlignmentRight];
    [restData setFont:We_font_textfield_small_zh_cn];
    int restSec =  [currentFunding.endTime longLongValue] / 1000 - [[NSDate date] timeIntervalSince1970];
    if (restSec < 0) {
        [restData setText:[NSString stringWithFormat:@"已结束"]];
    }
    else {
        [restData setText:[NSString stringWithFormat:@"%d天", restSec / 86400]];
    }
    [cell.contentView addSubview:restData];
    
    UILabel * restLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 20 + 20 + 20 + 10, 260, 20)];
    [restLabel setTextAlignment:NSTextAlignmentRight];
    [restLabel setFont:We_font_textfield_small_zh_cn];
    [restLabel setTextColor:We_foreground_gray_general];
    [restLabel setText:@"剩余时间"];
    [cell.contentView addSubview:restLabel];
    
    // 框框1
    UIView * frame1 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 40)];
    [frame1.layer setBorderWidth:0.3];
    [frame1.layer setBorderColor:We_foreground_gray_general.CGColor];
    //[cell.contentView addSubview:frame1];
    
    // 框框2
    UIView * frame2 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 220 + 5 + 20 * 2 + [WeAppDelegate calcSizeForString:currentFunding.title Font:We_font_textfield_large_zh_cn expectWidth:260].height + 40 + 60)];
    [frame2.layer setBorderWidth:0.3];
    [frame2.layer setBorderColor:We_foreground_gray_general.CGColor];
    [cell.contentView addSubview:frame2];
    */
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

@end
