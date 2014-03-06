//
//  VersionConstant.h
//  TestNetwork
//
//  Created by wang peng on 13-11-14.
//  Copyright (c) 2013年 wang peng rights reserved.
//



/*
 Option 1 (DEFAULT): NO gives user option to update during next session launch
 Option 2: YES forces user to update app on launch
 */
static BOOL harpyForceUpdate = NO;

// 2. Your AppID (found in iTunes Connect)
#define kHarpyAppID                 @"707973933"//APPID

// 3. Customize the alert title and action buttons
#define kHarpyAlertViewTitle        @"Update Available"
#define kHarpyCancelButtonTitle     @"Not now"
#define kHarpyUpdateButtonTitle     @"Update"
