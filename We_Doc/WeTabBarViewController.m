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

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (currentUser == nil && viewController != [tabBarController.viewControllers objectAtIndex:0]) {
        WeRegWlcViewController * vc = [[WeRegWlcViewController alloc] init];
        vc.originTargetViewController = viewController;
        vc.tabBarController = tabBarController;
        
        WeNavViewController * nav = [[WeNavViewController alloc] init];
        [nav pushViewController:vc animated:NO];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return NO;
    }
    /*
    if (viewController == [tabBarController.viewControllers objectAtIndex:weTabBarIdPersonalCenter] && !we_logined) {
        we_targetView = targetViewPersonalCenter;
        [self performSegueWithIdentifier:@"TabBar_Modalto_RegWlc" sender:self];
        return NO;
    }
    if (viewController == [tabBarController.viewControllers objectAtIndex:weTabBarIdConsultingRoom] && !we_logined) {
        we_targetView = targetViewConsultingRoom;
        [self performSegueWithIdentifier:@"TabBar_Modalto_RegWlc" sender:self];
        return NO;
    }
    if (viewController == [tabBarController.viewControllers objectAtIndex:weTabBarIdCaseHistory] && !we_logined) {
        we_targetView = targetViewCaseHistory;
        [self performSegueWithIdentifier:@"TabBar_Modalto_RegWlc" sender:self];
        return NO;
    }*/
    return YES;
}

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
}

- (void)viewDidAppear:(BOOL)animated {
    // Other code...
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.tabBar.selectedImageTintColor = We_foreground_red_general;
    self.tabBar.tintColor = We_foreground_red_general;
    self.tabBar.translucent = YES;
    
    /*
    UITabBarItem * tmp0 = [self.tabBar.items objectAtIndex:0];
    tmp0.selectedImage = [UIImage imageNamed:@"tab-home-selected"];
    UITabBarItem * tmp1 = [self.tabBar.items objectAtIndex:1];
    tmp1.selectedImage = [UIImage imageNamed:@"tab-chatroom-selected"];
    UITabBarItem * tmp2 = [self.tabBar.items objectAtIndex:2];
    tmp2.selectedImage = [UIImage imageNamed:@"tab-crowdfunding-selected"];
    UITabBarItem * tmp3 = [self.tabBar.items objectAtIndex:3];
    tmp3.selectedImage = [UIImage imageNamed:@"tab-casehistory-selected"];
    UITabBarItem * tmp4 = [self.tabBar.items objectAtIndex:4];
    tmp4.selectedImage = [UIImage imageNamed:@"tab-me-selected"];
    */
    [super viewWillAppear:animated];
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
