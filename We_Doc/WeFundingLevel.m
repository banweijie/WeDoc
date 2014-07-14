//
//  WeFundingLevel.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-21.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFundingLevel.h"

@implementation WeFundingLevel

@synthesize levelId;
@synthesize money;
@synthesize limit;
@synthesize repay;
@synthesize fundingId;
@synthesize type;
@synthesize way;
@synthesize open;
@synthesize needEmail;
@synthesize needAddress;
@synthesize needPhone;
@synthesize needName;
@synthesize needDescription;
@synthesize sendRedPin;
@synthesize sendBluePin;
@synthesize supportCount;
@synthesize supports;

- (WeFundingLevel *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    self.levelId = [NSString stringWithFormat:@"%@", info[@"id"]];
    self.money = [NSString stringWithFormat:@"%@", info[@"money"]];
    self.limit = [NSString stringWithFormat:@"%@", info[@"limit"]];
    self.repay = [NSString stringWithFormat:@"%@", info[@"repay"]];
    self.fundingId = [NSString stringWithFormat:@"%@", info[@"fundingId"]];
    self.type = [NSString stringWithFormat:@"%@", info[@"type"]];
    self.way = [NSString stringWithFormat:@"%@", info[@"way"]];
    self.open = [NSString stringWithFormat:@"%@", info[@"open"]];
    self.needEmail = [[NSString stringWithFormat:@"%@", info[@"needEmail"]] isEqualToString:@"1"];
    self.needAddress = [[NSString stringWithFormat:@"%@", info[@"needAddress"]] isEqualToString:@"1"];
    self.needPhone = [[NSString stringWithFormat:@"%@", info[@"needPhone"]] isEqualToString:@"1"];
    self.needName = [[NSString stringWithFormat:@"%@", info[@"needName"]] isEqualToString:@"1"];
    self.needDescription = [[NSString stringWithFormat:@"%@", info[@"needDescription"]] isEqualToString:@"1"];
    self.sendRedPin = [NSString stringWithFormat:@"%@", info[@"sendRedPin"]];
    self.sendBluePin = [NSString stringWithFormat:@"%@", info[@"sendBluePin"]];
    self.supportCount = [NSString stringWithFormat:@"%@", info[@"supportCount"]];
}

@end
