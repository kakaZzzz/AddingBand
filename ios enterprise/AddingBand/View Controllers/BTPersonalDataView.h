//
//  BTPersonalDataView.h
//  AddingBand
//
//  Created by wangpeng on 14-1-14.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import "BTScrollViewController.h"
@class BTSheetPickerview;
@interface BTPersonalDataView : BTScrollViewController<UITextFieldDelegate>
@property(nonatomic,strong)BTSheetPickerview *actionSheetView;
@property(nonatomic,strong)UITextField *birthdayText;
@property(nonatomic,strong)UITextField *menstrualText;
@property(nonatomic,strong)UITextField *duedateText;
@property(nonatomic,strong)UIDatePicker *datePicker;
@end

@interface UITextField (ToolbarOnDatePiker)

//Helper function to add SegmentedNextPrevious and Done button on keyboard.
-(void)addPreviousAndNextAndDoneOnDatepickerWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction;

//Helper methods to enable and desable previous next buttons.
-(void)setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled;


@end
