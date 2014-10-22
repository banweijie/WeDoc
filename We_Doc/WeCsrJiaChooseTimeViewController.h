//
//  WeCsrJiaChooseTimeViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-7-15.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"

@interface WeCsrJiaChooseTimeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableString * dates;
@property(nonatomic, strong) NSMutableString * datesToDemo;
@property(nonatomic,strong) NSString *paintTime;
@end