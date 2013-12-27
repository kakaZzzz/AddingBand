//
//  BTPhysicalCell.h
//  BTTestCollectionView
//
//  Created by wangpeng on 13-12-26.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTPhysicalModel.h"
@interface BTPhysicalCell : UIButton
@property(nonatomic,strong)UILabel *kTitleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *warnImage;
@property(nonatomic,strong)UIImageView *noDataImage;
@property(nonatomic,strong)UILabel *conditiontLabel;
//数据
@property(nonatomic,strong)BTPhysicalModel *physicalModel;

//- (void)layoutSubviewsWithModel;
@end
