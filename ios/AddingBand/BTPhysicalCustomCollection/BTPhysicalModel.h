//
//  BTPhysicalModel.h
//  BTTestCollectionView
//
//  Created by wangpeng on 13-12-26.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTPhysicalModel : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *condition;
- (id)initWithTitle:(NSString *)title content:(NSString *)content;

@end
