//
//  Patient.h
//  We_Doc
//
//  Created by WeDoctor on 14-5-11.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Patient : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * patientId;

@end
