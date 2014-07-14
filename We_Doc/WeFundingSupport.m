//
//  WeFundingSupport.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFundingSupport.h"

@implementation WeFundingSupport

@synthesize supportId;
@synthesize orderId;
@synthesize supporter;
@synthesize paid;
@synthesize email;
@synthesize name;
@synthesize phone;
@synthesize zip;
@synthesize address;
@synthesize description;
@synthesize remark;

- (WeFundingSupport *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    self.supportId = [NSString stringWithFormat:@"%@", info[@"id"]];
    self.orderId = [NSString stringWithFormat:@"%@", info[@"order"][@"id"]];
    if (![info[@"supporter"] isEqual:[NSNull null]]) {
        self.supporter = [[WePatient alloc] initWithNSDictionary:info[@"supporter"]];
    }
    self.paid = [[NSString stringWithFormat:@"%@", info[@"paid"]] isEqualToString:@"1"];
    
    self.email = [NSString stringWithFormat:@"%@", info[@"email"]];
    self.name = [NSString stringWithFormat:@"%@", info[@"name"]];
    self.phone = [NSString stringWithFormat:@"%@", info[@"phone"]];
    self.zip = [NSString stringWithFormat:@"%@", info[@"zip"]];
    self.address = [NSString stringWithFormat:@"%@", info[@"address"]];
    self.description = [NSString stringWithFormat:@"%@", info[@"description"]];
    self.remark = [NSString stringWithFormat:@"%@", info[@"remark"]];
}

@end
