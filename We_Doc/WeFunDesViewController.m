//
//  WeFunDesViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-22.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunDesViewController.h"

@interface WeFunDesViewController ()

@end

@implementation WeFunDesViewController

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
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 标题
    [self.navigationItem setTitle:@"众筹详情"];
    
    // 富文本内容显示
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 64 - self.tabBarController.tabBar.frame.size.height)];
    [webView loadHTMLString:_HTMLContent baseURL:[NSURL URLWithString:@"www.yijiaren.com"]];
    [self.view addSubview:webView];
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
