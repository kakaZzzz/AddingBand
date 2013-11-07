//
//  BTSyncViewController.h
//  AddingBand
//
//  Created by kaka' on 13-11-4.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBandCentral.h"

@interface BTSyncViewController : UITableViewController
@property (strong, nonatomic) NSMutableDictionary *dataDictionary;

@property(strong, nonatomic) BTGlobals* g;
@property(strong, nonatomic) BTBandCentral* bc;

@end
