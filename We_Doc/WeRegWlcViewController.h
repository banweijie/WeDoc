//
//  WeWelcomeViewController.h
//  We_Doc
//
//  Created by WeDoctor on 14-4-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeViewController.h"
#import "WeRegIpnViewController.h"

@interface WeRegWlcViewController : WeViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIViewController * originTargetViewController;
@property (nonatomic, strong) UITabBarController * tabBarController;

- (void)api_user_login:(NSString *)phone password:(NSString *)password;

@end

