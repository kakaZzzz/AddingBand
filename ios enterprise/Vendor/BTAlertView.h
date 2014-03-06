//
//  BTAlertView.h
//  MoreLikers
//
//  Created by wangpeng on 13-12-25.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTAlertView : UIView

- (id)initWithTitle:(NSString *)title
          iconImage:(UIImage *)iconImage
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;

- (void)show;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@end

@interface UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end