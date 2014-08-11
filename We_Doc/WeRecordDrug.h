//
//  WeRecordDrug.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeRecordDrug : NSObject

@property(strong, nonatomic) NSString * recordDrugId;
@property(strong, nonatomic) NSString * recordDrugName;
@property(strong, nonatomic) NSString * dosage;
@property(strong, nonatomic) NSString * note;


- (WeRecordDrug *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;
- (NSString *)stringValue;

@end
