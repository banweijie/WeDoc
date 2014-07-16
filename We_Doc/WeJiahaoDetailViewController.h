//
//  WeJiahaoDetailViewController.h
//  We_Doc
//
//  Created by WeDoctor on 14-7-16.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"
#import "WeJiahao.h"

@interface WeJiahaoDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) WeJiahao * currentJiahao;

@end
