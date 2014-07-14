//
//  WeFavorDoctor.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFavorDoctor.h"

@implementation WeFavorDoctor

@synthesize consultStatus;
@synthesize currentConsultId;
@synthesize sendable;
@synthesize deadline;

- (WeFavorDoctor *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    [super setWithNSDictionary:info[@"patient"]];
    
    self.consultStatus = [NSString stringWithFormat:@"%@", info[@"consultStatus"]];
    self.currentConsultId = [NSString stringWithFormat:@"%@", info[@"currentConsultId"]];
    self.sendable = [[NSString stringWithFormat:@"%@", info[@"sendable"]] isEqualToString:@"1"];
    self.deadline = [info[@"time"] longLongValue] / 100;
}

@end
