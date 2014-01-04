//
//  BTGirthViewController.h
//  AddingBand
//
//  Created by wangpeng on 13-12-3.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//


/**
 *  此页是腹围页面
 */
#import <UIKit/UIKit.h>
#import "BTScrollViewController.h"
@class BTSheetPickerview;
@class BTNavicationController;
@interface BTGirthViewController : BTScrollViewController<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *weightField;//输入框
@property (nonatomic, strong) UILabel *weightConditionLabel;
@property (nonatomic,strong)BTNavicationController *nav;//设置成属性 要不然会deallocated
//输入体重 选择器
@property(nonatomic,strong)BTSheetPickerview *actionSheetView;
@end
