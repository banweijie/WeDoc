//
//  WeExaminationItem.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeExaminationItemConfig.h"

@interface WeExaminationItem : NSObject

@property(strong, nonatomic) NSString * value;
@property(strong, nonatomic) WeExaminationItemConfig * config;
@property(strong, nonatomic) NSString * itemId;

- (WeExaminationItem *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;

@end
