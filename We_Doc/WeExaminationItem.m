//
//  WeExaminationItem.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeExaminationItem.h"

@implementation WeExaminationItem

@synthesize value;
@synthesize config;
@synthesize itemId;

- (WeExaminationItem *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    self.value = [NSString stringWithFormat:@"%@", info[@"value"]];
    self.config = [[WeExaminationItemConfig alloc] initWithNSDictionary:info[@"config"]];
    self.itemId = [NSString stringWithFormat:@"%@", info[@"id"]];
}

@end
