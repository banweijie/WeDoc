//
//  WeRecordDrug.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeRecordDrug.h"

@implementation WeRecordDrug

@synthesize recordDrugId;
@synthesize recordDrugName;
@synthesize dosage;
@synthesize note;

- (WeRecordDrug *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    self.recordDrugId = [NSString stringWithFormat:@"%@", info[@"id"]];
    self.recordDrugName = [NSString stringWithFormat:@"%@", info[@"name"]];
    self.dosage = [NSString stringWithFormat:@"%@", info[@"dosage"]];
    self.note = [NSString stringWithFormat:@"%@", info[@"note"]];
}

- (NSString *)stringValue {
    return [NSString stringWithFormat:@"%@", @{
                                               }];
}

@end
