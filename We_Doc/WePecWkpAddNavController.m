//
//  WePecWkpAddNavController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-20.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WePecWkpAddNavController.h"
#import "WeAppDelegate.h"

@interface WePecWkpAddNavController ()

@end

@implementation WePecWkpAddNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.translucent = YES;
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"texture"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setAlpha:0.9];
    [self.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      UIColorFromRGB(255, 255, 255, 1), NSForegroundColorAttributeName,
      [UIFont fontWithName:@"HeiTi SC-medium" size:18], NSFontAttributeName,
      nil
      ]
     ];
    self.navigationBar.TintColor = We_foreground_white_general;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 调整状态栏显示风格
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
