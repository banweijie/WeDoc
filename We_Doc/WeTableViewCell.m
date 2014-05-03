//
//  WeTableViewCell.m
//  We_Doc
//
//  Created by WeDoctor on 14-4-19.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import "WeTableViewCell.h"

@implementation WeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //self.imageView.frame = CGRectMake(self.imageView.frame.origin.x,self.imageView.frame.origin.x,20,20);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addSubview:(UIView *)view
{
    // The separator has a height of 0.5pt on a retina display and 1pt on non-retina.
    // Prevent subviews with this height from being added.
    [super addSubview:view];
    if (CGRectGetHeight(view.frame)*[UIScreen mainScreen].scale == 1)
    {
        return;
    }
    
}

/*
- (void)layoutSubviews
{
    CGRect b = [self bounds];
    b.size.height -= 1; // leave room for the separator line
    b.size.width += 30; // allow extra width to slide for editing
    b.origin.x -= (self.editing) ? 0 : 30; // start 30px left unless editing
    [self.contentView setFrame:b];
    [super layoutSubviews];
}*/

@end
