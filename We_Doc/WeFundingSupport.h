//
//  WeFundingSupport.h
//  AplusDr
//
//  Created by WeDoctor on 14-6-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WePatient.h"

@interface WeFundingSupport : NSObject

@property(nonatomic, strong) NSString * supportId;
@property(nonatomic, strong) NSString * orderId;
@property(nonatomic, strong) WePatient * supporter;
@property(nonatomic) BOOL paid;

@property(nonatomic, strong) NSString * email;
@property(nonatomic, strong) NSString * name;
@property(nonatomic, strong) NSString * phone;
@property(nonatomic, strong) NSString * zip;
@property(nonatomic, strong) NSString * address;
@property(nonatomic, strong) NSString * description;
@property(nonatomic, strong) NSString * remark;

- (WeFundingSupport *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;

@end
