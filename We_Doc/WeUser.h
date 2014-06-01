//
//  WeUser.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeUser : NSObject

@property(strong, nonatomic) NSString * userId;
@property(strong, nonatomic) NSString * avatarPath;
@property(strong, nonatomic) NSString * userName;
@property(strong, nonatomic) NSString * userPhone;

@property(strong, nonatomic) UIImage * avatar;

- (id)init;
- (WeUser *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;
- (NSString *)stringValue;

@end
