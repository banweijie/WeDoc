//
//  WeFunSelTopSecViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-6-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"
#import "WeFunSelSecSecViewController.h"

@interface WeFunSelTopSecViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableString * lastSel_topSectionId;
@property(nonatomic, strong) NSMutableString * lastSel_topSectionName;
@property(nonatomic, strong) NSMutableString * lastSel_secSectionId;
@property(nonatomic, strong) NSMutableString * lastSel_secSectionName;

@end
