//
//  BTBluetoothFindCell.h
//  AddingBand
//
//  Created by kaka' on 13-11-7.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTBluetoothLinkCell.h"

@interface BTBluetoothFindCell : BTBluetoothLinkCell
@property(nonatomic,strong)UIButton *toConnect;//立即连接按钮

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tatget:(id)target;
@end
