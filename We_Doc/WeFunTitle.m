//
//  WeFunTitle.m
//  AplusDr
//
//  Created by ejren on 14-10-20.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeFunTitle.h"

@implementation WeFunTitle

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bf=self.titleLabel.frame;
    self.titleLabel.frame=CGRectMake(bf.origin.x-20, 0, self.frame.size.width-10, self.frame.size.height);
    
    self.imageView.center=CGPointMake(bf.size.width+30, self.imageView.center.y);
}
@end
