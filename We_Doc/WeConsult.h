//
//  WeConsult.h
//  We_Doc
//
//  Created by WeDoctor on 14-7-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeConsult : NSObject

@property(nonatomic, strong) NSString * gender;
@property(nonatomic, strong) NSString * age;
@property(nonatomic) bool emergent;

- (WeConsult *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;

@end
