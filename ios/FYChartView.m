//
//  FYChartView.m
//
//  sina weibo:http://weibo.com/zbflying
//
//  Created by zbflying on 13-11-27.
//  Copyright (c) 2013年 zbflying All rights reserved.
//

#import "FYChartView.h"
#import "BTPhysicalModel.h"
@interface FYChartView ()

@property (nonatomic, retain) NSMutableArray *valueItemArray;
@property (nonatomic, retain) UIView *descriptionView;
@property (nonatomic, retain) UIView *slideLineView;

@end

@implementation FYChartView
{
    @private
    BOOL    isLoaded;                   //is already load
    float   horizontalItemWidth;        //horizontal item width
    float   verticalItemHeight;         //vertical item width
    float   maxVerticalValue;           //max vertical value
    CGSize  verticalTextSize;           //vertical text size
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //default line width
        self.rectanglelineWidth = 1.0f;
        self.lineWidth = 1.0f;
        
        //default line color
        self.rectangleLineColor = [UIColor blackColor];
        self.lineColor = [UIColor blackColor];
        
        self.hideDescriptionViewWhenTouchesEnd = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (isLoaded)
        return;
    
    //绘制上下限折线
    [self drawOnLimitAndOffLimitLine:rect];
    //draw data line
    [self drawValueLine:rect];//绘制折线
    
    [self drawHorizontalTitle:rect];
    
    //draw rectangle line and vertical text
  //  [self drawRectangleAndVerticalText:rect];
    
    isLoaded = YES;
}


/**
 *  draw rectangle
 */
- (void)drawRectangleAndVerticalText:(CGRect)rect
{
    rect.origin.x = verticalTextSize.width;
    rect.origin.y = verticalTextSize.height;
    rect.size.width -= verticalTextSize.width;
    rect.size.height -= (verticalTextSize.height * 2);
    
    //draw rectangle
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextAddPath(currentContext, path);
    [[UIColor clearColor] setFill];
    [[UIColor clearColor] setStroke];
    CGContextSetStrokeColorWithColor(currentContext, self.rectangleLineColor.CGColor);
    CGContextSetLineWidth(currentContext, self.rectanglelineWidth);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    CGPathRelease(path);
    
    //draw lines and vertical text
    [self.rectangleLineColor setFill];
    CGContextSetLineWidth(currentContext, self.rectanglelineWidth);
    float itemHeight = rect.size.height / 5;
    for (int i = 1; i <= 5; i++)
    {
        if (i != 5)
        {
            CGContextMoveToPoint(currentContext, rect.origin.x, rect.size.height - itemHeight * i + verticalTextSize.height);
            CGContextAddLineToPoint(currentContext,
                                    rect.size.width + verticalTextSize.width,
                                    rect.size.height - itemHeight * i +verticalTextSize.height);
            CGContextClosePath(currentContext);
            CGContextStrokePath(currentContext);
        }
        
        NSString *text = [NSString stringWithFormat:@"%.2f", (i + 1) * (maxVerticalValue / 6)];
        [text drawAtPoint:CGPointMake(.0f,
                                      rect.size.height - itemHeight * i + verticalTextSize.height - verticalTextSize.height * 0.5f)
                 withFont:[UIFont systemFontOfSize:10.0f]];
    }
}

