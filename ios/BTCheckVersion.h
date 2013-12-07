//
//  BTCheckVersion.h
//  TestNetwork
//
//  Created by wangpeng on 13-11-14.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTCheckVersion : NSObject<UIAlertViewDelegate>
/*
 Checks the installed version of your application against the version currently available on the iTunes store.
 If a newer version exists in the AppStore, it prompts the user to update your app.
 */
+ (void)checkVersion;
@end
