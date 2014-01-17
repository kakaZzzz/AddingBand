//
//  BTPersonalDataView.m
//  AddingBand
//
//  Created by wangpeng on 14-1-14.
//  Copyright (c) 2014年 kaka'. All rights reserved.
//

#import "BTPersonalDataView.h"
#import "BTView.h"
#import "LayoutDef.h"
#import "IQKeyBoardManager.h"
#import "BTSheetPickerview.h"
#import "NSDate+DateHelper.h"
#import "BTUtils.h"
#import "IQSegmentedNextPrevious.h"
#import "BTGetData.h"
#import "BTUserSetting.h"
static int selectedTextFieldTag = 0;
@interface BTPersonalDataView ()

@end

@implementation BTPersonalDataView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
  
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backButton.hidden = YES;
    self.scrollView.scrollEnabled = NO;
    [self addSubviews];
	// Do any additional setup after loading the view.
}
- (void)addSubviews
{
    
    
    UIView *navigationBgView = [[UIView alloc]init];
    if (IOS7_OR_LATER) {
        navigationBgView.frame = CGRectMake(0, 0, 320, 90/2 + 20);
    }
    
    else
    {
        navigationBgView.frame = CGRectMake(0, 0, 320, 90/2);
    }
    navigationBgView.backgroundColor = kGlobalColor;
    [self.view addSubview:navigationBgView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100)/2, (navigationBgView.frame.size.height - 20)/2 + 5, 100, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"体征信息";
    [navigationBgView addSubview:titleLabel];
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.frame = CGRectMake((self.view.frame.size.width - 100/2) - 10,(navigationBgView.frame.size.height - 48/2)/2 + 5, 100/2, 48/2);
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(completeInput:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBgView addSubview:completeButton];
    


    //birthday
    BTView *aView= [[BTView alloc] initWithFrame:CGRectMake(0, navigationBgView.frame.origin.y + navigationBgView.frame.size.height, 320, 50)];
    aView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:aView];
    //
    UIImageView * birthdayImage = [[UIImageView alloc] initWithFrame:CGRectMake(36/2, (aView.frame.size.height - 20)/2, 20, 20)];
    birthdayImage.image = [UIImage imageNamed:@"setting_birthday_icon"];
    [aView addSubview:birthdayImage];
    
    self.birthdayText = [[UITextField alloc] initWithFrame:CGRectMake((aView.frame.size.width - 250)/2, (aView.frame.size.height - 40)/2, 250, 40)];
    _birthdayText.textColor = kContentTextColor;
    _birthdayText.backgroundColor = [UIColor clearColor];
    _birthdayText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _birthdayText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _birthdayText.tag = TEXTFIELD_TAG + 3;
    _birthdayText.returnKeyType = UIReturnKeyDone;
    _birthdayText.delegate = self;
    _birthdayText.keyboardType = UIKeyboardTypeDecimalPad;
     _birthdayText.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _birthdayText.placeholder = @"生日";
    _birthdayText.textAlignment = NSTextAlignmentCenter;
    [_birthdayText addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];

    [aView addSubview:_birthdayText];

    
    // menstrual
    BTView *bView= [[BTView alloc] initWithFrame:CGRectMake(0, aView.frame.origin.y + aView.frame.size.height, 320, 50)];
    bView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bView];
    //
    UIImageView * menstrualImage = [[UIImageView alloc] initWithFrame:CGRectMake(36/2, (bView.frame.size.height - 20)/2, 20, 20)];
    menstrualImage.image = [UIImage imageNamed:@"setting_menstrual_icon"];
    [bView addSubview:menstrualImage];
    
    self.menstrualText = [[UITextField alloc] initWithFrame:CGRectMake((bView.frame.size.width - 250)/2, (bView.frame.size.height - 40)/2, 250, 40)];
    _menstrualText.textColor = kContentTextColor;
    _menstrualText.backgroundColor = [UIColor clearColor];
    _menstrualText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _menstrualText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _menstrualText.tag = TEXTFIELD_TAG + 4;
    _menstrualText.returnKeyType = UIReturnKeyDone;
    _menstrualText.delegate = self;
    _menstrualText.keyboardType = UIKeyboardTypeDecimalPad;
    _menstrualText.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _menstrualText.placeholder = @"末次月经时间";
    _menstrualText.textAlignment = NSTextAlignmentCenter;
    [_menstrualText addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];

    [bView addSubview:_menstrualText];

    //duedate
    BTView *cView= [[BTView alloc] initWithFrame:CGRectMake(0, bView.frame.origin.y + bView.frame.size.height, 320, 50)];
    cView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cView];
    //
    UIImageView * duedateImage = [[UIImageView alloc] initWithFrame:CGRectMake(36/2, (cView.frame.size.height - 20)/2, 20, 20)];
    duedateImage.image = [UIImage imageNamed:@"setting_duedate_icon"];
    [cView addSubview:duedateImage];
    
    self.duedateText = [[UITextField alloc] initWithFrame:CGRectMake((cView.frame.size.width - 250)/2, (cView.frame.size.height - 40)/2, 250, 40)];
    _duedateText.textColor = kContentTextColor;
    _duedateText.backgroundColor = [UIColor clearColor];
    _duedateText.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _duedateText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _duedateText.tag = TEXTFIELD_TAG + 5;
    _duedateText.returnKeyType = UIReturnKeyDone;
    _duedateText.delegate = self;
    _duedateText.keyboardType = UIKeyboardTypeDecimalPad;
    _duedateText.font = [UIFont systemFontOfSize:SECOND_TITLE_SIZE];
    _duedateText.placeholder = @"预产期";
    _duedateText.textAlignment = NSTextAlignmentCenter;
    [_duedateText addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];

    [cView addSubview:_duedateText];

    
    
    
}

