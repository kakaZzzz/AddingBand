//
//  BTPhysicalCell.m
//  AddingBand
//
//  Created by wangpeng on 13-12-17.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTPhysicalCell.h"
#import "BTColor.h"
#import "LayoutDef.h"
#define titleLabelX 20
#define titleLabelY 7
#define titleLabelWidth 60
#define titleLabelHeight 30

#define contentLabelX (titleLabelX + titleLabelWidth)
#define contentLabelY (titleLabelY)
#define contentLabelWidth 60
#define contentLabelHeight 30

#define warnImageX （320 - 50)
#define warnImageY （titleLabelY）
#define warnImageWidth 30
#define warnImageHeight 30

#define titleLabelColor @"333333"
#define contentLabelColor @"999999"
@implementation BTPhysicalCell

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
    // self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"settingcell_bg.png"]];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX,titleLabelY, titleLabelWidth, titleLabelHeight)];
    _titleLabel.font = [UIFont systemFontOfSize:17.0f];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = kBigTextColor;
   // _titleLabel.backgroundColor = [UIColor blueColor];
    _titleLabel.opaque = NO;
    [self.contentView addSubview:_titleLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelWidth, contentLabelHeight)];
    _contentLabel.font = [UIFont systemFontOfSize:17.0f];
    _contentLabel.backgroundColor = [UIColor clearColor];

    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.textColor = [BTColor getColor:contentLabelColor];
   // _contentLabel.backgroundColor = [UIColor redColor];
    _contentLabel.opaque = NO;
    [self.contentView addSubview:_contentLabel];
    
    
    
    self.warnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning.png"]];
    _warnImage.frame = CGRectMake(220, 7, warnImageWidth, warnImageHeight);
    [self.contentView addSubview:_warnImage];
    
    self.conditiontLabel = [[UILabel alloc] initWithFrame:CGRectMake(_warnImage.frame.origin.x + _warnImage.frame.size.width, contentLabelY, contentLabelWidth, contentLabelHeight)];
    _conditiontLabel.backgroundColor = [UIColor clearColor];

    _conditiontLabel.font = [UIFont systemFontOfSize:17.0f];
    _conditiontLabel.textAlignment = NSTextAlignmentLeft;
    _conditiontLabel.textColor = kBigTextColor;
   //  _conditiontLabel.backgroundColor = [UIColor redColor];
    _conditiontLabel.opaque = NO;
    [self.contentView addSubview:_conditiontLabel];

    self.accessoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_blue@2x"]];
    _accessoryImage.frame = CGRectMake(320 - 20, 11.5, 20, 20);
    [self.contentView addSubview:_accessoryImage];

    
}
- (void)layoutSubviews
{
    
    if ([_physicalModel.title isEqualToString:@"运动量"]) {
        
    
        float step = [_physicalModel.content floatValue];
        NSLog(@"体重是---------%f",step);

        if (step < 100.0 ) {
            _contentLabel.textColor = [UIColor colorWithRed:66/255.0 green:156/255.0 blue:239/255.0 alpha:1.0];
            _conditiontLabel.textColor = [UIColor colorWithRed:66/255.0 green:156/255.0 blue:239/255.0 alpha:1.0];
             _warnImage.hidden = YES;
            _conditiontLabel.text = @"未完成";

        }
        if (step == 100.0) {
            _contentLabel.textColor =  kBigTextColor;
             _warnImage.hidden = YES;
            _conditiontLabel.text = @"完成";
            _accessoryImage.image = [UIImage imageNamed:@"accessory_gray@2x"];
        }
        if (step > 100.0) {
            _contentLabel.textColor =  kGlobalColor;
            _conditiontLabel.textColor =  kGlobalColor;
             _warnImage.hidden = YES;
            _conditiontLabel.text = @"多了";
             _accessoryImage.image = [UIImage imageNamed:@"accessory_red@2x"];
        }
    }
    
    if ([_physicalModel.title isEqualToString:@"体   重"]) {
        float weight = [_physicalModel.content floatValue];
    
        if (weight < 75.0 ) {
             _contentLabel.textColor =  kGlobalColor;
            _conditiontLabel.textColor =  kGlobalColor;
            _conditiontLabel.text = @"偏低";
             _accessoryImage.image = [UIImage imageNamed:@"accessory_red@2x"];
            
        }
       else if (weight >= 75.0 && weight <= 80.0) {
            _warnImage.hidden = YES;
           _contentLabel.textColor =  kBigTextColor;
            _conditiontLabel.text = @"正常";
           _accessoryImage.image = [UIImage imageNamed:@"accessory_gray@2x"];


        }
        else {
            
             _contentLabel.textColor =  kGlobalColor;
            _conditiontLabel.textColor =  kGlobalColor;
             _conditiontLabel.text = @"偏高";
             _accessoryImage.image = [UIImage imageNamed:@"accessory_red@2x"];
        }

        
    }

   if ([_physicalModel.title isEqualToString:@"宫   高"]) {
       float weight = [_physicalModel.content floatValue];
       
       if (weight < 18.0 ) {
           _contentLabel.textColor =  kGlobalColor;
           _conditiontLabel.textColor =  kGlobalColor;
                      _conditiontLabel.text = @"偏低";
            _accessoryImage.image = [UIImage imageNamed:@"accessory_red@2x"];

       }
       else if (weight >= 18.0 && weight <= 20.0) {
            _warnImage.hidden = YES;
           _contentLabel.textColor =  kBigTextColor;
           _conditiontLabel.text = @"正常";
           _accessoryImage.image = [UIImage imageNamed:@"accessory_gray@2x"];
       }
       else {
           
           _contentLabel.textColor =  kGlobalColor;
           _conditiontLabel.textColor =  kGlobalColor;
           _conditiontLabel.text = @"偏高";
           
            _accessoryImage.image = [UIImage imageNamed:@"accessory_red@2x"];
       }

    }

    if ([_physicalModel.title isEqualToString:@"腹   围"]) {
        float weight = [_physicalModel.content floatValue];
        
        if (weight < 70.0 ) {
            _contentLabel.textColor =  kGlobalColor;
            _conditiontLabel.textColor =  kGlobalColor;
           _conditiontLabel.text = @"偏低";
             _accessoryImage.image = [UIImage imageNamed:@"accessory_red@2x"];
        }
        else if (weight >= 70.0 && weight <= 90.0) {
             _warnImage.hidden = YES;
            _contentLabel.textColor =  kBigTextColor;
            
            _conditiontLabel.text = @"正常";
            _accessoryImage.image = [UIImage imageNamed:@"accessory_gray@2x"];
        }
        else {
            
            _contentLabel.textColor =  kGlobalColor;
            _conditiontLabel.textColor =  kGlobalColor;
            _conditiontLabel.text = @"偏高";
             _accessoryImage.image = [UIImage imageNamed:@"accessory_red@2x"];
        }

    }

    if ([_physicalModel.title isEqualToString:@"血   糖"]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_undata_bg@2x"]];
        _warnImage.hidden = YES;
        _contentLabel.text = @"";
        _conditiontLabel.text = @"请更新";
        _accessoryImage.image = [UIImage imageNamed:@"accessory_red@2x"];

        _conditiontLabel.textColor = kGlobalColor;
        
    }

    if ([_physicalModel.title isEqualToString:@"血   压"]) {
        
         _warnImage.hidden = YES;
         _conditiontLabel.text = @"正常";
        _accessoryImage.image = [UIImage imageNamed:@"accessory_gray@2x"];
    }

   
    _titleLabel.text = _physicalModel.title;
    _contentLabel.text = _physicalModel.content;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
