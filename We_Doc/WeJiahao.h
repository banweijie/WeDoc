//
//  WeJiahao.h
//  We_Doc
//
//  Created by WeDoctor on 14-7-16.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeDoctor.h"
#import "WePatient.h"

@interface WeJiahao : NSObject

@property(nonatomic, strong) WeDoctor * doctor;
@property(nonatomic, strong) WePatient * patient;

@property(nonatomic, strong) NSString * jiahaoId;
@property(nonatomic, strong) NSString * orderId;
@property(nonatomic, strong) NSString * name;
@property(nonatomic, strong) NSString * idNum;
@property(nonatomic, strong) NSString * gender;
@property(nonatomic, strong) NSString * age;
@property(nonatomic, strong) NSString * dates;
@property(nonatomic, strong) NSString * datesToDemo;
@property(nonatomic, strong) NSString * date;
@property(nonatomic, strong) NSString * dateToDemo;

- (WeJiahao *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;

@end