- (void)drawOnLimitAndOffLimitLine:(CGRect)rect
{
    
    verticalTextSize = CGSizeMake(xMargin,yMargin);//边距都有了
    switch (self.style) {
        case BTChartWeight:
            maxVerticalValue = 100;
            break;
        case BTChartFuntalHeight:
            maxVerticalValue = 35;
            break;
        case BTChartGirth:
            maxVerticalValue = 110;
            break;
        default:
            break;
    }
    

    //横坐标最小刻度之间间隔
    horizontalItemWidth = (rect.size.width - verticalTextSize.width) / (280 - 1);
    //纵坐标最小刻度之间的间隔
    verticalItemHeight = (rect.size.height - verticalTextSize.height * 2) / maxVerticalValue;
    

    if ([self.onLimit count] > 0) {
        
        
            for (int i = 0; i < [self.onLimit count] - 1; i++)
            {
                
                BTPhysicalModel *model = [self.onLimit objectAtIndex:i];
                float value = [model.content floatValue];
                int day = [model.day intValue];
                
                //   float value = [(NSNumber *)valueItems[i] floatValue];
                CGPoint point = [self valuePoint:value atIndex:day];
                
                NSLog(@"点得位置%@",NSStringFromCGPoint(point));
                
                BTPhysicalModel *nextModel = [self.onLimit objectAtIndex:i+1];
                float nextValue = [nextModel.content floatValue];
                int nextDay = [nextModel.day intValue];
                CGPoint nextPoint = [self valuePoint:nextValue atIndex:nextDay];
                
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextMoveToPoint(context, point.x, point.y);
                CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
                CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
                
                CGContextSetLineWidth(context, self.lineWidth);
                CGContextClosePath(context);
                CGContextStrokePath(context);
                
            }
            
      }
    

    if ([self.offLimit count] > 0) {
        
        
        for (int i = 0; i < [self.offLimit count] - 1; i++)
        {
            
            BTPhysicalModel *model = [self.offLimit objectAtIndex:i];
            float value = [model.content floatValue];
            int day = [model.day intValue];
            
            //   float value = [(NSNumber *)valueItems[i] floatValue];
            CGPoint point = [self valuePoint:value atIndex:day];
            
            NSLog(@"点得位置%@",NSStringFromCGPoint(point));
            
            BTPhysicalModel *nextModel = [self.offLimit objectAtIndex:i+1];
            float nextValue = [nextModel.content floatValue];
            int nextDay = [nextModel.day intValue];
            CGPoint nextPoint = [self valuePoint:nextValue atIndex:nextDay];
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextMoveToPoint(context, point.x, point.y);
            CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
            CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
            
            CGContextSetLineWidth(context, self.lineWidth);
            CGContextClosePath(context);
            CGContextStrokePath(context);
            
        }
        
    }

}

/**
 *  draw data line
 */
- (void)drawValueLine:(CGRect)rect
{
    if (!self.dataSource)
        return;
    

    NSMutableArray *valueItems = [NSMutableArray array];

    verticalTextSize = CGSizeMake(xMargin,yMargin);//边距都有了
    switch (self.style) {
        case BTChartWeight:
            maxVerticalValue = 100;
            break;
        case BTChartFuntalHeight:
            maxVerticalValue = 35;
            break;
        case BTChartGirth:
            maxVerticalValue = 110;
            break;
        default:
            break;
    }

    self.valueItemArray = valueItems;
    //横坐标最小刻度之间间隔
    horizontalItemWidth = (rect.size.width - verticalTextSize.width) / (280 - 1);
    //纵坐标最小刻度之间的间隔
    verticalItemHeight = (rect.size.height - verticalTextSize.height * 2) / maxVerticalValue;
    
    NSLog(@"---------------%d",[self.modelArray count]);
    if ([self.modelArray count] > 0) {
        
        //如果只有一个点 就画一个圆
        if ([self.modelArray count] == 1) {
            
            BTPhysicalModel *model = [self.modelArray objectAtIndex:0];
            float value = [model.content floatValue];
            int day = [model.day intValue];
            CGPoint point = [self valuePoint:value atIndex:day];
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextAddEllipseInRect(context, CGRectMake(point.x, point.y, 5.0, 5.0));
            
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            
            CGContextFillPath(context);
         
        }
        
        
        //如果大于一个数据 就画线
        else{
            for (int i = 0; i < [self.modelArray count] - 1; i++)
            {
                
                BTPhysicalModel *model = [self.modelArray objectAtIndex:i];
                float value = [model.content floatValue];
                int day = [model.day intValue];
                
                //   float value = [(NSNumber *)valueItems[i] floatValue];
                CGPoint point = [self valuePoint:value atIndex:day];
                
                NSLog(@"点得位置%@",NSStringFromCGPoint(point));
                
                BTPhysicalModel *nextModel = [self.modelArray objectAtIndex:i+1];
                
                //float nextValue = [(NSNumber *)valueItems[day + 1] floatValue];
                float nextValue = [nextModel.content floatValue];
                int nextDay = [nextModel.day intValue];
                CGPoint nextPoint = [self valuePoint:nextValue atIndex:nextDay];
                
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextMoveToPoint(context, point.x, point.y);
                CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
                CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
                
                CGContextSetLineWidth(context, self.lineWidth);
                CGContextClosePath(context);
                CGContextStrokePath(context);
                
                
            }

        }
        
        
        
     }
    
 }




