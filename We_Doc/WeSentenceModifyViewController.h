//
//  WeSentenceModifyViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-6-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"

@interface WeSentenceModifyViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableString * stringToModify;
@property(nonatomic) NSString * stringToPlaceHolder;
@property(nonatomic) NSString * stringToBeTitle;

@end
