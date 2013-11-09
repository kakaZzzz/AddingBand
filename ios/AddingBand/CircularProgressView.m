//
//  CircularProgressView.m
//  CircularProgressView
//
//  Created by nijino saki on 13-3-2.
//  Copyright (c) 2013年 nijino. All rights reserved.
//

#import "CircularProgressView.h"

@interface CircularProgressView ()<AVAudioPlayerDelegate>

@property (strong, nonatomic) UIColor *backColor;
@property (strong, nonatomic) UIColor *progressColor;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) float progress;


@end

@implementation CircularProgressView

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        _backColor = backColor;
        _progressColor = progressColor;
        _lineWidth = lineWidth;
        
        
 
    }
    return self;
}   


- (void)drawRect:(CGRect)rect
{
    //draw background circle
   UIBezierPath *backCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2) radius:self.bounds.size.width / 2 - self.lineWidth / 2 startAngle:(CGFloat) -M_PI_2 endAngle:(CGFloat)(1.5 * M_PI) clockwise:YES];
      [self.backColor setStroke];
    backCircle.lineWidth = self.lineWidth;
    [backCircle stroke];
    
    if (self.progress != 0) {
        //draw progress circle
        
        UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2) radius:self.bounds.size.width / 2 - self.lineWidth / 2 startAngle:(CGFloat) -M_PI_2 endAngle:(CGFloat)(-M_PI_2 + self.progress * 2 * M_PI) clockwise:YES];
        [self.progressColor setStroke];
        progressCircle.lineWidth = self.lineWidth;
       // [progressCircle stroke];//直接把圆画出来
        
        //把圆动态的画出来
        CAShapeLayer * arcLayer=[CAShapeLayer layer];
        arcLayer.strokeColor=self.progressColor.CGColor;
        //圆的填充颜色为透明色
        arcLayer.fillColor = [UIColor clearColor].CGColor;
        arcLayer.lineWidth=self.lineWidth;

        arcLayer.path = progressCircle.CGPath;
        [self.layer addSublayer:arcLayer];
        [self drawLineAnimation:arcLayer];
        
    }
    
  
}
//画圆动画
-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=1;
    //bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}
- (void)updateProgressCircle:(int)start withTotal:(int)total{
    //update progress value
    
    
    
    self.progress =  (float)start/(float)total;
    //redraw back & progress circles
    [self setNeedsDisplay];
}
@end
