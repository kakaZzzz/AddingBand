//
//  BTModifyDateViewController.h
//  AddingBand
//
//  Created by wangpeng on 13-12-31.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTSheetPickerview.h"
@interface BTModifyDateViewController : UIViewController<BTSheetPickerviewDelegate>
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UILabel *dateTextLabel;
@property(nonatomic,assign)int modifyType;
// 选择器
@property(nonatomic,strong)BTSheetPickerview *actionSheetView;

@end
