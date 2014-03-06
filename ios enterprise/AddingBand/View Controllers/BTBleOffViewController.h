//
//  BTBleOffViewController.h
//  AddingBand
//
//  Created by wangpeng on 14-1-8.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTBleOffViewController : UIViewController
@property(nonatomic,strong)UIImageView *aImageView;
@property(nonatomic,strong)UIImageView *bImageView;
@property(nonatomic,strong)UILabel *warnLabel;
@property(nonatomic,strong)NSString *warnText;
@property(nonatomic,strong)NSString *aImageName;
@property(nonatomic,strong)NSString *bImageName;
- (id)initWithWarntext:(NSString *)warnText aImageName:(NSString *)aImage bImageName:(NSString *)bImage;

@end
