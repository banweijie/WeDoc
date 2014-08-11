//
//  WeTextCoding.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeTextCoding.h"

@implementation WeTextCoding

@synthesize objId;
@synthesize objName;

- (WeTextCoding *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    self.objId = [NSString stringWithFormat:@"%@", info[@"id"]];
    self.objName = [NSString stringWithFormat:@"%@", info[@"text"]];
}

@end
