//
//  Message.h
//  We_Doc
//
//  Created by WeDoctor on 14-5-11.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * content;

@end
