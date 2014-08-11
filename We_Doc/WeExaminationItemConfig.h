//
//  WeExaminationItemConfig.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeExaminationItemConfig : NSObject

@property(strong, nonatomic) NSString * name;
@property(strong, nonatomic) NSString * unit;
@property(strong, nonatomic) NSString * configId;

- (WeExaminationItemConfig *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;

@end
