//
//  WeFunding.h
//  AplusDr
//
//  Created by WeDoctor on 14-6-21.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeDoctor.h"
#import "WeFundingLevel.h"

@interface WeFunding : NSObject

@property(nonatomic, strong) NSString * fundingId;
@property(nonatomic, strong) WeDoctor * initiator;
@property(nonatomic, strong) NSString * status;
@property(nonatomic, strong) NSString * startTime;
@property(nonatomic, strong) NSString * endTime;
@property(nonatomic, strong) NSString * type;
@property(nonatomic, strong) NSString * title;
@property(nonatomic, strong) NSString * subTitle;
@property(nonatomic, strong) NSString * poster;
@property(nonatomic, strong) NSString * poster2;
@property(nonatomic, strong) NSString * introduction;
@property(nonatomic, strong) NSString * goal;
@property(nonatomic, strong) NSString * days;
@property(nonatomic, strong) NSString * video;
@property(nonatomic, strong) NSString * description;
@property(nonatomic, strong) NSMutableArray * levels;
@property(nonatomic, strong) NSString * sum;
@property(nonatomic, strong) NSString * likeCount;
@property(nonatomic, strong) NSString * supportCount;

- (WeFunding *)initWithNSDictionary:(NSDictionary *)info;
- (void)setWithNSDictionary:(NSDictionary *)info;

@end
