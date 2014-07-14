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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
