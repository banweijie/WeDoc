//
//  WeImageButton.m
//  AplusDr
//
//  Created by WeDoctor on 14-6-25.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeImageButton.h"

@implementation WeImageButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect tmp = self.frame;
    tmp.origin.x = 0;
    tmp.origin.y = 0;
    self.imageView.frame = tmp;
}

@end
