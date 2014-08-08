//
//  WeMyFundingSupportLevelsViewController.h
//  We_Doc
//
//  Created by WeDoctor on 14-8-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"
#import "WeFunding.h"
#import "WeInfoedButton.h"
#import "WeMyFundingSupportsViewController.h"

@interface WeMyFundingSupportLevelsViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) WeFunding * currentFunding;

@end