#pragma mark - 绘制出横坐标
//只绘制 1周 4周 7周...
- (void)drawHorizontalTitle:(CGRect)rect

{
    //draw horizontal title
//    if (self.dataSource && [self.dataSource respondsToSelector:@selector(chartView:horizontalTitleAtIndex:)])
//    {
        /**
         *  i+1表示第几天
         */
        for (int i = 0; i < 280; i++)
        {
           // NSString *title = [self.dataSource chartView:self horizontalTitleAtIndex:i+1];
            NSString *title = nil;
            int remainder = (i+1)%7;
            int week = (i+1)/7 + 1;
            if ((remainder == 1 && (week - 1)%3 == 0) || (week == 1 && remainder == 1)) {
                title = [NSString stringWithFormat:@"%d周",(i+1)/7 + 1];
            }
            else{
                title = @"";
            }
            
                float value = 12.0f;

                CGPoint point = [self valuePoint:value atIndex:i+1];//i+1为第几天
                
                UIFont *font = [UIFont systemFontOfSize:15.0f];
                CGSize size = [title sizeWithFont:font];
                [[UIColor whiteColor] set];//设置字体颜色
            
                HorizontalTitleAlignment alignment = HorizontalTitleAlignmentCenter;
                if ([self.dataSource respondsToSelector:@selector(chartView:horizontalTitleAlignmentAtIndex:)])
                {
                    alignment = [self.dataSource chartView:self horizontalTitleAlignmentAtIndex:i];
                }
                
                if (alignment == HorizontalTitleAlignmentLeft)
                {
                    [title drawAtPoint:CGPointMake(point.x, rect.size.height - size.height) withFont:font];
                }
                else if (alignment == HorizontalTitleAlignmentCenter)
                {
                    [title drawAtPoint:CGPointMake(point.x - size.width * 0.5f, rect.size.height - size.height) withFont:font];
                }
                else if (alignment == HorizontalTitleAlignmentRight)
                {
                    [title drawAtPoint:CGPointMake(point.x - size.width, rect.size.height - size.height) withFont:font];
                }
            }



}
#pragma mark - custom method

/**
 *  value item point at index
 */
- (CGPoint)valuePoint:(float)value atIndex:(int)index
{
    CGPoint retPoint = CGPointZero;
    
    retPoint.x = (index-1) * horizontalItemWidth + verticalTextSize.width;
    retPoint.y = self.frame.size.height - verticalTextSize.height - value * verticalItemHeight;
    
    return retPoint;
}

/**
 *  display description view
 */
