//
//  MyCollectionViewCell.m
//  Portfolio
//
//  Created by Safin Ahmed on 16/03/14.
//  Copyright (c) 2014 Safin Ahmed. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"init %f %f ",frame.origin.x,frame.origin.y);
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.imageViewBackgroundImage.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = [UIColor blueColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
