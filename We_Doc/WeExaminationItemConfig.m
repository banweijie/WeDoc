//
//  WeExaminationItemConfig.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeExaminationItemConfig.h"

@implementation WeExaminationItemConfig

@synthesize name;
@synthesize unit;
@synthesize configId;

- (WeExaminationItemConfig *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    self.name = [NSString stringWithFormat:@"%@", info[@"name"]];
    self.unit = [NSString stringWithFormat:@"%@", info[@"unit"]];
    self.configId = [NSString stringWithFormat:@"%@", info[@"id"]];
}

@end
