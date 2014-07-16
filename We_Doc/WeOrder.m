//
//  WeOrder.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-24.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeOrder.h"

@implementation WeOrder

@synthesize orderId;
@synthesize foreignId;
@synthesize type;
@synthesize createTime;
@synthesize endTime;
@synthesize status;
@synthesize amount;

- (WeOrder *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    
    self.orderId = [NSString stringWithFormat:@"%@", info[@"id"]];
    self.foreignId = [NSString stringWithFormat:@"%@", info[@"foreignId"]];
    self.status = [NSString stringWithFormat:@"%@", info[@"status"]];
    self.createTime = [info[@"createTime"] longLongValue] / 1000;
    self.endTime = [info[@"endTime"] longLongValue] / 1000;
    self.amount = [info[@"amount"] doubleValue];
}

@end
