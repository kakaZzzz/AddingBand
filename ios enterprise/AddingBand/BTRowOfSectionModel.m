//
//  BTRowOfSectionModel.m
//  AddingBand
//
//  Created by wangpeng on 14-1-7.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import "BTRowOfSectionModel.h"

@implementation BTRowOfSectionModel
- (id)initWithSectionTitle:(NSString *)title row:(int)aRow
{
    self = [super init];
    if (self) {
        self.sectionTile = title;
        self.row = aRow;
    }
    return self;
}
@end
