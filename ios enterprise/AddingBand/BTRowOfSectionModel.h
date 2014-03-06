//
//  BTRowOfSectionModel.h
//  AddingBand
//
//  Created by wangpeng on 14-1-7.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRowOfSectionModel : NSObject
@property(nonatomic,strong)NSString *sectionTile;
@property(nonatomic,assign)int row;

- (id)initWithSectionTitle:(NSString *)title row:(int)aRow;
@end
