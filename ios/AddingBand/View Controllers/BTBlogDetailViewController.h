//
//  BTBlogDetailViewController.h
//  AddingBand
//
//  Created by wangpeng on 14-1-15.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import "BTScrollViewController.h"

@interface BTBlogDetailViewController : BTScrollViewController<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)NSString *blogHash;
@end
