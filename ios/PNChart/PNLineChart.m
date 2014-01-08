//
//  PNLineChart.m
//  PNChartDemo
//
//  Created by wangpeng on 11/7/13.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import "PNLineChart.h"
#import "PNChartLabel.h"
#define DISTANCE_X 2.5f//x轴坐标label之间的距离
#define xLabelHeight 30.0f//x轴坐标label的高度
#define xLabelWidth 30.0f//x轴坐标label的宽度
#define LINE_COLOR [UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:122.0/255.0 alpha:1.0f]//折线颜色
#define LABELY_GRADE 5.0f//Y轴左边等级级数
#define xLabelDistanceyLabel 5.0f//x轴和y轴左边之间的缝隙大小

static CGFloat distance = 0;
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
        self.backgroundColor = [UIColor clearColor];
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
//    NSInteger max = 0;
//    for (NSString * valueString in yLabels) {
//        NSInteger value = [valueString integerValue];
//        if (value > max) {
//            max = value;
//        }
//        
//    }
//    
//    // max = 200;//可以认为设定最大值
//    //Min value for Y label
//    if (max < 5) {
//        max = 5;
//    }
    
    NSInteger max = 10;
    _yValueMax = (int)max;
    
    float level = max /LABELY_GRADE;//纵坐标分级 有多少等级
	
    NSInteger index = 0;
    
    NSInteger num = LABELY_GRADE + 1;
    
	while (num > 0) {
		CGFloat chartCavanHeight = self.frame.size.height - yLabelMargin -yLabelHeight - (xLabelHeight + xLabelDistanceyLabel);//怎么都行可以调动
        
		CGFloat levelHeight = chartCavanHeight /LABELY_GRADE;
        PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0,self.frame.size.height - (xLabelHeight + yLabelHeight + xLabelDistanceyLabel)- index * levelHeight, 20.0, yLabelHeight)];
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
    _xLabelWidth = xLabelWidth;//Label宽度。。。
     distance = (self.frame.size.width - xLabelMargin - [xLabels count]*xLabelWidth)/([xLabels count]);
    for (NSString * labelText in xLabels) {
        NSInteger index = [xLabels indexOfObject:labelText];
        if (index%3 == 0) {
            PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(index * (distance + _xLabelWidth) + xLabelMargin,self.frame.size.height - xLabelHeight, _xLabelWidth, xLabelHeight)];//两个label之间的距离应该是 xLabelMargin + _xLabelWidth
            [label setTextAlignment:NSTextAlignmentLeft];
            label.backgroundColor = [UIColor clearColor];
            label.text = labelText;
            [self addSubview:label];

        }
      //  NSLog(@"Label的X轴距离%f",label.frame.origin.x);
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
    
    CGFloat xPosition = xLabelMargin + _xLabelWidth/2;
    
    
    CGFloat chartCavanHeight = self.frame.size.height - yLabelMargin - yLabelHeight - (xLabelHeight + xLabelDistanceyLabel);//怎么都行可以调动
    
    float grade = (float)firstValue / (float)_yValueMax;//认为设定 最大值 即可
    [progressline moveToPoint:CGPointMake(xPosition,chartCavanHeight - grade * chartCavanHeight + yLabelMargin + yLabelHeight/2)];
    
    [progressline setLineWidth:1.0];//折线宽度
    [progressline setLineCapStyle:kCGLineCapRound];
    [progressline setLineJoinStyle:kCGLineJoinRound];
    NSInteger index = 0;
    for (NSString * valueString in _yValues) {
        NSInteger value = [valueString integerValue];
        float grade = (float)value / (float)_yValueMax;
        
        if (index != 0) {
            
            [progressline addLineToPoint:CGPointMake( xPosition  + index *(distance + _xLabelWidth), chartCavanHeight - grade * chartCavanHeight + yLabelMargin + yLabelHeight/2)];
            
            [progressline moveToPoint:CGPointMake(xPosition  +index *(distance + _xLabelWidth), chartCavanHeight - grade * chartCavanHeight + yLabelMargin + yLabelHeight/2)];
            
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
