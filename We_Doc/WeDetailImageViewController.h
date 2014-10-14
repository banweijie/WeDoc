//
//  WeDetailImageViewController.h
//  We_Doc
//
//  Created by ejren on 14-10-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeMessage.h"
#import "WeAppDelegate.h"

@interface WeDetailImageViewController : UIViewController<UIScrollViewDelegate>
{
    UIImageView  *_imgView;
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) WeMessage *message;

@end
