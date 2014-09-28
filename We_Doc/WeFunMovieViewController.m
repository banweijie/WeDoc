//
//  WeFunMovieViewController.m
//  AplusDr
//
//  Created by 袁锐 on 14-9-23.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunMovieViewController.h"

@interface WeFunMovieViewController ()

@end

@implementation WeFunMovieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playBackNotif:) name:@"MPMoviePlayerPlaybackDidFinishNotification" object:self.moviePlayer];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.moviePlayer.view];

}
-(void)playBackNotif:(NSNotification *)not
{
    MPMoviePlayerController *play=(MPMoviePlayerController*)[not object];
    [play stop];
    [play.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)shouldAutorotate
{
    return YES;
}

@end
