//
//  WeFavorPatient.h
//  We_Doc
//
//  Created by WeDoctor on 14-5-19.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePatient.h"

@interface WeFavorPatient : WePatient

@property(strong, nonatomic) NSString * consultStatus;
@property(strong, nonatomic) NSString * currentConsultId;
@property(nonatomic) BOOL sendable;
@property(nonatomic) BOOL emergent;
@property(nonatomic) long long deadline;

- (WeFavorPatient *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;

@end
