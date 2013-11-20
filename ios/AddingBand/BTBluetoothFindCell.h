//
//  BTBluetoothFindCell.h
//  AddingBand
//
//  Created by kaka' on 13-11-7.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTBluetoothLinkCell.h"

@interface BTBluetoothFindCell : UITableViewCell
@property(nonatomic,strong)UIButton *toConnect;//立即连接按钮
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *indicateImage;
@property(nonatomic,strong)UIImageView *lineImage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tatget:(id)target;

@end
