//
//  WeUserAgreeViewController.m
//  AplusDr
//
//  Created by ejren on 14-9-28.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeUserAgreeViewController.h"

@interface WeUserAgreeViewController ()
{
    UIWebView *webview;
}
@end

@implementation WeUserAgreeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title=@"用户协议";
    
    UIBarButtonItem *but=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButton)];
    self.navigationItem.leftBarButtonItem=but;
    
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    
    [self.view addSubview:webview];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURLRequest *req=[NSURLRequest requestWithURL:[NSURL URLWithString:_aggreeUrl]];
    [webview loadRequest:req];
}
-(void)backButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
