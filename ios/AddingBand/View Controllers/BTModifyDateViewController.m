//
//  BTModifyDateViewController.m
//  AddingBand
//
//  Created by wangpeng on 13-12-31.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTModifyDateViewController.h"
#import "BTView.h"
#import "NSDate+DateHelper.h"
#import "BTUtils.h"
#import "BTUserData.h"
#import "BTGetData.h" 
#import "LayoutDef.h"
#import "BTUserSetting.h"
@interface BTModifyDateViewController ()
@property(nonatomic,strong)NSManagedObjectContext *context;
@end

@implementation BTModifyDateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureNavigationbar];
    self.view.backgroundColor = [UIColor yellowColor];
    BTView *aView= [[BTView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    aView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:aView];
    //
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(36/2, (aView.frame.size.height - 20)/2, 20, 20)];
    //根据selfmodifytype显示图片
    switch (self.modifyType) {
        case MODIFY_BIRTHDAY_TYPE:
        {
            self.iconImage.image = [UIImage imageNamed:@"setting_birthday_icon"];
        }
                 break;
        case MODIFY_DUEDATE_TYPE:
        {
         self.iconImage.image = [UIImage imageNamed:@"setting_duedate_icon"];
        }
            break;
        case MODIFY_MENSTRUATION_TYPE:
        {
       self.iconImage.image = [UIImage imageNamed:@"setting_menstrual_icon"];
        }
            break;
        default:
            break;
    }
    [aView addSubview:_iconImage];

    //
    self.dateTextLabel = [[UILabel alloc] initWithFrame:CGRectMake((aView.frame.size.width - 100)/2, (aView.frame.size.height - 40)/2, 100, 40)];
    _dateTextLabel.backgroundColor = [UIColor clearColor];
    _dateTextLabel.textAlignment = NSTextAlignmentCenter;
    _dateTextLabel.text = [self getNewDataFromCoredataWithModifyType:self.modifyType];
    _dateTextLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputDate:)];
    [aView addGestureRecognizer:tap];
    [aView addSubview:_dateTextLabel];
	// Do any additional setup after loading the view.
    
    [self showDatePicker];

}
#pragma mark - 设置导航栏上面的按钮
- (void)configureNavigationbar
{
    self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _backButton.frame = CGRectMake(250, 5, 65, 30);
    
    [_backButton setTitle:@"返回" forState:UIControlStateNormal];//title的值根据定位和和选择而改变
    [_backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    
    // [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backToUpperView:) forControlEvents:UIControlEventTouchUpInside];
    // [_deleteButton setBackgroundImage:[UIImage imageNamed:@"透明.png"] forState:UIControlStateNormal];
    _backButton.tintColor = [UIColor colorWithRed:70/255.0 green:163/255.0 blue:210/255.0 alpha:1];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)_backButton];
}

