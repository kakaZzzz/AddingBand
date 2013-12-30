//
//  BTHeightViewController.h
//  AddingBand
//
//  Created by wangpeng on 13-12-3.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

/**
 *  此页是宫高页面
 */
#import <UIKit/UIKit.h>
@class BTSheetPickerview;
@class PCLineChartView;
@interface BTHeightViewController : UIViewController
@property (nonatomic, strong) UILabel *weightLabel;
@property (nonatomic, strong) UILabel *weightConditionLabel;

//输入宫高 选择器
@property(nonatomic,strong)BTSheetPickerview *actionSheetView;
@end
