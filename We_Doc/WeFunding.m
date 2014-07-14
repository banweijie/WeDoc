//
//  WeFunding.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-21.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunding.h"

@implementation WeFunding

@synthesize fundingId;
@synthesize initiator;
@synthesize status;
@synthesize startTime;
@synthesize endTime;
@synthesize type;
@synthesize title;
@synthesize subTitle;
@synthesize poster;
@synthesize poster2;
@synthesize introduction;
@synthesize goal;
@synthesize days;
@synthesize video;
@synthesize description;
@synthesize levels;
@synthesize sum;
@synthesize likeCount;
@synthesize supportCount;

- (WeFunding *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    self.fundingId = [NSString stringWithFormat:@"%@", info[@"id"]];
    self.initiator = [[WeDoctor alloc] initWithNSDictionary:info[@"initiator"]];
    self.status = [NSString stringWithFormat:@"%@", info[@"status"]];
    self.startTime = [NSString stringWithFormat:@"%@", info[@"startTime"]];
    self.endTime = [NSString stringWithFormat:@"%@", info[@"endTime"]];
    self.type = [NSString stringWithFormat:@"%@", info[@"type"]];
    self.title = [NSString stringWithFormat:@"%@", info[@"title"]];
    self.subTitle = [NSString stringWithFormat:@"%@", info[@"subtitle"]];
    self.poster = [NSString stringWithFormat:@"%@", info[@"poster"]];
    self.poster2 = [NSString stringWithFormat:@"%@", info[@"poster2"]];
    self.introduction = [NSString stringWithFormat:@"%@", info[@"introduction"]];
    self.goal = [NSString stringWithFormat:@"%@", info[@"goal"]];
    self.days = [NSString stringWithFormat:@"%@", info[@"days"]];
    self.video = [NSString stringWithFormat:@"%@", info[@"video"]];
    self.description = [NSString stringWithFormat:@"%@", info[@"description"]];
    self.sum = [NSString stringWithFormat:@"%@", info[@"sum"]];
    self.likeCount = [NSString stringWithFormat:@"%@", info[@"likeCount"]];
    self.supportCount = [NSString stringWithFormat:@"%@", info[@"supportCount"]];
    
    self.levels = [[NSMutableArray alloc] init];
    if (info[@"levels"] != [NSNull null]) {
        NSArray * levelJsonList = info[@"levels"];
        for (int i = 0; i < [levelJsonList count]; i ++) {
            [self.levels addObject:[[WeFundingLevel alloc] initWithNSDictionary:levelJsonList[i]]];
        }
    }
}

@end
