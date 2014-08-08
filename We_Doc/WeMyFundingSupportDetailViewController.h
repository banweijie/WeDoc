//
//  WeMyFundingSupportDetailViewController.h
//  We_Doc
//
//  Created by WeDoctor on 14-8-8.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"
#import "WeFundingSupport.h"
#import "WeFundingCard.h"

@interface WeMyFundingSupportDetailViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) WeFundingSupport * currentFundingSupport;
@property(nonatomic, strong) WeFundingLevel * currentLevel;
@property(nonatomic, strong) WeFunding * currentFunding;

@end
