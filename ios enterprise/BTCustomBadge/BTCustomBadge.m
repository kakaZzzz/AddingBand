//
//  BTBadgeManager.h
//  AddingBand
//
//  Created by wangpeng on 13-12-9.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTCustomBadge.h"
#define BADGE_WIDTH 25.0f
#define BADGE_HEIGHT 25.0f
#define LABEL_TEXT_FONT 12.5f
@interface BTCustomBadge()

- (id)initWithString:(NSString *)badgeString withScale:(CGFloat)scale withShining:(BOOL)shining;

- (id)initWithString:(NSString *)badgeString
     withStringColor:(UIColor *)stringColor
      withInsetColor:(UIColor *)insetColor
      withBadgeFrame:(BOOL)badgeFrameYesNo
 withBadgeFrameColor:(UIColor *)frameColor
           withScale:(CGFloat)scale
         withShining:(BOOL)shining
          withShadow:(BOOL)shadow;

- (void)drawRoundedRectWithContext:(CGContextRef)context inRect:(CGRect)rect;
- (void)drawShineWithContext:(CGContextRef)context inRect:(CGRect)rect;
- (void)drawFrameWithContext:(CGContextRef)context inRect:(CGRect)rect;

@end



@implementation BTCustomBadge

#pragma mark - Initialization

- (id)initWithString:(NSString *)badgeString withScale:(CGFloat)scale withShining:(BOOL)shining
{
	self = [super initWithFrame:CGRectMake(0.0f, 0.0f, BADGE_WIDTH, BADGE_HEIGHT)];
    
	if(self) {
		self.contentScaleFactor = [[UIScreen mainScreen] scale];
		self.backgroundColor = [UIColor clearColor];
		_badgeText = badgeString;
		_badgeTextColor = [UIColor whiteColor];
		_badgeFrame = NO;
		_badgeFrameColor = nil;
        //
		//_badgeInsetColor =  [UIColor colorWithRed:1.0f green:0.22f blue:0.22f alpha:1.0f]; // iOS 7 red
        _badgeInsetColor =  [UIColor blueColor]; //小红点背景颜色

        
		_badgeCornerRoundness = 0.4f;
		_badgeScaleFactor = scale;
		_badgeShining = shining;
        _badgeShadow = NO;
		[self autoBadgeSizeWithString:badgeString];		
	}
    
	return self;
}

- (id)initWithString:(NSString *)badgeString
     withStringColor:(UIColor *)stringColor
      withInsetColor:(UIColor *)insetColor
      withBadgeFrame:(BOOL)badgeFrameYesNo
 withBadgeFrameColor:(UIColor *)frameColor
           withScale:(CGFloat)scale
         withShining:(BOOL)shining
          withShadow:(BOOL)shadow
{
	self = [super initWithFrame:CGRectMake(0.0f, 0.0f, BADGE_WIDTH, BADGE_HEIGHT)];
    
	if(self) {
		self.contentScaleFactor = [[UIScreen mainScreen] scale];
		self.backgroundColor = [UIColor clearColor];
		_badgeText = badgeString;
		_badgeTextColor = stringColor;
		_badgeFrame = badgeFrameYesNo;
		_badgeFrameColor = frameColor;
		_badgeInsetColor = insetColor;
		_badgeCornerRoundness = 0.4f;
		_badgeScaleFactor = scale;
		_badgeShining = shining;
        _badgeShadow = shadow;
		[self autoBadgeSizeWithString:badgeString];
	}
    
	return self;
}

- (void)dealloc
{
    _badgeText = nil;
    _badgeTextColor = nil;
    _badgeInsetColor = nil;
    _badgeFrameColor = nil;
}

#pragma mark - Class initializers

+ (BTCustomBadge *) customBadgeWithString:(NSString *)badgeString
{
	return [[BTCustomBadge alloc] initWithString:badgeString withScale:1.0f withShining:NO];
}

+ (BTCustomBadge *) customBadgeWithString:(NSString *)badgeString
                          withStringColor:(UIColor *)stringColor
                           withInsetColor:(UIColor *)insetColor
                           withBadgeFrame:(BOOL)badgeFrameYesNo
                      withBadgeFrameColor:(UIColor *)frameColor
                                withScale:(CGFloat)scale
                              withShining:(BOOL)shining
                               withShadow:(BOOL)shadow
{
	return [[BTCustomBadge alloc] initWithString:badgeString
                                 withStringColor:stringColor
                                  withInsetColor:insetColor
                                  withBadgeFrame:badgeFrameYesNo
                             withBadgeFrameColor:frameColor
                                       withScale:scale
                                     withShining:shining
                                      withShadow:shadow];
}

#pragma mark - Utilities

