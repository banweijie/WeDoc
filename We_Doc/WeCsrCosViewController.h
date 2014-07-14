//
//  WeCsrCosViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-12.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeViewController.h"
#import "WeAppDelegate.h"

@interface WeCsrCosViewController :  WeViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(strong, nonatomic) NSString * pushType;
@property(strong, nonatomic) WeFavorDoctor * favorDoctor;

@end
