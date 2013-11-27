//
//  DDIndicator.h
//  loading
//
//  Created by Or Ron on 4/6/13.
//  Copyright (c) 2013 Or Ron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDIndicator : UIView

@property(nonatomic,strong)UILabel *contentLabel;
-(void) startAnimating;
-(void) stopAnimating;


@end
