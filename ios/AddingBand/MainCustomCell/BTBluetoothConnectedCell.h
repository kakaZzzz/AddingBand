//
//  BTBluetoothConnectedCell.h
//  AddingBand
//
//  Created by kaka' on 13-11-7.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTBluetoothLinkCell.h"

@interface BTBluetoothConnectedCell : BTBluetoothLinkCell
@property(nonatomic,strong)UILabel *lastSyncTime;//设备上次同步时间
@property(nonatomic,strong)UIButton *toSync;//立即同步按钮

@property(nonatomic,strong)UIButton *breakConnect;//立即同步按钮
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tatget:(id)target;
@end
