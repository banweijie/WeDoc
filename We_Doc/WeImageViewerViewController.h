//
//  WeImageViewerViewController.h
//  AplusDr
//
//  Created by WeDoctor on 14-5-28.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

@interface WeImageViewerViewController : UIViewController <UIScrollViewDelegate>

@property(strong, nonatomic) UIImage * imageToDemo;
@property(strong, nonatomic) NSString * imageToDemoPath;

@end