#pragma mark - segmentControl
-(void)previousClicked:(UISegmentedControl*)segmentedControl
{
    [(UITextField*)[self.view viewWithTag:selectedTextFieldTag-1] becomeFirstResponder];
}

-(void)nextClicked:(UISegmentedControl*)segmentedControl
{
    [(UITextField*)[self.view viewWithTag:selectedTextFieldTag+1] becomeFirstResponder];
}

-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
    UITextField *field = (UITextField*)[self.view viewWithTag:selectedTextFieldTag];
    NSDate *localDate = [NSDate localdateByDate:self.datePicker.date];
    NSNumber *year = [BTUtils getYear:localDate];
    NSNumber *month = [BTUtils getMonth:localDate];
    NSNumber *day = [BTUtils getDay:localDate];
    NSString *dateString = [NSString stringWithFormat:@"%@.%@.%@",year,month,day];
    
    field.text = dateString;

}

- (void)textFieldDidBeginEditing:(UITextField *)aTextField{
    
    selectedTextFieldTag = aTextField.tag;
    [self showDatePicker];
    UITextField *field = (UITextField*)[self.view viewWithTag:selectedTextFieldTag];
    field.inputView = self.datePicker;
 

}
- (void)showDatePicker
{
    if (self.datePicker == nil) {
        self.datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame = CGRectMake(0, self.view.frame.size.height - 216, 320, 216);
        [_datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [self.view addSubview:_datePicker];
    }
   
}
- (void)dateChanged
{
    UITextField *field = (UITextField*)[self.view viewWithTag:selectedTextFieldTag];
    NSDate *localDate = [NSDate localdateByDate:self.datePicker.date];
    NSNumber *year = [BTUtils getYear:localDate];
    NSNumber *month = [BTUtils getMonth:localDate];
    NSNumber *day = [BTUtils getDay:localDate];
    NSString *dateString = [NSString stringWithFormat:@"%@.%@.%@",year,month,day];
    
    field.text = dateString;
}



- (void)completeInput:(UIButton *)btn
{
    if ([self isCompleted]) {
        //写入coredata
        [self writeToCoredataWithBirthday:_birthdayText.text menstruation:_menstrualText.text dueDate:_duedateText.text];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    else{
        UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善数据" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil ,nil];
        [alertview show];

    }
}
#pragma mark - 判断每个输入框是否都输完了
- (BOOL)isCompleted
{
    if (![_birthdayText.text isEqualToString:@""] && ![_menstrualText.text isEqualToString:@""] && ![_duedateText.text isEqualToString:@""]) {
        return YES;
    }
    else
        return NO;
    
    
    
}
#pragma mark - 往coredata里面写入数据 此coredata是 BTUerSetting
- (void)writeToCoredataWithBirthday:(NSString *)birthday menstruation:(NSString *)menstruation dueDate:(NSString *)duedate
{
    
    
    NSManagedObjectContext *context = [BTGetData getAppContex];
    //设置查询条件
    NSError *error;
    NSArray *dataArray = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    
    if (dataArray.count == 1) {
        
        //已经有条目了
        //进行coredata的更改数据操作
        BTUserSetting* one = [dataArray objectAtIndex:0];
        one.birthday = birthday;
        one.menstruation = menstruation;
        one.dueDate = duedate;
        
    }
    
    else if(dataArray.count == 0){
        
        //木有啊,就新建一条  进行coredata的插入数据操作
        
        NSLog(@"there no");
        
        BTUserSetting *new = [NSEntityDescription insertNewObjectForEntityForName:@"BTUserSetting" inManagedObjectContext:context];
        new.birthday = birthday;
        new.menstruation = menstruation;
        new.dueDate = duedate;
        
    }
    
    [context save:&error];
    // 及时保存
    if(![context save:&error]){
        NSLog(@"%@", [error localizedDescription]);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

/*Additional Function*/
@implementation UITextField(ToolbarOnDatePiker)

#pragma mark - Toolbar on Datepicker

-(void)addPreviousNextDoneOnDatepickerWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction;
{
    //Creating a toolBar for phoneNumber keyboard
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    //Create a fake button to maintain flexibleSpace between doneButton and nilButton. (Actually it moves done button to right side.
    UIBarButtonItem *nilButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //Create a button to show on phoneNumber keyboard to resign it. Adding a selector to resign it.
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:target action:doneAction];
    
    IQSegmentedNextPrevious *segControl = [[IQSegmentedNextPrevious alloc] initWithTarget:target previousSelector:previousAction nextSelector:nextAction];
    //
    UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:segControl];
    
    //Adding button to toolBar.
    [toolbar setItems:[NSArray arrayWithObjects: segButton,nilButton,doneButton, nil]];
    //    [toolbar setItems:[NSArray arrayWithObjects: previousButton,nextButton,nilButton,doneButton, nil]];
    
    //Setting toolbar to textFieldPhoneNumber keyboard.
    [self setInputAccessoryView:toolbar];
}

-(void)setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled
{
    UIToolbar *inputView = (UIToolbar*)[self inputAccessoryView];
    
    if ([inputView isKindOfClass:[UIToolbar class]] && [[inputView items] count]>0)
    {
        UIBarButtonItem *barButtonItem = (UIBarButtonItem*)[[inputView items] objectAtIndex:0];
        
        if ([barButtonItem isKindOfClass:[UIBarButtonItem class]] && [barButtonItem customView] != nil)
        {
            UISegmentedControl *segmentedControl = (UISegmentedControl*)[barButtonItem customView];
            
            if ([segmentedControl isKindOfClass:[UISegmentedControl class]] && [segmentedControl numberOfSegments]>1)
            {
                [segmentedControl setEnabled:isPreviousEnabled forSegmentAtIndex:0];
                
                [segmentedControl setEnabled:isNextEnabled forSegmentAtIndex:1];
            }
        }
    }
}


@end

