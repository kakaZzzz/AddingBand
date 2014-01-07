//
//  BTSheetPickerview.m
//  TestDatePicker
//
//  Created by wangpeng on 13-12-25.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import "BTSheetPickerview.h"
#import "BTAppDelegate.h"
#import "LayoutDef.h"

@implementation BTSheetPickerview

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithPikerType:(BTActionSheetPickerStyle)actionStyle referView:(UIView *)referView delegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.actionSheetPickerStyle = actionStyle;
        
        if (referView) {
            self.referView = referView;
            
        }
        
        if (delegate) {
            self.delegate = delegate;
        }
        
       
        [self setupWithPickerType:actionStyle];
        
        
    }
    return self;
    
}
- (id)initWithPikerType:(BTActionSheetPickerStyle)actionStyle referView:(UIView *)referView delegate:(id)delegate title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.actionSheetPickerStyle = actionStyle;
        
        if (referView) {
            self.referView = referView;
            
        }
        
        if (delegate) {
            self.delegate = delegate;
        }
        if (title) {
            self.title = title;
        }
       
        [self setupWithPickerType:actionStyle];
        
        
    }
    return self;

}
- (void)setupWithPickerType:(BTActionSheetPickerStyle)actionStyle;
{
    
    
    UIWindow *shareWindow =((BTAppDelegate *)[[UIApplication sharedApplication] delegate]).window;
   // self.frame = CGRectMake(0, self.referView.frame.size.height - 320, 320, 320);
    
    if (actionStyle == BTActionSheetPickerStyleDateAndTimePicker) {
        self.frame = CGRectMake(0, shareWindow.frame.size.height - 320, 320, 320);
        
        self.backgroundColor = [UIColor whiteColor];
        
        //取消按钮
        self.enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterButton.frame = CGRectMake(270, 0, 50, 50);
        [self.enterButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.enterButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.enterButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.enterButton];
        
        //各种小标签
        UIImageView *clockImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        clockImage.backgroundColor = [UIColor blueColor];
        [self addSubview:clockImage];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(clockImage.frame.origin.x + clockImage.frame.size.width, clockImage.frame.origin.y, 200, 40)];
        titleLabel.backgroundColor = [UIColor yellowColor];
        titleLabel.text = @"产检提醒设置";
        [self addSubview:titleLabel];
        
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(clockImage.frame.origin.x , clockImage.frame.origin.y + clockImage.frame.size.height + 10, 320, 60)];
        contentLabel.backgroundColor = [UIColor orangeColor];
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.text = @"选择下次产检时间吧，我们会为你制定贴心的提醒";
        [self addSubview:contentLabel];

    }
    if (actionStyle == BTActionSheetPickerStyleDatePicker) {
        self.frame = CGRectMake(0, shareWindow.frame.size.height - 266, 320, 266);
        
        self.backgroundColor = [UIColor whiteColor];
        
//        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancelButton.frame = CGRectMake(0, 0, 50, 50);
//        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//        [cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:cancelButton];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(36/2, 10, 200, 30)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:FIRST_TITLE_SIZE];
        _titleLabel.textColor = kBigTextColor;
        _titleLabel.text = _title;
        [self addSubview:_titleLabel];
        NSLog(@"标题到底是多少呢 啊-----  %@",_title);
        
        self.enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterButton.frame = CGRectMake(270, 0, 50, 50);
        [self.enterButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.enterButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.enterButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.enterButton];
        
        
        
    }

    if (actionStyle == BTActionSheetPickerStyleTextPicker) {
        self.frame = CGRectMake(0, shareWindow.frame.size.height - 266, 320, 266);
        
        self.backgroundColor = [UIColor whiteColor];
        self.enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterButton.frame = CGRectMake(270, 0, 50, 50);
        [self.enterButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.enterButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.enterButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.enterButton];


    }
    
    //时间选择器
    switch (actionStyle) {
        case BTActionSheetPickerStyleDateAndTimePicker:
        {
            self.datePicker = [[UIDatePicker alloc] init];
            _datePicker.frame = CGRectMake(0, self.frame.size.height - 216, 320, 216);
            NSLog(@"--------------%@",NSStringFromCGRect(_datePicker.frame));
            _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            [self addSubview:_datePicker];

        }
            break;
        case BTActionSheetPickerStyleDatePicker:
        {
            self.datePicker = [[UIDatePicker alloc] init];
            _datePicker.frame = CGRectMake(0, self.frame.size.height - 216, 320, 216);
            NSLog(@"--------------%@",NSStringFromCGRect(_datePicker.frame));
            _datePicker.datePickerMode = UIDatePickerModeDate;
            [self addSubview:_datePicker];
            
        }
            break;

        case BTActionSheetPickerStyleTextPicker:
        {
            self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 216, 320, 216)];
            [_pickerView sizeToFit];
            [_pickerView setShowsSelectionIndicator:YES];
            [_pickerView setDelegate:self];
            [_pickerView setDataSource:self];
            [self addSubview:_pickerView];
        }
            break;
        default:
            break;
    }

 
}
- (void)cancelButtonClicked:(UIButton *)button
{
    [self hide];
}
- (void)closeButtonClicked:(UIButton *)button
{
    //确定 了日期
    
     switch (self.actionSheetPickerStyle) {
        case BTActionSheetPickerStyleDateAndTimePicker:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(actionSheetPickerView:didSelectDate:)]) {
                [_delegate performSelector:@selector(actionSheetPickerView:didSelectDate:) withObject:self withObject:_datePicker.date];
            }
            
        }
            break;
         case BTActionSheetPickerStyleDatePicker:
         {
             if (_delegate && [_delegate respondsToSelector:@selector(actionSheetPickerView:didSelectDate:)]) {
                 [_delegate performSelector:@selector(actionSheetPickerView:didSelectDate:) withObject:self withObject:_datePicker.date];
             }
             
         }
             break;
        case BTActionSheetPickerStyleTextPicker:
        {
            if ([self.delegate respondsToSelector:@selector(actionSheetPickerView:didSelectTitles:)])
            {
                NSMutableArray *selectedTitles = [[NSMutableArray alloc] init];
                
               
                    for (NSInteger component = 0; component<_pickerView.numberOfComponents; component++)
                    {
                        NSInteger row = [_pickerView selectedRowInComponent:component];
                        
                        if (row!= -1)
                        {
                            [selectedTitles addObject:[[_titlesForComponenets objectAtIndex:component] objectAtIndex:row]];
                        }
                        else
                        {
                            [selectedTitles addObject:[NSNull null]];
                        }
                    }
                
              
                
                [self.delegate actionSheetPickerView:self didSelectTitles:selectedTitles];
            }
        }
           // [self dismissWithClickedButtonIndex:0 animated:YES];
            break;
        default:
            break;
    }

  
    
    [self hide];
    
}
#pragma mark - 当不是日期的时候 要走下面的方法
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    //If having widths
    if (_widthsForComponents)
    {
        //If object isKind of NSNumber class
        if ([[_widthsForComponents objectAtIndex:component] isKindOfClass:[NSNumber class]])
        {
            CGFloat width = [[_widthsForComponents objectAtIndex:component] floatValue];
            
            //If width is 0, then calculating it's size.
            if (width == 0)
                return ((pickerView.bounds.size.width-20)-2*(_titlesForComponenets.count-1))/_titlesForComponenets.count;
            //Else returning it's width.
            else
                return width;
        }
        //Else calculating it's size.
        else
            return ((pickerView.bounds.size.width-20)-2*(_titlesForComponenets.count-1))/_titlesForComponenets.count;
    }
    //Else calculating it's size.
    else
    {
        return ((pickerView.bounds.size.width-20)-2*(_titlesForComponenets.count-1))/_titlesForComponenets.count;
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [_titlesForComponenets count];
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[_titlesForComponenets objectAtIndex:component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[_titlesForComponenets objectAtIndex:component] objectAtIndex:row];
}

