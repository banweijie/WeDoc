//
//  WeFunDetViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-6-21.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"
#import "WeFunding.h"

#import "WeFunDesViewController.h"
#import "WeFunSupViewController.h"
#import "WeNavViewController.h"
#import "WeRegWlcViewController.h"

@interface WeFunDetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSString * currentFundingId;

@end
