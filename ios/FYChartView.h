//
//  FYChartView.h
//
//  sina weibo:http://weibo.com/zbflying
//
//  Created by zbflying on 13-11-27.
//  Copyright (c) 2013年 zbflying All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTPhysicalModel.h"
#define xMargin 12
#define yMargin 10
enum HorizontalTitleAlignment
{
    HorizontalTitleAlignmentLeft,
    HorizontalTitleAlignmentCenter,
    HorizontalTitleAlignmentRight
};
typedef enum BTChartStyle
{
    BTChartWeight = 0,
    BTChartFuntalHeight,
    BTChartGirth
}BTChartStyle;
typedef enum HorizontalTitleAlignment HorizontalTitleAlignment;

@class FYChartView;
@protocol FYChartViewDataSource <NSObject>

@required

/**
 *  number of item count
 */
//- (NSInteger)numberOfValueItemCountInChartView:(FYChartView *)chartView;

/**
 *  value at index
 */
//- (float)chartView:(FYChartView *)chartView valueAtIndex:(NSInteger)index;

@optional
/**
 *  description view at index
 */
- (UIView *)chartView:(FYChartView *)chartView descriptionViewAtIndex:(NSInteger)index model:(BTPhysicalModel *)model;

/**
 *  horizontal title at index
 */
//- (NSString *)chartView:(FYChartView *)chartView horizontalTitleAtIndex:(NSInteger)index;

/**
 *  horizontal title alignmentat at index
 *  default is HorizontalTitleAlignmentCenter
 */
- (HorizontalTitleAlignment)chartView:(FYChartView *)chartView horizontalTitleAlignmentAtIndex:(NSInteger)index;

@end


@protocol FYChartViewDelegate <NSObject>
@optional
/**
 *  when touched and did moved to index
 */
- (void)chartView:(FYChartView *)chartView didMovedToIndex:(NSInteger)index;

@end


@interface FYChartView : UIView
/**
 *  数据来源
 */
@property (nonatomic, retain) NSArray *modelArray;
/**
 *  上限
 */
@property (nonatomic, retain) NSArray *onLimit;
/**
 *  下限
 */
@property (nonatomic, retain) NSArray *offLimit;

@property (nonatomic, assign) BTChartStyle style;
/**
 *  rectangle line color
 *  default is blackColor
 */
@property (nonatomic, retain) UIColor *rectangleLineColor;

/**
 *  rectangle line width
 *  default is 1.0f
 */
@property (nonatomic, assign) float rectanglelineWidth;

/**
 *  line color
 *  default is blackColor
 */
@property (nonatomic, retain) UIColor *lineColor;

/**
 *  line width
 *  default is 1.0f
 */
@property (nonatomic, assign) float lineWidth;

/**
 *  hide description view when touches end
 *  default is NO
 */
@property (nonatomic, assign) BOOL hideDescriptionViewWhenTouchesEnd;

/**
 * chart view data source
 */
@property (nonatomic, assign) IBOutlet id<FYChartViewDataSource> dataSource;

/**
 * chart view delegate
 */
@property (nonatomic, assign) IBOutlet id<FYChartViewDelegate> delegate;

/**
 *  reload data source
 */
- (void)reloadData;

@end