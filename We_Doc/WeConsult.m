//
//  WeConsult.m
//  We_Doc
//
//  Created by WeDoctor on 14-7-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeConsult.h"

@implementation WeConsult

- (WeConsult *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    self.gender = [NSString stringWithFormat:@"%@", info[@"gender"]];
    self.age = [NSString stringWithFormat:@"%@", info[@"age"]];
    self.emergent = [[NSString stringWithFormat:@"%@", info[@"emergent"]] isEqualToString:@"1"];
}

@end
