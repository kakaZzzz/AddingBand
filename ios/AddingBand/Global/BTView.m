//
//  BTView.m
//  AddingBand
//
//  Created by wangpeng on 13-12-26.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTView.h"
#import "LayoutDef.h"
@implementation BTView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.separationLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seperator_line"]];
        _separationLine.frame = CGRectMake(4, self.frame.size.height - kSeparatorLineHeight, (320 - 4*2), kSeparatorLineHeight);
        [self addSubview:_separationLine];
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

@end
