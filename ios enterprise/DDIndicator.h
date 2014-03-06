//
//  DDIndicator.h
//  loading
//
//  Created by wangpeng on 1/11/13.
//  Copyright (c) 2013 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDIndicator : UIView

@property(nonatomic,strong)UILabel *contentLabel;//下面Label
-(void) startAnimating;
-(void) stopAnimating;
@end
