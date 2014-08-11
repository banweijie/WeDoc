//
//  WeExamination.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeTextCoding.h"
#import "WeExaminationItem.h"

@interface WeExamination : NSObject

@property(strong, nonatomic) WeTextCoding * type;
@property(strong, nonatomic) NSString * examId;
@property(strong, nonatomic) NSString * typeParent;
@property(strong, nonatomic) NSString * date;
@property(strong, nonatomic) NSString * hospital;
@property(strong, nonatomic) NSString * result;

@property(strong, nonatomic) NSMutableArray * images;
@property(strong, nonatomic) NSMutableArray * items;

- (WeExamination *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;

@end
