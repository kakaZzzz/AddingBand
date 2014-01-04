//
//  BTPhysicalModel.h
//  FYChartViewDemo
//
//  Created by wangpeng on 13-12-28.
//  Copyright (c) 2013年 zbflying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTPhysicalModel : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *day;
@property(nonatomic,strong)NSString *year;
@property(nonatomic,strong)NSString *month;
- (id)initWithTitle:(NSString *)title content:(NSString *)content day:(NSString *)day;
- (id)initWithTitle:(NSString *)atitle content:(NSString *)acontent;
- (id)initWithTitle:(NSString *)title content:(NSString *)content year:(NSString *)year month:(NSString *)month day:(NSString *)day;
@end
