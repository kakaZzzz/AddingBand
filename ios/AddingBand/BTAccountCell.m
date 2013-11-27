//
//  BTAccountCell.m
//  AddingBand
//
//  Created by kaka' on 13-11-25.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTAccountCell.h"
#import "BTColor.h"

#define kTop 20
#define kLeft ((320 - 265)/2)
#define kWidth 55
#define kHeight 55
#define titleLabelColor @"999999"
@implementation BTAccountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createCustomCell];
    }
    return self;
}
//配置cell内容
- (void)createCustomCell
{
    //新浪账号
    self.aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _aButton.frame = CGRectMake(kLeft, kTop, kWidth, kHeight);
    [_aButton setBackgroundImage:[UIImage imageNamed:@"sina.png"] forState:UIControlStateNormal];
    [_aButton setBackgroundImage:[UIImage imageNamed:@"sina_sel.png"] forState:UIControlStateHighlighted];
    [_aButton addTarget:self action:@selector(selectSina) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_aButton];
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeft, _aButton.frame.origin.y + _aButton.frame.size.height , kWidth, kHeight - 10)];
    aLabel.textColor = [BTColor getColor:titleLabelColor];
    aLabel.text = @"已绑定";
    [self addSubview:aLabel];
    
    
    //腾讯账号
    self.bButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _bButton.frame = CGRectMake(_aButton.frame.origin.x + _aButton.frame.size.width + 50, kTop, kWidth, kHeight);
    [_bButton setBackgroundImage:[UIImage imageNamed:@"tecent.png"] forState:UIControlStateNormal];
    [_bButton setBackgroundImage:[UIImage imageNamed:@"tecent_sel.png"] forState:UIControlStateHighlighted];
    [_bButton addTarget:self action:@selector(selectTecent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bButton];
    
    UILabel *bLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bButton.frame.origin.x, _bButton.frame.origin.y + _bButton.frame.size.height , kWidth, kHeight - 10)];
     bLabel.textColor = [BTColor getColor:titleLabelColor];
    bLabel.text = @"已绑定";
    [self addSubview:bLabel];
    
    //未知账号
    self.cButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _cButton.frame = CGRectMake(_bButton.frame.origin.x + _bButton.frame.size.width + 50,kTop, kWidth, kHeight);
    [_cButton setBackgroundImage:[UIImage imageNamed:@"weizhi.png"] forState:UIControlStateNormal];
    [_cButton setBackgroundImage:[UIImage imageNamed:@"weizhi_sel.png"] forState:UIControlStateHighlighted];
    [_cButton addTarget:self action:@selector(selectWeizhi) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cButton];
    
    UILabel *cLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cButton.frame.origin.x, _cButton.frame.origin.y + _cButton.frame.size.height , kWidth, kHeight - 10)];
     cLabel.textColor = [BTColor getColor:titleLabelColor];
    cLabel.text = @"已绑定";
    [self addSubview:cLabel];


}

- (void)selectSina
{
    //用于回调
    _chooseAccountBlock(@"新浪");
}
- (void)selectTecent
{
    _chooseAccountBlock(@"腾讯");
}
- (void)selectWeizhi
{
    _chooseAccountBlock(@"未知");

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
