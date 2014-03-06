//
//  BTScrollViewController.h
//  AddingBand
//
//  Created by wangpeng on 13-12-18.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTScrollViewController : UIViewController
@property(nonatomic,strong)UIScrollView *scrollView;//default contensize is (self.view.frame.height + 50)

@property(nonatomic,strong)UIButton *backButton;
- (void)backToPreviousViewController;//返回上一个页面所要调用的方法,如果有些处理需要在返回上一级的时候处理 ，重写此方法
@end
