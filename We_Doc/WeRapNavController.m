//
//  WeRapNavController.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-27.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeRapNavController.h"

@interface WeRapNavController ()

@end

@implementation WeRapNavController

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
    
    NSLog(@"!!!!!");
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationController.navigationBar.alpha = 0.7f;
    self.navigationController.navigationBar.translucent = YES;
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