//滚轮的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
   
}




- (void)show
{
    
    if (self.isShow) {
        return;
        
    }
    NSLog(@"+++++++%d",_isShow);

    UIWindow *shareWindow =((BTAppDelegate *)[[UIApplication sharedApplication] delegate]).window;
    
        self.coverView = [[UIView alloc] initWithFrame:shareWindow.bounds];
        self.coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.coverView.backgroundColor = [UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5];
    if (self.actionSheetPickerStyle == BTActionSheetPickerStyleDateAndTimePicker) {
         [shareWindow addSubview:self.coverView];
    }
    

   
    
    
     [shareWindow addSubview:self];
    
      self.isShow = YES;
       [UIView animateWithDuration:kModalViewAnimationDuration animations:^{
           
     CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    [self.referView setTransform:t];

        self.alpha = 1;
        self.coverView.alpha = 1;
        
        
    }];
    
}

- (void)hide
{
    if (!self.isShow) {
        return;
        
    }
    
    [UIView animateWithDuration:kModalViewAnimationDuration animations:^{
        self.alpha = 0;
        self.coverView.alpha = 0;
       // CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        CGAffineTransform t = CGAffineTransformIdentity;

        [self.referView setTransform:t];

        
    } completion:^(BOOL finished) {
        self.isShow = NO;
        [self removeFromSuperview];
        [self.coverView removeFromSuperview];
        
    }];
    
}
@end
