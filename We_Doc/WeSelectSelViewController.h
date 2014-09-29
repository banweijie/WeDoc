//
//  WeSelectSelViewController.h
//  We_Doc
//
//  Created by ejren on 14-9-29.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectSelDelegrate <NSObject>

-(void)selectInTableView:(NSString *)str sele:(NSString *)sel;

@end

@interface WeSelectSelViewController : UIViewController

@property (nonatomic,retain)id<SelectSelDelegrate> delegrate;
@end
