//
//  BTMineViewController.h
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatDatePicker.h"
@interface BTMineViewController : UITableViewController<FlatDatePickerDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSArray *titleArray;//标题数组

@property(nonatomic,strong)NSArray *contentArray;//标题数组

@property (nonatomic, strong) FlatDatePicker *flatDatePicker;//输入选择器
@property (nonatomic, strong) UILabel *pickerLabel;//输入选择器

@property (nonatomic, strong) NSManagedObjectContext *context;//上下文

@end
