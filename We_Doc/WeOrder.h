//
//  WeOrder.h
//  AplusDr
//
//  Created by WeDoctor on 14-6-24.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeOrder : NSObject

@property(nonatomic, strong) NSString * orderId;
@property(nonatomic, strong) NSString * foreignId;
@property(nonatomic, strong) NSString * type;
@property(nonatomic) long long createTime;
@property(nonatomic) long long endTime;
@property(nonatomic, strong) NSString * status;
@property(nonatomic) double amount;

- (WeOrder *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;

@end
