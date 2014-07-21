//
//  WeUser.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeUser.h"

@implementation WeUser

@synthesize avatarPath;
@synthesize userId;
@synthesize userName;
@synthesize userPhone;

- (id)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    self.userId = [NSString stringWithFormat:@"%@", info[@"id"]];
    self.userName = [NSMutableString stringWithFormat:@"%@", info[@"name"]];
    self.userPhone = [NSString stringWithFormat:@"%@", info[@"phone"]];
    self.avatarPath = [NSString stringWithFormat:@"%@", info[@"avatar"]];
}

- (NSString *)stringValue {
    return [NSString stringWithFormat:@"\n%@", @{
                                               @"userId":self.userId,
                                               @"userName":self.userName,
                                               @"userPhone":self.userPhone,
                                               }];
}
@end
