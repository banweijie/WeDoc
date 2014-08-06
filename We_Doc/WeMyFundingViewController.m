//
//  WeMyFundingViewController.m
//  We_Doc
//
//  Created by WeDoctor on 14-8-6.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeMyFundingViewController.h"

@interface WeMyFundingViewController () {
    UIActivityIndicatorView * sys_pendingView;
    UITableView * sys_tableView;
    UIButton * refreshButton;
    
    NSMutableArray * fundingList;
}

@end

@implementation WeMyFundingViewController

#pragma mark - View related

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景图片
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"Background-2"];
    bg.contentMode = UIViewContentModeCenter;
    [self.view addSubview:bg];
    
    // 刷新按钮
    refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshButton.frame = self.view.frame;
    [refreshButton setTitle:@"获取加号记录列表失败，点击刷新" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButton_onPress) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTintColor:We_foreground_red_general];
    [self.view addSubview:refreshButton];
    
    [self api_doctor_listFunding];
}

#pragma mark - Callbacks

- (void)refreshButton_onPress {
    [self api_doctor_listFunding];
}

#pragma mark - APIs

- (void)api_doctor_listFunding {
    [sys_pendingView startAnimating];
    [refreshButton setHidden:YES];
    [sys_tableView setHidden:YES];
    
    [WeAppDelegate postToServerWithField:@"doctor"
                                  action:@"listFunding"
                              parameters:nil
                                 success:^(id response) {
                                     fundingList = [[NSMutableArray alloc] init];
                                     for (int i = 0; i < [response count]; i++) {
                                         [fundingList addObject:[[WeFunding alloc] initWithNSDictionary:response[i]]];
                                     }
                                     
                                     [sys_tableView setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
                                 failure:^(NSString * errorMessage) {
                                     NSLog(@"\nerror:%@", errorMessage);
                                     [refreshButton setHidden:NO];
                                     [sys_pendingView stopAnimating];
                                 }
     ];
}

@end
