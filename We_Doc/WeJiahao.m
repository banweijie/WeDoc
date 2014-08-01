//
//  WeJiahao.m
//  We_Doc
//
//  Created by WeDoctor on 14-7-16.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeJiahao.h"

@implementation WeJiahao


- (WeJiahao *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    
    if (info[@"doctor"] != [NSNull null]) self.doctor = [[WeDoctor alloc] initWithNSDictionary:info[@"doctor"]];
    if (info[@"patient"] != [NSNull null]) self.patient = [[WePatient alloc] initWithNSDictionary:info[@"patient"]];
    
    
    self.jiahaoId = [NSString stringWithFormat:@"%@", info[@"id"]];
    self.dates = [NSString stringWithFormat:@"%@", info[@"dates"]];
    self.datesToDemo = @"";
    for (int i = 0; i < [self.dates length] / 12; i ++) {
        NSString * year = [self.dates substringWithRange:NSMakeRange(i * 12 + 1, 4)];
        NSString * month = [self.dates substringWithRange:NSMakeRange(i * 12 + 6, 2)];
        NSString * day = [self.dates substringWithRange:NSMakeRange(i * 12 + 9, 2)];
        NSString * period = [self.dates substringWithRange:NSMakeRange(i * 12 + 11, 1)];
        self.datesToDemo = [NSString stringWithFormat:@"%@%@年%@月%@日 %@\n", self.datesToDemo, year, month, day, [self transitionPeriodOfDayFromChar:period]];
    }
    if (info[@"date"] != [NSNull null]) {
        self.date = [NSString stringWithFormat:@"%@", info[@"date"]];
        NSString * year = [self.date substringWithRange:NSMakeRange(0, 4)];
        NSString * month = [self.date substringWithRange:NSMakeRange(5, 2)];
        NSString * day = [self.date substringWithRange:NSMakeRange(8, 2)];
        NSString * period = [self.date substringWithRange:NSMakeRange(10, 1)];
        self.dateToDemo = [NSString stringWithFormat:@"%@年%@月%@日 %@", year, month, day, [self transitionPeriodOfDayFromChar:period]];
    }
    self.name = [NSString stringWithFormat:@"%@", info[@"name"]];
    self.age = [NSString stringWithFormat:@"%@", info[@"age"]];
    self.idNum = [NSString stringWithFormat:@"%@", info[@"idNum"]];
    self.gender = [NSString stringWithFormat:@"%@", info[@"gender"]];
    if (info[@"status"] != [NSNull null]) self.status = [NSString stringWithFormat:@"%@", info[@"status"]];
}

- (NSString *)transitionPeriodOfDayFromChar:(NSString *)PeriodOfDay {
    if ([PeriodOfDay isEqualToString:@"A"]) return @"上午";
    if ([PeriodOfDay isEqualToString:@"B"]) return @"下午";
    return @"出错啦！";
}

@end