- (void)backToUpperView:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.actionSheetView hide];
}
- (void)inputDate:(UITapGestureRecognizer *)tap
{
    [self showDatePicker];
}
- (void)showDatePicker
{
    if (self.actionSheetView == nil) {
        self.actionSheetView = [[BTSheetPickerview alloc] initWithPikerType:BTActionSheetPickerStyleDatePicker referView:nil delegate:self];
        
        switch (self.modifyType) {
                
                    case MODIFY_BIRTHDAY_TYPE:
                    {
                        self.actionSheetView = [[BTSheetPickerview alloc] initWithPikerType:BTActionSheetPickerStyleDatePicker
                                                                                  referView:nil
                                                                                   delegate:self
                                                                                      title:@"选择生日日期"];
                    }
                        break;
                    case MODIFY_DUEDATE_TYPE:
                    {
                        self.actionSheetView = [[BTSheetPickerview alloc] initWithPikerType:BTActionSheetPickerStyleDatePicker
                                                                                  referView:nil
                                                                                   delegate:self
                                                                                      title:@"选择预产期日期"];

                    }
                        break;
                    case MODIFY_MENSTRUATION_TYPE:
                    {
                        self.actionSheetView = [[BTSheetPickerview alloc] initWithPikerType:BTActionSheetPickerStyleDatePicker
                                                                                  referView:nil
                                                                                   delegate:self
                                                                                      title:@"选择末次月经日期"];

                    }
                        break;
                    default:
                        break;
                }
    
    }
    
    [_actionSheetView show];
}
#pragma mark - 输入生日，末次月经时间，预产期 日期选择器delegate
- (void)actionSheetPickerView:(BTSheetPickerview *)pickerView didSelectDate:(NSDate*)date
{
    
    NSDate *localDate = [NSDate localdateByDate:date];
   // NSString *dateAndTime = [NSDate stringFromDate:date withFormat:@"yy-MM-dd HH:mm:ss"];
    NSNumber *year = [BTUtils getYear:localDate];
    NSNumber *month = [BTUtils getMonth:localDate];
    NSNumber *day = [BTUtils getDay:localDate];
    
    NSString *dateString = [NSString stringWithFormat:@"%@.%@.%@",year,month,day];
    
    //刷新UI
    self.dateTextLabel.text = dateString;
    //更新数据
    [self writeToCoredataWithModifyType:self.modifyType date:dateString];
    

}
#pragma mark - 往coredata里面写入数据
- (void)writeToCoredataWithModifyType:(int)modifyType date:(NSString *)dateString
{
    
    
    _context = [BTGetData getAppContex];
    NSError *error;
    NSArray *dataArray = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    
    if (dataArray.count == 1) {
        
        //已经有条目了
        //进行coredata的更改数据操作
        BTUserSetting *one = [dataArray objectAtIndex:0];
        switch (modifyType) {
            case MODIFY_BIRTHDAY_TYPE:
                one.birthday = dateString;
                break;
            case MODIFY_DUEDATE_TYPE:
                one.dueDate = dateString;
                break;
            case MODIFY_MENSTRUATION_TYPE:
                one.menstruation = dateString;
                break;

            default:
                break;
        }
       
        
    }else if(dataArray.count == 0){
        
        //木有啊,就新建一条  进行coredata的插入数据操作
        
        NSLog(@"there no");
        
        BTUserSetting* new = [NSEntityDescription insertNewObjectForEntityForName:@"BTUserSetting" inManagedObjectContext:_context];
        switch (modifyType) {
            case MODIFY_BIRTHDAY_TYPE:
                new.birthday = dateString;
                break;
            case MODIFY_DUEDATE_TYPE:
                new.dueDate = dateString;
                break;
            case MODIFY_MENSTRUATION_TYPE:
                new.menstruation = dateString;
                break;
            default:
                break;
        }

        
    }
    
    [_context save:&error];
    // 及时保存
    if(![_context save:&error]){
        NSLog(@"%@", [error localizedDescription]);
    }
    
}

#pragma mark - 从coredata 里面取数据
- (NSString *)getNewDataFromCoredataWithModifyType:(int)modifyType
{
    
    NSArray *dataArray = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    
    if (dataArray.count > 0) {
        
        //已经有条目了
        //进行coredata的更改数据操作
        BTUserSetting *one = [dataArray lastObject];
        switch (modifyType) {
            case MODIFY_BIRTHDAY_TYPE:
                if (one.birthday) {
                     return one.birthday;
                }
                else{
                    return [NSString stringWithFormat:@"%@",@"还未记录"];
                }
                break;
            case MODIFY_DUEDATE_TYPE:
                if (one.dueDate) {
                    return one.dueDate;
                }
                else{
                     return [NSString stringWithFormat:@"%@",@"还未记录"];
                }
                break;
            case MODIFY_MENSTRUATION_TYPE:
                if (one.menstruation) {
                    return one.menstruation;
                }
                else{
                    return [NSString stringWithFormat:@"%@",@"还未记录"];
                }
                break;
            default:
                break;
        }
    }
    
      return [NSString stringWithFormat:@"%@",@"还未记录"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
