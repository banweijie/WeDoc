//
//  WeFavorPatient.m
//  We_Doc
//
//  Created by WeDoctor on 14-5-19.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFavorPatient.h"

@implementation WeFavorPatient

@synthesize consultStatus;
@synthesize currentConsultId;
@synthesize sendable;
@synthesize deadline;

- (WeFavorPatient *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    [super setWithNSDictionary:info[@"patient"]];
    
    self.consultStatus = [NSString stringWithFormat:@"%@", info[@"consultStatus"]];
    self.currentConsultId = [NSString stringWithFormat:@"%@", info[@"currentConsultId"]];
    self.sendable = [[NSString stringWithFormat:@"%@", info[@"sendable"]] isEqualToString:@"true"];
    self.deadline = [info[@"time"] longLongValue] / 100;
}

@end