- (void)autoBadgeSizeWithString:(NSString *)badgeString
{
	CGSize retValue;
	CGFloat rectWidth, rectHeight;
	CGSize stringSize = [badgeString sizeWithFont:[UIFont boldSystemFontOfSize:12.0f]];
	CGFloat flexSpace;
	
    if([badgeString length] >= 3.0f) {
		flexSpace = [badgeString length];
		rectWidth = BADGE_WIDTH + (stringSize.width + flexSpace); rectHeight = BADGE_HEIGHT;
		retValue = CGSizeMake(rectWidth * _badgeScaleFactor, rectHeight * _badgeScaleFactor);
	}
    else {
		retValue = CGSizeMake(BADGE_WIDTH * _badgeScaleFactor, BADGE_HEIGHT * _badgeScaleFactor);
	}
	
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, retValue.width, retValue.height);
	_badgeText = badgeString;
	
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	[self drawRoundedRectWithContext:context inRect:rect];
	
	if(self.badgeShining)
		[self drawShineWithContext:context inRect:rect];
	
	if(self.badgeFrame)
		[self drawFrameWithContext:context inRect:rect];
	
	if([self.badgeText length] > 0.0f) {
        
		[self.badgeTextColor set];
		CGFloat sizeOfFont = LABEL_TEXT_FONT * self.badgeScaleFactor;
		
        if([self.badgeText length] < 2.0f) {
			sizeOfFont += sizeOfFont * 0.2f;
		}
        
		UIFont *textFont = [UIFont boldSystemFontOfSize:sizeOfFont];
		CGSize textSize = [self.badgeText sizeWithFont:textFont];
		
        [self.badgeText drawAtPoint:CGPointMake((rect.size.width/2.0f - textSize.width/2.0f),
                                                (rect.size.height/2.0f - textSize.height/2.0f))
                           withFont:textFont];
	}
}

- (void)drawRoundedRectWithContext:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextSaveGState(context);
	
	CGFloat radius = CGRectGetMaxY(rect) * self.badgeCornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect) * 0.1f;
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
		
    CGContextBeginPath(context);
	CGContextSetFillColorWithColor(context, [self.badgeInsetColor CGColor]);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2.0f), 0.0f, 0.0f);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0.0f, M_PI/2.0f, 0.0f);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2.0f, M_PI, 0.0f);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2.0f, 0.0f);

    if(self.badgeShadow) {
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(0.0f, 1.0f),
                                    2.0f,
                                    [UIColor colorWithWhite:0.0f alpha:0.75f].CGColor);
    }

    CGContextFillPath(context);

	CGContextRestoreGState(context);
}

- (void)drawShineWithContext:(CGContextRef)context inRect:(CGRect)rect
{
	CGContextSaveGState(context);
 
	CGFloat radius = CGRectGetMaxY(rect) * self.badgeCornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect) * 0.1f;
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
    
	CGContextBeginPath(context);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2.0f), 0.0f, 0.0f);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0.0f, M_PI/2.0f, 0.0f);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2.0f, M_PI, 0.0f);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2.0f, 0.0f);
	CGContextClip(context);
	
	size_t num_locations = 2.0f;
	CGFloat locations[2] = { 0.0f, 0.4f };
	CGFloat components[8] = { 0.92f, 0.92f, 0.92f, 1.0f, 0.82f, 0.82f, 0.82f, 0.4f };

	CGColorSpaceRef cspace;
	CGGradientRef gradient;
	cspace = CGColorSpaceCreateDeviceRGB();
	gradient = CGGradientCreateWithColorComponents(cspace, components, locations, num_locations);
	
	CGPoint sPoint, ePoint;
	sPoint.x = 0.0f;
	sPoint.y = 0.0f;
	ePoint.x = 0.0f;
	ePoint.y = maxY;
	CGContextDrawLinearGradient (context, gradient, sPoint, ePoint, 0.0f);
	
	CGColorSpaceRelease(cspace);
	CGGradientRelease(gradient);
	
	CGContextRestoreGState(context);	
}

- (void)drawFrameWithContext:(CGContextRef)context inRect:(CGRect)rect
{
	CGFloat radius = CGRectGetMaxY(rect) * self.badgeCornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect) * 0.1f;
	
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
	
    CGContextBeginPath(context);
	CGFloat lineSize = 2.0f;
    
	if(self.badgeScaleFactor > 1.0f) {
		lineSize += self.badgeScaleFactor * 0.25f;
	}
    
	CGContextSetLineWidth(context, lineSize);
	CGContextSetStrokeColorWithColor(context, [self.badgeFrameColor CGColor]);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI + (M_PI/2.0f), 0.0f, 0.0f);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0.0f, M_PI/2.0f, 0.0f);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2.0f, M_PI, 0.0f);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2.0f, 0.0f);
	
    CGContextClosePath(context);
	CGContextStrokePath(context);
}

@end