//
//  BTPhysicalCollectionView.m
//  BTTestCollectionView
//
//  Created by wangpeng on 13-12-26.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import "BTPhysicalCollectionView.h"
#import "BTPhysicalCell.h"
#import "BTUCCell.h"
#import "LayoutDef.h"
@implementation BTPhysicalCollectionView


- (id)initWithFrame:(CGRect)frame modelArray:(NSArray *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createSubviewsWithModelArray:model];
    }
    return self;

}
- (void)createSubviewsWithModelArray:(NSArray *)model
{
    int left = 0;
    int top = 0;
    int index = 0;
    for (int i = 0; i < 1; i ++) {//判断有多少个button
        for (int j = 0; j < 3; j++) {
            
            CGRect rect = CGRectMake(left + j * 104,top + i * 110, 100, 100);
            //分割线
            if (rect.origin.x != 0) {
                UIImageView *sepImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vertical_sep_line"]];
                if (i == 0) {
                    sepImage.frame = CGRectMake(rect.origin.x - 4, rect.origin.y,4, rect.size.height + 5);

                }
                else{
                    sepImage.frame = CGRectMake(rect.origin.x - 4, rect.origin.y - 5,4, rect.size.height + 5);

                }
                    [self addSubview:sepImage];

            }
            
            if (index < 5) {
                BTPhysicalCell *aView = [BTPhysicalCell buttonWithType:UIButtonTypeCustom];
                aView.frame = rect;
                aView.tag = PHYSICAL_BUTTON_TAG + index;
                [aView addTarget:self action:@selector(dianji:) forControlEvents:UIControlEventTouchUpInside];
                aView.backgroundColor = [UIColor whiteColor];
                [self addSubview:aView];
                aView.physicalModel = [model objectAtIndex:index];

            }
            
            else{
                BTUCCell *aView = [BTUCCell buttonWithType:UIButtonTypeCustom];
                aView.frame = rect;
                aView.tag = PHYSICAL_BUTTON_TAG + index;
                [aView addTarget:self action:@selector(dianji:) forControlEvents:UIControlEventTouchUpInside];
                aView.backgroundColor = [UIColor whiteColor];
                [self addSubview:aView];
                aView.physicalModel = [model objectAtIndex:index];

            }
            index ++;
        }
        
       }
    
    
    UIImageView *sepImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seperator_line"]];
    sepImage.frame = CGRectMake(0, 100 + 5,self.frame.size.width, kSeparatorLineHeight);
    [self addSubview:sepImage];

}

- (void)dianji:(BTPhysicalCell *)btn
{
    _choosePhysicalBlock(btn.tag);
}


- (void)updateDataWithSubViewTag:(int)tag Model:(BTPhysicalModel *)model
{
    if (tag == PHYSICAL_BUTTON_TAG + 5) {
        BTUCCell *cell = (BTUCCell *)[self viewWithTag:tag];
        cell.physicalModel = model;
        
    }
    
    else{
        BTPhysicalCell *cell = (BTPhysicalCell *)[self viewWithTag:tag];
        cell.physicalModel = model;
    }
}

@end
