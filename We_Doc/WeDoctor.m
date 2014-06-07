//
//  WeDoctor.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeDoctor.h"

@implementation WeDoctor

@synthesize title;
@synthesize category;
@synthesize hospitalName;
@synthesize sectionName;
@synthesize workPeriod;
@synthesize notice;
@synthesize groupIntro;
@synthesize consultPrice;
@synthesize degree;
@synthesize email;
@synthesize gender;
@synthesize maxResponseGap;
@synthesize plusPrice;
@synthesize pcPath;
@synthesize qcPath;
@synthesize wcPath;
@synthesize skills;
@synthesize status;
@synthesize hospitalId;
@synthesize sectionId;
@synthesize qcImage;
@synthesize pcImage;
@synthesize wcImage;

- (WeDoctor *)initWithNSDictionary:(NSDictionary *)info {
    [self setWithNSDictionary:info];
    return self;
}

- (void)setWithNSDictionary:(NSDictionary *)info {
    self.avatar = [UIImage imageNamed:@"defaultAvatar"];
    [self setHospitalName:[NSString stringWithFormat:@"%@", info[@"hospital"][@"text"]]];
    [self setSectionName:[NSString stringWithFormat:@"%@", info[@"section"][@"text"]]];
    [self setHospitalId:[NSString stringWithFormat:@"%@", info[@"hospital"][@"id"]]];
    [self setSectionId:[NSString stringWithFormat:@"%@", info[@"section"][@"id"]]];
    [self setTitle:[NSString stringWithFormat:@"%@", info[@"title"]]];
    [self setCategory:[NSString stringWithFormat:@"%@", info[@"category"]]];
    [self setUserId:[NSString stringWithFormat:@"%@", info[@"id"]]];
    [self setUserName:[NSString stringWithFormat:@"%@", info[@"name"]]];
    [self setUserPhone:[NSString stringWithFormat:@"%@", info[@"phone"]]];
    [self setAvatarPath:[NSString stringWithFormat:@"%@", info[@"avatar"]]];
    [self setNotice:[NSString stringWithFormat:@"%@", info[@"notice"]]];
    [self setGroupIntro:[NSString stringWithFormat:@"%@", info[@"groupIntro"]]];
    [self setConsultPrice:[NSString stringWithFormat:@"%@", info[@"consultPrice"]]];
    [self setDegree:[NSString stringWithFormat:@"%@", info[@"degree"]]];
    [self setEmail:[NSString stringWithFormat:@"%@", info[@"email"]]];
    [self setGender:[NSString stringWithFormat:@"%@", info[@"gender"]]];
    [self setMaxResponseGap:[NSString stringWithFormat:@"%@", info[@"maxResponseGap"]]];
    [self setPlusPrice:[NSString stringWithFormat:@"%@", info[@"plusPrice"]]];
    [self setWorkPeriod:[NSString stringWithFormat:@"%@", info[@"workPeriod"]]];
    [self setWcPath:[NSString stringWithFormat:@"%@", info[@"pcPath"]]];
    [self setQcPath:[NSString stringWithFormat:@"%@", info[@"qcPath"]]];
    [self setWcPath:[NSString stringWithFormat:@"%@", info[@"wcPath"]]];
    [self setSkills:[NSString stringWithFormat:@"%@", info[@"skills"]]];
    [self setStatus:[NSString stringWithFormat:@"%@", info[@"status"]]];
}

@end
