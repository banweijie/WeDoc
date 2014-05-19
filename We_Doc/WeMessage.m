//
//  WeMessage.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-18.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeMessage.h"

@implementation WeMessage

@synthesize messageId;
@synthesize messageType;
@synthesize receiverId;
@synthesize senderId;
@synthesize viewed;
@synthesize content;
@synthesize time;

@synthesize imageContent;
@synthesize audioContent;

- (WeMessage *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    // 提取信息
    [self setMessageId:[NSString stringWithFormat:@"%@", info[@"id"]]];
    [self setMessageType:[NSString stringWithFormat:@"%@", info[@"type"]]];
    [self setReceiverId:[NSString stringWithFormat:@"%@", info[@"receiverId"]]];
    [self setSenderId:[NSString stringWithFormat:@"%@", info[@"senderId"]]];
    [self setViewed:[NSString stringWithFormat:@"%@", info[@"viewed"]]];
    [self setContent:[NSString stringWithFormat:@"%@", info[@"content"]]];
    self.time = [info[@"time"] longLongValue] / 100;
    self.loading = YES;
    [self setImageContent:nil];
}

- (NSString *)stringValue {
    return [NSString stringWithFormat:@"%@", @{
                                               @"messageId":self.messageId,
                                               @"messageType":self.messageType,
                                               @"receiverId":self.receiverId,
                                               @"senderId":self.senderId,
                                               @"content":self.content
                                               }];
}

@end
