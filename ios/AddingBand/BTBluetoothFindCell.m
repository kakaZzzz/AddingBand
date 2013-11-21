//
//  BTBluetoothFindCell.m
//  AddingBand
//
//  Created by kaka' on 13-11-7.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTBluetoothFindCell.h"
#import "LayoutDef.h"
#import "BTColor.h"

#define titleLabelX 20
#define titleLabelY 10
#define titleLabelWidth 200
#define titleLabelHeight 30



#define lineImageX 0
#define lineImageY 50
#define lineImageWidth 320
#define lineImageHeight 1

#define indicateX  300
#define indicateY  19
#define indicateWidth  10
#define indicateHeight 10

#define titleLabelColor @"333333"

@implementation BTBluetoothFindCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createCustomCell];
    }
    return self;
}

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tatget:(id)target
//{
//    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
////        self.toConnect =[UIButton buttonWithType:UIButtonTypeRoundedRect];
////        _toConnect.frame = CGRectMake(kLastSyncTimeX, kLastSyncTimeY, kLastSyncTimeWidth, kLastSyncTimeHeight);
////        [_toConnect setTitle:@"立即连接" forState:UIControlStateNormal];
////        [_toConnect addTarget:target action:@selector(toConnect:event:) forControlEvents:UIControlEventTouchUpInside];
////        [self addSubview:_toConnect];
//        
//    }
//    return self;
//    
//}
//配置cell内容
- (void)createCustomCell
{
    // self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"settingcell_bg.png"]];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX,titleLabelY, titleLabelWidth, titleLabelHeight)];
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    _titleLabel.textColor = [BTColor getColor:titleLabelColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.opaque = NO;
    [self.contentView addSubview:_titleLabel];
    
    
    
    self.lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sep_line.png"]];
    _lineImage.frame = CGRectMake(lineImageX, lineImageY, lineImageWidth, lineImageHeight);
    [self.contentView addSubview:_lineImage];
    
    self.indicateImage = [[UIImageView alloc] initWithFrame:CGRectMake(indicateX, indicateY, indicateWidth, indicateHeight)];
    _indicateImage.image = [UIImage imageNamed:@"indicate.png"];
    [self.contentView addSubview:_indicateImage];
    
     
    
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
