//
//  BTPhisicalModel.h
//  AddingBand
//
//  Created by wangpeng on 13-12-17.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTPhisicalModel : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *condition;
- (id)initWithTitle:(NSString *)title content:(NSString *)content;
@end
