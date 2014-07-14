//
//  WeImageViewerViewController.m
//  AplusDr
//
//  Created by WeDoctor on 14-5-28.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeImageViewerViewController.h"

@interface WeImageViewerViewController () {
    UIScrollView * scrollView;
    UIImageView * imageView;
}

@end

@implementation WeImageViewerViewController

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    NSLog(@"!!!");
}

- (void)centerScrollViewContents {
    CGSize boundsSize = scrollView.bounds.size;
    CGRect contentsFrame = imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    imageView.frame = contentsFrame;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 5.0;
    scrollView.delegate = self;
    //scrollView.contentSize = CGSizeMake(900, 900);
    //scrollView.backgroundColor = [UIColor whiteColor];
    
    imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (self.imageToDemo) {
        imageView.image = self.imageToDemo;
    }
    else if (self.imageToDemoPath) {
        [imageView setImageWithURL:[NSURL URLWithString:self.imageToDemoPath]];
    }
    
    [scrollView addSubview:imageView];
    [self.view addSubview:scrollView];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [scrollView addGestureRecognizer:doubleTapRecognizer];
    
    /*
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewsingleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 1;
    doubleTapRecognizer.numberOfTouchesRequired = 1;*/
    //[scrollView addGestureRecognizer:singleTapRecognizer];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(100, self.view.frame.size.height - 60, 120, 40);
    cancelButton.tintColor = [UIColor whiteColor];
    cancelButton.backgroundColor = [UIColor colorWithRed:134 / 255.0 green:11 / 255.0 blue:38 / 255.0 alpha:1.0];
    [cancelButton setTitle:@"返回" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:16];
    cancelButton.layer.borderWidth = 1.0f;
    cancelButton.layer.borderColor = (__bridge CGColorRef)([UIColor whiteColor]);
    cancelButton.layer.cornerRadius = 5.0f;
    [cancelButton addTarget:self action:@selector(cancelButton_onPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

- (void)cancelButton_onPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewsingleTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // 1
    CGPoint pointInView = [recognizer locationInView:imageView];
    
    // 2
    CGFloat newZoomScale = scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, scrollView.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
    [scrollView zoomToRect:rectToZoomTo animated:YES];
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
