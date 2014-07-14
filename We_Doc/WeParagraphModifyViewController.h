//
//  WeParagraphModifyViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-6-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeAppDelegate.h"

@interface WeParagraphModifyViewController : UIViewController <UITextViewDelegate>

@property(nonatomic, strong) NSMutableString * stringToModify;
@property(nonatomic) NSString * stringToPlaceHolder;
@property(nonatomic) NSString * stringToBeTitle;


@end
