//
//  BTBarMarkView.m
//  AddingBand
//
//  Created by wangpeng on 13-12-13.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTBarMarkView.h"
#import "LayoutDef.h"
@implementation BTBarMarkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        self.aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
        //_aImageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:_aImageView];
        
        
        self.markLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _markLabel.textColor = kGlobalColor;
        _markLabel.numberOfLines = 0;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_1
        // iPhone OS SDK 6.0 及其以后版本的处理
        self.markLabel.textAlignment = NSTextAlignmentCenter;
        self.markLabel.lineBreakMode = NSLineBreakByWordWrapping;
#else
        // iPhone OS SDK 6.0 之前版本的处理
        self.markLabel.textAlignment = UITextAlignmentCenter;
        self.markLabel.lineBreakMode =UILineBreakModeWordWrap;
        [bar.titleLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
 
#endif
        
        _markLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_markLabel];

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
