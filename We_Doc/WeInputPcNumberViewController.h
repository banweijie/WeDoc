//
//  WeInputPcNumberViewController.h
//  We_Doc
//
//  Created by WeDoctor on 14-8-1.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"

@interface WeInputPcNumberViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property(nonatomic) NSString * stringToPlaceHolder;
@property(nonatomic) NSString * stringToBeTitle;


@end
