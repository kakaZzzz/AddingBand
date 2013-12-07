//
//  PNLineChart.m
//  PNChartDemo
//
//  Created by wangpeng on 11/7/13.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import "PNLineChart.h"
#import "PNChartLabel.h"
#define DISTANCE_X 20
#define XLABEL_WIDTH 7.5f
#define LINE_COLOR [UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:122.0/255.0 alpha:1.0f]
@implementation PNLineChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
		_chartLine = [CAShapeLayer layer];
		_chartLine.lineCap = kCALineCapRound;
		_chartLine.lineJoin = kCALineJoinBevel;
		_chartLine.fillColor   = [[UIColor whiteColor] CGColor];
		_chartLine.lineWidth   = 3.0;
		_chartLine.strokeEnd   = 0.0;
		[self.layer addSublayer:_chartLine];
        self.backgroundColor = [UIColor blueColor];
    }
    
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    for (NSString * valueString in yLabels) {
        NSInteger value = [valueString integerValue];
        if (value > max) {
            max = value;
        }
        
    }
    
    //Min value for Y label
    if (max < 5) {
        max = 5;
    }
    
    _yValueMax = (int)max;
    
    float level = max /5.0;
	
    NSInteger index = 0;
	NSInteger num = [yLabels count] + 1;
	while (num > 0) {
		CGFloat chartCavanHeight = self.frame.size.height - chartMargin * 2 - 40.0 ;
		CGFloat levelHeight = chartCavanHeight /5.0;
		PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight - index * levelHeight + (levelHeight - yLabelHeight) , 20.0, yLabelHeight)];
		[label setTextAlignment:NSTextAlignmentRight];
		label.text = [NSString stringWithFormat:@"%1.f",level * index];
		[self addSubview:label];
        index +=1 ;
		num -= 1;
	}

}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
//    _xLabelWidth = (self.frame.size.width - chartMargin - 30.0 - ([xLabels count] -1) * xLabelMargin)/[xLabels count];
    _xLabelWidth = XLABEL_WIDTH;//Label宽度。。。
    for (NSString * labelText in xLabels) {
        NSInteger index = [xLabels indexOfObject:labelText];
        PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(index * (xLabelMargin + _xLabelWidth) + DISTANCE_X, self.frame.size.height - 30.0, _xLabelWidth, 30.0)];//连个label之间的距离应该是 xLabelMargin + _xLabelWidth
        [label setTextAlignment:NSTextAlignmentLeft];
      //  [label setFont:[UIFont systemFontOfSize:8]];
        label.text = labelText;
        [self addSubview:label];
        NSLog(@"Label的X轴距离%f",label.frame.origin.x);
    }
    NSLog(@"X轴宽度是%f",_xLabelWidth);
}

-(void)setStrokeColor:(UIColor *)strokeColor
{
	_strokeColor = strokeColor;
	_chartLine.strokeColor = [strokeColor CGColor];
}
//-(void)strokeChart
-(void)drawRect:(CGRect)rect
{
    
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    CGFloat firstValue = [[_yValues objectAtIndex:0] floatValue];
    
  //CGFloat xPosition = (xLabelMargin + _xLabelWidth) + 15   ;
    CGFloat xPosition = DISTANCE_X + _xLabelWidth/2   ;
    NSLog(@"草草草草草草草草草%f",xLabelMargin+_xLabelWidth);
    CGFloat chartCavanHeight = self.frame.size.height - chartMargin * 2 - 40.0;
    
    float grade = (float)firstValue / (float)_yValueMax;
    [progressline moveToPoint:CGPointMake(xPosition,chartCavanHeight - grade * chartCavanHeight + 20.0)];
    [progressline setLineWidth:3.0];
    [progressline setLineCapStyle:kCGLineCapRound];
    [progressline setLineJoinStyle:kCGLineJoinRound];
    NSInteger index = 0;
    for (NSString * valueString in _yValues) {
        NSInteger value = [valueString integerValue];
        
        float grade = (float)value / (float)_yValueMax;
        if (index != 0) {
            
            [progressline addLineToPoint:CGPointMake( xPosition  + index *(xLabelMargin + _xLabelWidth), chartCavanHeight - grade * chartCavanHeight + 20.0)];
            
            [progressline moveToPoint:CGPointMake(xPosition  +index *(xLabelMargin + _xLabelWidth), chartCavanHeight - grade * chartCavanHeight + 20.0 )];
            
           // [progressline stroke];
        }
        
        index += 1;
    }
    
    _chartLine.path = progressline.CGPath;
	if (_strokeColor) {
		_chartLine.strokeColor = [_strokeColor CGColor];
	}else{
		_chartLine.strokeColor = [LINE_COLOR CGColor];
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



@end