- (void)descriptionViewPointWithTouches:(NSSet *)touches
{
    
  
    CGSize size = self.frame.size;
    
   // NSLog(@"大小大小      %@",NSStringFromCGSize(size));
    UITouch *touch = [touches anyObject];
    CGPoint location = [[touches anyObject] locationInView:self];
    
    // 1) 取出前一次的手指位置
    CGPoint preLocation = [touch previousLocationInView:self];
    
    // 2) 计算两次手指之间的距离差值
    CGPoint offset = CGPointMake(location.x - preLocation.x, location.y - preLocation.y);
    
    UIScrollView *fatherScrollView = (UIScrollView *)self.superview;
    //改变偏移量
    if (fatherScrollView.contentOffset.x < 0 && offset.x < 0) {
        fatherScrollView.contentOffset = CGPointMake(fatherScrollView.contentOffset.x + 0 , fatherScrollView.contentOffset.y);

    }
    
    //320 根据contensize而改变
    else if (fatherScrollView.contentOffset.x > fatherScrollView.contentSize.width - 320 && offset.x > 0) {
        fatherScrollView.contentOffset = CGPointMake(fatherScrollView.contentOffset.x + 0 , fatherScrollView.contentOffset.y);

    }
    
    else
    {
        fatherScrollView.contentOffset = CGPointMake(fatherScrollView.contentOffset.x + offset.x , fatherScrollView.contentOffset.y);

    }
    //
    if (location.x >= 0 && location.x <= size.width && location.y >= 0 && location.y <= size.height)
    {
        int intValue = location.x / horizontalItemWidth;
        float remainder = location.x - intValue * horizontalItemWidth;
        
        int index = intValue + (remainder >= horizontalItemWidth * 0.5f ? 1 : 0);
        //index为坐标
        if ([self isHasDataWithIndex:index])
        {
//          float value = [(NSNumber *)self.valueItemArray[index] floatValue];
//          CGPoint point = [self valuePoint:value atIndex:index];
            
            BTPhysicalModel *model = [self getModelWithIndex:index];
            float value = [model.content floatValue];
            int day = [model.day intValue];
            CGPoint point = [self valuePoint:value atIndex:day];


            
            if ([self.dataSource respondsToSelector:@selector(chartView:descriptionViewAtIndex:model:)])
            {
                UIImageView *descriptionView = (UIImageView *)[self.dataSource chartView:self descriptionViewAtIndex:index model:model];
                CGRect frame = descriptionView.frame;
                if (point.x + frame.size.width > size.width)
                {
                    frame.origin.x = point.x - frame.size.width;
                }
                else
                {
                    frame.origin.x = point.x;
                }
                
                if (frame.size.height + point.y > size.height)
                {
                    frame.origin.y = point.y - frame.size.height;
                }
                else
                {
                    frame.origin.y = point.y;
                }
                
                descriptionView.frame = frame;
                
                if (self.descriptionView)
                    
                [self.descriptionView removeFromSuperview];
                
                if (!self.slideLineView)
                {
                    //slide line view
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(.0f,
                                                                                 verticalTextSize.height,
                                                                                 1.0f,
                                                                                 self.frame.size.height - verticalTextSize.height * 2)];
                    lineView.backgroundColor = [UIColor whiteColor];
                    lineView.hidden = YES;
                    self.slideLineView = lineView;
                    [self addSubview:self.slideLineView];
                }
                
                //draw line  红色的移动线 竖线
                CGRect slideLineViewFrame = self.slideLineView.frame;
                slideLineViewFrame.origin.x = point.x;
                self.slideLineView.frame = slideLineViewFrame;
                self.slideLineView.hidden = NO;
                
                [self addSubview:descriptionView];
                self.descriptionView = descriptionView;
                
                //delegate
                if (self.delegate && [self.delegate respondsToSelector:@selector(chartView:didMovedToIndex:)])
                {
                    [self.delegate chartView:self didMovedToIndex:index];
                }
            }
        }
    }
}

- (BOOL)isHasDataWithIndex:(int)index
{
    for (int i = 0; i < [self.modelArray count]; i++) {
        
        BTPhysicalModel *model = [self.modelArray objectAtIndex:i];
        
        int day = [model.day intValue];
     
        if (index == day) {
            return YES;
        }
    }
    
        return NO;
}

- (BTPhysicalModel *)getModelWithIndex:(int)index
{
    for (int i = 0; i < [self.modelArray count]; i++) {
        
        BTPhysicalModel *model = [self.modelArray objectAtIndex:i];
        
        int day = [model.day intValue];
        
        if (index == day) {
            return model;
        }
    }
    
    return nil;
}

- (void)reloadData
{
    isLoaded = NO;
    [self.valueItemArray removeAllObjects];
    horizontalItemWidth = .0f;
    verticalItemHeight = .0f;
    maxVerticalValue = .0f;
    if (self.descriptionView)   [self.descriptionView removeFromSuperview];
    if (self.slideLineView)   self.slideLineView.hidden = YES;
    [self setNeedsDisplay];
}

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.valueItemArray || !self.valueItemArray.count || !self.dataSource) return;
    
    [self descriptionViewPointWithTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self descriptionViewPointWithTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.descriptionView && self.hideDescriptionViewWhenTouchesEnd)
    [self.descriptionView removeFromSuperview];
    self.slideLineView.hidden = YES;
}

@end
