//
//  WeFavorDoctor.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeDoctor.h"

@interface WeFavorDoctor : WeDoctor

@property(strong, nonatomic) NSString * consultStatus;
@property(strong, nonatomic) NSString * currentConsultId;
@property(nonatomic) BOOL sendable;
@property(nonatomic) long long deadline;

- (WeFavorDoctor *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;

@end
