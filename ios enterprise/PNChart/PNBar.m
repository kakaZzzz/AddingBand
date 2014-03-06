//
//  PNBar.m
//  PNChartDemo
//
//  Created by wangpeng on 11/7/13.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import "PNBar.h"
#import "PNBarChart.h"
static PNBar *constBar = nil;
@implementation PNBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.markViewArray = [NSMutableArray arrayWithCapacity:1];
		_chartLine = [CAShapeLayer layer];
		_chartLine.lineCap = kCALineCapSquare;
		_chartLine.fillColor   = [[UIColor whiteColor] CGColor];
		_chartLine.lineWidth   = self.frame.size.width;
		_chartLine.strokeEnd   = 0.0;
		self.clipsToBounds = YES;
		[self.layer addSublayer:_chartLine];
		self.layer.cornerRadius = 2.0;
    }
    return self;
}

-(void)setGrade:(float)grade
{
    
    NSLog(@"动态绘制");
    
      
    
	_grade = grade;
	UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    [progressline moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height)];
	[progressline addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1 - grade) * self.frame.size.height)];
	
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
	_chartLine.path = progressline.CGPath;
    
	if (_barColor) {
		_chartLine.strokeColor = [_barColor CGColor];
	}else{
		_chartLine.strokeColor = [[UIColor greenColor] CGColor];
	}
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _chartLine.strokeEnd = 1.0;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    

    PNBarChart *barChart = (PNBarChart *)self.superview;
    for (UIView *aView in barChart.subviews) {
        if ([aView isKindOfClass:[PNBar class]] && aView.tag != self.tag) {
            CATransition *animation = [CATransition animation];//创建动画效果类
            animation.delegate = self;//设置属性依赖
            animation.duration = 0.7;//设置动画时长
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];  //设置动画淡入淡出的效果
            animation.type = kCATransitionPush;
            animation.subtype = kCATransitionFromLeft;
            // 要做的
            self.markView.hidden = NO;     //视图按设置的动画效果的转换
            [self.markView.layer addAnimation:animation forKey:nil];       //在图层增加动画效果
            
            
            CATransition *animation1 = [CATransition animation];
            animation1.delegate = self;
            animation1.duration = 0.7;
            animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation1.type = kCATransitionFade;
            animation1.subtype = kCATransitionFromTop;
            [[(PNBar *)aView markView] setHidden:YES];
            [[[(PNBar *)aView markView] layer] addAnimation:animation1 forKey:nil];
}
    }
   
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    NSLog(@"drawrect..............");
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
//    label.backgroundColor = [UIColor clearColor];
//    label.text = @"123";
//    [self addSubview:label];
//	//Draw BG
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor);
//	CGContextFillRect(context, rect);
//    
//}


@end
