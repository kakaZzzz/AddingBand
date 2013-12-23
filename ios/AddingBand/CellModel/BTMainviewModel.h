//
//  BTMainviewModel.h
//  AddingBand
//
//  Created by wangpeng on 13-12-23.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTMainviewModel : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *condition;
- (id)initWithTitle:(NSString *)title content:(NSString *)content;
@end
