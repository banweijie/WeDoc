//
//  WeViewController.h
//  We_Doc
//
//  Created by WeDoctor on 14-4-27.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeInfoedTextField.h"

@interface WeViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic, strong) UITableView * sys_tableView;
@property(nonatomic) CGFloat sys_tableView_originHeight;

@end
