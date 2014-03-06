//
//  BTBadgeManager.h
//  AddingBand
//
//  Created by wangpeng on 13-12-9.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTBadgeManager : NSObject
/**
 *  在tabbar上添加不带数字的小红点
 *
 *  @param tabIndex tabbar的下标
 */
+ (void)showBadgeAtIndex:(int)tabIndex;//加载小红点 不带数字
/**
 *  移除tabbar上不带数字的小红点
 *
 *  @param tabIndex tabbar的下标
 */
+ (void)removeBadgeAtIndex:(int)tabIndex;//移除小红点 不带数字
/**
 *  在tabbar上添加带数字的小红点 实现完全自定义
 *
 *  @param index      tabbar的下标
 *  @param badgeValue badgevalue数值
 */
+ (void)showBadgeAtIndex:(NSUInteger)index badgeValue:(NSString*)badgeValue;//加载小红点 带数字
/**
 *  移除tabbar上带数字的小红点
 *
 *  @param tabIndex tabbar的下标
 */
+ (void)removeBadgeWithValueAtIndex:(int)tabIndex;//移除小红点 带数字
@end
