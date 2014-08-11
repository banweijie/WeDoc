//
//  WeExamination.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeExamination.h"

@implementation WeExamination

- (WeExamination *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    self.type = [[WeTextCoding alloc] initWithNSDictionary:info[@"type"]];
    self.typeParent = [NSString stringWithFormat:@"%@", info[@"typeParent"]];
    self.examId = [NSString stringWithFormat:@"%@", info[@"id"]];
    self.date = [NSString stringWithFormat:@"%@", info[@"date"]];
    self.hospital = [NSString stringWithFormat:@"%@", info[@"hospital"]];
    self.result = [NSString stringWithFormat:@"%@", info[@"result"]];
    
    self.images = [[NSMutableArray alloc] init];
    if (![[NSString stringWithFormat:@"%@", info[@"images"]] isEqualToString:@"<null>"]) {
        for (int i = 0; i < [info[@"images"] count]; i++) {
            WeTextCoding * newImage = [[WeTextCoding alloc] initWithNSDictionary:info[@"images"][i]];
            [self.images addObject:newImage];
        }
    }
    
    self.items = [[NSMutableArray alloc] init];
    if (![[NSString stringWithFormat:@"%@", info[@"items"]] isEqualToString:@"<null>"]) {
        for (int i = 0; i < [info[@"items"] count]; i++) {
            WeExaminationItem * newItem = [[WeExaminationItem alloc] initWithNSDictionary:info[@"items"][i]];
            [self.items addObject:newItem];
        }
    }
}

@end
