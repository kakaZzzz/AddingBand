//
//  BTUndoCell.h
//  AddingBand
//
//  Created by kaka' on 13-11-2.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTMainSuperCell.h"
@interface BTUndoCell : BTMainSuperCell
@property(nonatomic,strong)UIImageView *contentImageView;//内容气泡图片
@property(nonatomic,strong)UILabel *contentLabel;//内容Label
@property(nonatomic,assign) float timeLineHeight;//内容Label


+ (CGFloat)cellHeight:(NSString *)content;
@end
