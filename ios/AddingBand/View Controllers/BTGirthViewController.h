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
@class BTSheetPickerview;
@interface BTGirthViewController : UIViewController
@property (nonatomic, strong) UILabel *weightLabel;
@property (nonatomic, strong) UILabel *weightConditionLabel;

//输入体重 选择器
@property(nonatomic,strong)BTSheetPickerview *actionSheetView;
@end
