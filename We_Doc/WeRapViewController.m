//
//  WeRapViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-27.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeRapViewController.h"
#import "WeAppDelegate.h"

@interface WeRapViewController ()

@end

@implementation WeRapViewController

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
    // Do any additional setup after loading the view.
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = YES;
    
    UIButton * user_register = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [user_register.layer setFrame:CGRectMake(-1, 1, 322, 45)];
    [user_register setTitle:@"初次使用？现在注册" forState:UIControlStateNormal];
    [user_register setBackgroundColor:UIColorFromRGB(134, 11, 38, 1)];
    [user_register setTintColor:UIColorFromRGB(255, 255, 255, 1)];
    [self.view addSubview:user_register];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
