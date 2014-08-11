//
//  WeTextCoding.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeTextCoding : NSObject

@property(strong, nonatomic) NSString * objId;
@property(strong, nonatomic) NSString * objName;


- (WeTextCoding *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;

@end
