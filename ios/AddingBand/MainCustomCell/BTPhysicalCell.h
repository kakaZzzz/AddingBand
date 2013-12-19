//
//  BTPhysicalCell.h
//  AddingBand
//
//  Created by wangpeng on 13-12-17.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTPhisicalModel.h"
@interface BTPhysicalCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *lineImage;
@property(nonatomic,strong)UIImageView *warnImage;
@property(nonatomic,strong)UIImageView *accessoryImage;
@property(nonatomic,strong)UILabel *conditiontLabel;
@property(nonatomic,strong)BTPhisicalModel *physicalModel;
@end
