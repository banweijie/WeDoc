//
//  WeFunIdxViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-6-20.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"
#import "WeFunding.h"
#import "WeFunDetViewController.h"
#import "WeFunSelViewController.h"

@interface WeFunIdxViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

- (void)api_data_listFunding;

@end
