//
//  BTPhysicalCell.m
//  BTTestCollectionView
//
//  Created by wangpeng on 13-12-26.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import "BTPhysicalCell.h"
#import "LayoutDef.h"
//#import "LayoutDef.h"
#define titleLabelX 12
#define titleLabelY 22
#define titleLabelWidth 40
#define titleLabelHeight 20

#define contentLabelX (titleLabelX)
#define contentLabelY (titleLabelY + titleLabelHeight + 10)
#define contentLabelWidth 60
#define contentLabelHeight 30

#define warnImageX （320 - 50)
#define warnImageY （titleLabelY）
#define warnImageWidth 14
#define warnImageHeight 14

@implementation BTPhysicalCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createCustomCell];
    }
    return self;
}

//配置cell内容
- (void)createCustomCell
{
    
    //诸如体重 宫高 腹围之类的
    self.kTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelWidth, titleLabelHeight)];
    self.kTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.kTitleLabel.text = @"体重";
    self.kTitleLabel.textColor = [UIColor colorWithRed:94/255.0 green:101/255.0 blue:113/255.0 alpha:1.0];
    self.kTitleLabel.font = [UIFont systemFontOfSize:17.0f];
  //  self.kTitleLabel.backgroundColor = [UIColor redColor];
     self.kTitleLabel.opaque = NO;
    [self addSubview:self.kTitleLabel];
    
    //提醒图片
    self.warnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prhysical_!"]];
  //  _warnImage.backgroundColor = [UIColor grayColor];
    _warnImage.frame = CGRectMake(titleLabelX  + titleLabelWidth, titleLabelY + 2, warnImageWidth, warnImageHeight);
    [self addSubview:_warnImage];

    
    
    //内容 诸如72 kg的72
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX, contentLabelY, contentLabelWidth, contentLabelHeight)];
    self.contentLabel.text = @"72.0";
    _contentLabel.font = [UIFont systemFontOfSize:30.0f];
   // _contentLabel.backgroundColor = [UIColor blueColor];

    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.opaque = NO;
    [self addSubview:_contentLabel];
    
    
    
    
    self.conditiontLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabelX + contentLabelWidth, contentLabelY + contentLabelHeight - 20, 25, 20)];
   // _conditiontLabel.backgroundColor = [UIColor greenColor];
    _conditiontLabel.text = @"kg";
    _conditiontLabel.font = [UIFont systemFontOfSize:17.0f];
    _conditiontLabel.textAlignment = NSTextAlignmentLeft;
   
    _conditiontLabel.textColor = [UIColor colorWithRed:94/255.0 green:101.0/255.0 blue:113/255.0 alpha:1.0];
    _conditiontLabel.opaque = NO;
    [self addSubview:_conditiontLabel];
    
    
    //没有数据图片
    self.noDataImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"physical_nodata_icon"]];
    // _noDataImage.backgroundColor = [UIColor grayColor];
    _noDataImage.frame = CGRectMake(_contentLabel.frame.origin.x , _contentLabel.frame.origin.y, contentLabelHeight, contentLabelHeight);
    _noDataImage.hidden = YES;
    [self addSubview:_noDataImage];

    
    
    
}
- (void)setPhysicalModel:(BTPhysicalModel *)physicalModel
{
    if ([_physicalModel.title isEqualToString:physicalModel.title] && [_physicalModel.content isEqualToString:physicalModel.content]) {
        return;
    }
    else{
       _physicalModel = physicalModel;
        
        //下面根据数据重新调整视图布局
        
        
        if ([_physicalModel.title isEqualToString:@"体重"]) {
            
            if ([_physicalModel.content floatValue] == 0.0) {
                
                self.contentLabel.hidden = YES;
                self.conditiontLabel.hidden = YES;
                self.noDataImage.hidden = NO;
                self.warnImage.hidden = NO;
                self.warnImage.image = [UIImage imageNamed:@"physical_?"];
            }
            else{
                if ([_physicalModel.content floatValue] > 20.0 || [_physicalModel.content floatValue] < 5.0) {
                    
                    self.contentLabel.hidden = NO;
                    self.conditiontLabel.hidden = NO;
                    self.noDataImage.hidden = YES;
                     self.warnImage.hidden = NO;
                    self.contentLabel.textColor = kGlobalColor;
                    self.conditiontLabel.textColor = kGlobalColor;
                }
                else{
                    self.contentLabel.hidden = NO;
                    self.conditiontLabel.hidden = NO;
                    self.noDataImage.hidden = YES;
                    self.warnImage.hidden = YES;
                    self.contentLabel.textColor = [UIColor colorWithRed:94/255.0 green:101.0/255.0 blue:113/255.0 alpha:1.0];
                }

            }
              self.conditiontLabel.text = @"kg";
        }
        
        else if ([_physicalModel.title isEqualToString:@"宫高"])
        {
            
            if ([_physicalModel.content floatValue] == 0.0) {
                
                self.contentLabel.hidden = YES;
                self.conditiontLabel.hidden = YES;
                self.noDataImage.hidden = NO;
                 self.warnImage.hidden = NO;
                self.warnImage.image = [UIImage imageNamed:@"physical_?"];
            }
            else{
                if ([_physicalModel.content floatValue] > 20.0 || [_physicalModel.content floatValue] < 5.0) {
                    
                    self.contentLabel.hidden = NO;
                    self.conditiontLabel.hidden = NO;
                    self.noDataImage.hidden = YES;
                     self.warnImage.hidden = NO;
                    self.contentLabel.textColor = kGlobalColor;
                    self.conditiontLabel.textColor = kGlobalColor;
                }
                else{
                    self.contentLabel.hidden = NO;
                    self.conditiontLabel.hidden = NO;
                    self.noDataImage.hidden = YES;
                     self.warnImage.hidden = YES;
                    self.contentLabel.textColor = [UIColor colorWithRed:94/255.0 green:101.0/255.0 blue:113/255.0 alpha:1.0];
                }
                
            }

             self.conditiontLabel.text = @"cm";
        }
        
        else if ([_physicalModel.title isEqualToString:@"腹围"])
        {
            if ([_physicalModel.content floatValue] == 0.0) {
                
                self.contentLabel.hidden = YES;
                self.conditiontLabel.hidden = YES;
                self.noDataImage.hidden = NO;
                self.warnImage.hidden = NO;
                self.warnImage.image = [UIImage imageNamed:@"physical_?"];
            }
            else{
                if ([_physicalModel.content floatValue] > 20.0 || [_physicalModel.content floatValue] < 5.0) {
                    
                    self.contentLabel.hidden = NO;
                    self.conditiontLabel.hidden = NO;
                    self.noDataImage.hidden = YES;
                    self.warnImage.hidden = NO;
                    self.contentLabel.textColor = kGlobalColor;
                    self.conditiontLabel.textColor = kGlobalColor;
                }
                else{
                    self.contentLabel.hidden = NO;
                    self.conditiontLabel.hidden = NO;
                    self.noDataImage.hidden = YES;
                    self.warnImage.hidden = YES;
                    self.contentLabel.textColor = [UIColor colorWithRed:94/255.0 green:101.0/255.0 blue:113/255.0 alpha:1.0];
                }
                
            }

            
            self.conditiontLabel.text = @"cm";
        }
        
        else if ([_physicalModel.title isEqualToString:@"B超"])
        {
            
            if ([_physicalModel.content isEqualToString:@"正常"]) {
                
                [self.contentLabel setHidden:NO];
                [self.conditiontLabel setHidden:YES];
                self.noDataImage.hidden = YES;
                self.warnImage.hidden = YES;
                self.contentLabel.textColor = [UIColor colorWithRed:94/255.0 green:101.0/255.0 blue:113/255.0 alpha:1.0];
            }
            
            else if ([_physicalModel.content isEqualToString:@"异常"])
            {
                [self.contentLabel setHidden:NO];
                [self.conditiontLabel setHidden:YES];
                self.noDataImage.hidden = YES;
                self.warnImage.hidden = NO;
                self.contentLabel.textColor = self.contentLabel.textColor = kGlobalColor;
            }
            else{
                self.warnImage.image = [UIImage imageNamed:@"physical_?"];
                [self.contentLabel setHidden:YES];
                [self.conditiontLabel setHidden:YES];
                self.noDataImage.hidden = NO;
                self.warnImage.hidden = NO;

            }
            
        }
        
        else if ([_physicalModel.title isEqualToString:@"血压"])
        {
            if ([_physicalModel.title isEqualToString:@""]) {
                self.contentLabel.hidden = YES;
                [self.conditiontLabel setHidden:YES];
                self.noDataImage.hidden = NO;
                self.warnImage.hidden = NO;
                self.warnImage.image = [UIImage imageNamed:@"physical_?"];
            }
            else{
                
                self.contentLabel.hidden = NO;
                [self.conditiontLabel setHidden:YES];
                self.noDataImage.hidden = YES;
                self.warnImage.hidden =YES;
                self.contentLabel.font = [UIFont systemFontOfSize:20];
                CGRect rect = self.contentLabel.frame;
                self.contentLabel.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + 50, rect.size.height);
                self.contentLabel.textColor = [UIColor colorWithRed:94/255.0 green:101.0/255.0 blue:113/255.0 alpha:1.0];
                

            }

        }

        self.kTitleLabel.text = self.physicalModel.title;
        self.contentLabel.text = self.physicalModel.content;
        NSLog(@"拉拉拉拉拉拉阿拉拉拉");
    }
    
}

@end
