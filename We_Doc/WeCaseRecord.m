//
//  WeCaseRecord.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-24.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeCaseRecord.h"

@implementation WeCaseRecord

@synthesize caseRecordId;
@synthesize hospitalName;
@synthesize date;
@synthesize diseaseName;
@synthesize treatment;
@synthesize examinations;
@synthesize recordDrugs;

- (WeCaseRecord *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    self.caseRecordId = [NSString stringWithFormat:@"%@", info[@"id"]];
    self.date = [NSString stringWithFormat:@"%@", info[@"date"]];
    self.diseaseName = [NSString stringWithFormat:@"%@", info[@"disease"]];
    self.hospitalName = [NSString stringWithFormat:@"%@", info[@"hospital"]];
    self.treatment = [NSString stringWithFormat:@"%@", info[@"treatment"]];
    
    self.recordDrugs = [[NSMutableArray alloc] init];
    if (![[NSString stringWithFormat:@"%@", info[@"recordDrugs"]] isEqualToString:@"<null>"]) {
        NSLog(@"%@", info);
        for (int i = 0; i < [info[@"recordDrugs"] count]; i++) {
            WeRecordDrug * newRecordDrug = [[WeRecordDrug alloc] initWithNSDictionary:info[@"recordDrugs"][i]];
            [self.recordDrugs addObject:newRecordDrug];
        }
    }
}

- (NSString *)stringValue {
    return [NSString stringWithFormat:@"%@", @{
                                               }];
}

- (void)setWithCaseRecord:(WeCaseRecord *)caseRecord {
    self.caseRecordId = caseRecord.caseRecordId;
    self.date = caseRecord.date;
    self.diseaseName = caseRecord.diseaseName;
    self.hospitalName = caseRecord.hospitalName;
    self.treatment = caseRecord.treatment;
}

@end
