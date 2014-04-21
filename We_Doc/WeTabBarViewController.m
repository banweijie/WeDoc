//
//  WeTabBarViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-13.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeTabBarViewController.h"
#import "WeAppDelegate.h"

@interface WeTabBarViewController ()

@end

@implementation WeTabBarViewController


extern int we_targetTabId;

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
    NSLog(@"tab bar view did load at index %d", we_targetTabId);
    //[self setSelectedIndex:we_targetTabId];
}
- (void)viewDidAppear:(BOOL)animated {
    // Other code...
    //[self setSelectedIndex:1];
    [super viewDidAppear:animated];
    
    self.tabBar.selectedImageTintColor = We_foreground_red_general;
    
    UITabBarItem * tmp0 = [self.tabBar.items objectAtIndex:0];
    tmp0.selectedImage = [UIImage imageNamed:@"tab-home-selected"];
    UITabBarItem * tmp1 = [self.tabBar.items objectAtIndex:1];
    tmp1.selectedImage = [UIImage imageNamed:@"tab-chatroom-selected"];
    UITabBarItem * tmp2 = [self.tabBar.items objectAtIndex:2];
    tmp2.selectedImage = [UIImage imageNamed:@"tab-crowdfunding-selected"];
    UITabBarItem * tmp3 = [self.tabBar.items objectAtIndex:3];
    tmp3.selectedImage = [UIImage imageNamed:@"tab-me-selected"];
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
