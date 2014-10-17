//
//  WeAboutDownViewController.m
//  AplusDr
//
//  Created by ejren on 14-10-17.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeAboutDownViewController.h"

@interface WeAboutDownViewController ()

@end

@implementation WeAboutDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *but=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem=but;
    // Background
    
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"yisheng.jpg"];
    bg.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bg];

}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
