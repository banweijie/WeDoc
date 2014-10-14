//
//  WeDetailImageViewController.m
//  We_Doc
//
//  Created by ejren on 14-10-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeDetailImageViewController.h"

@interface WeDetailImageViewController ()
{
    UIActivityIndicatorView *sys_pendingView;
}
@end

@implementation WeDetailImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButton_onPress:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.edgesForExtendedLayout=UIRectEdgeAll;
    UIView *vo=[[UIView alloc]initWithFrame:CGRectMake(-1, -1, 1, 1)];
    [self.view addSubview:vo];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 2.5;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_scrollView];
    
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    [sys_pendingView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [sys_pendingView.layer setCornerRadius:10];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
    
    _imgView = [[UIImageView alloc] initWithFrame:_scrollView.frame];
    _imgView.userInteractionEnabled = YES;
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    if (_message.detImageContent==nil) {
        _imgView.image=_message.imageContent;
        if (![_message.senderId isEqualToString:currentUser.userId]) {
            [self loadDetailImage];
        }
    }
    else
    {
        _imgView.image=_message.detImageContent;
    }
    [_scrollView addSubview:_imgView];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOutOrIn:)];
    doubleTap.numberOfTapsRequired = 2;
    [_imgView addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenOrShow:)];
    [_imgView addGestureRecognizer:singleTap];
    
    
    // 双击时忽略掉单击事件
    [singleTap requireGestureRecognizerToFail:doubleTap];

    
    
   

    
}

-(void)loadDetailImage
{
    [sys_pendingView startAnimating];

    [WeAppDelegate DownloadImageWithURL:yijiarenImageUrl(_message.content)
                      successCompletion:^(id image) {
                          _message.detImageContent = (UIImage *)image;
                          _imgView.image=_message.detImageContent;
                          [globalHelper updateToDB:_message where:nil];
                          [sys_pendingView stopAnimating];

                      }];
 
}

#pragma mark - ScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView//option健进行缩放
{
    return _imgView;
}

#pragma mark - target Method
- (void)zoomOutOrIn:(UITapGestureRecognizer *)tap//双击进行缩放
{
    // 获取到用户点击位置
    CGPoint point = [tap locationInView:_imgView];
    
    // NSLog(@"%@", NSStringFromCGPoint(point));
    
    if (_scrollView.zoomScale == 1) {
        
        [_scrollView zoomToRect:CGRectMake(point.x-40, point.y-40, 80, 80) animated:YES];
        
    }else {
        [_scrollView setZoomScale:1 animated:YES];
    }
}
-(void)hidenOrShow:(UITapGestureRecognizer *)tap
{
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}
-(void)cancelButton_onPress:(UIBarButtonItem *)but
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
