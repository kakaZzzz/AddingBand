//
//  BTPhysicalCollectionView.h
//  BTTestCollectionView
//
//  Created by wangpeng on 13-12-26.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BTPhysicalModel;
typedef void(^ChoosePhysicalBlock)(int);
@interface BTPhysicalCollectionView : UIView
@property(nonatomic,strong)ChoosePhysicalBlock choosePhysicalBlock;


- (id)initWithFrame:(CGRect)frame modelArray:(NSArray *)model;
- (void)updateDataWithSubViewTag:(int)tag Model:(BTPhysicalModel *)model;

@end
