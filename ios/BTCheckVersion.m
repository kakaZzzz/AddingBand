//
//  BTCheckVersion.m
//  TestNetwork
//
//  Created by wangpeng on 13-11-14.
//  Copyright (c) 2013年 wangpeng. All rights reserved.
//

#import "BTCheckVersion.h"
#import "VersionConstant.h"
#import "MKNetworkKit.h"

#define kHarpyCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]

@interface BTCheckVersion ()

+ (void)showAlertWithAppStoreVersion:(NSString*)appStoreVersion;

@end

@implementation BTCheckVersion

#pragma mark - Public Methods
+ (void)checkVersion
{
    
    // Asynchronously query iTunes AppStore for publically available version
    
    
    //用MKNetworkKit进行异步网络请求
    /*GET请求 示例*/
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"itunes.apple.com" customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:[NSString stringWithFormat:@"lookup?id=%@", kHarpyAppID] params:nil httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingAllowFragments error:nil];
        //回到主线程去做事情
        dispatch_async(dispatch_get_main_queue(), ^{
            // All versions that have been uploaded to the AppStore
            NSArray *versionsInAppStore = [[resultDic valueForKey:@"results"] valueForKey:@"version"];
            NSLog(@"答了答了答了%@",versionsInAppStore);
            if ( ![versionsInAppStore count] ) {
                // No versions of app in AppStore
                
                return;
                
            } else {
                
                NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                
                if ([kHarpyCurrentVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
                    
                    [BTCheckVersion showAlertWithAppStoreVersion:currentAppStoreVersion];
                    
                }
                else {
                    
                    // Current installed version is the newest public version or newer
                    
                }
            }
            
        });
        //请求数据错误
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork request error------ : %@", [err localizedDescription]);
    }];
    [engine enqueueOperation:op];
    
    
}

#pragma mark - Private Methods
+ (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion
{
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    if ( harpyForceUpdate ) { // Force user to update app
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                            message:[NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.", appName, currentAppStoreVersion]
                                                           delegate:self
                                                  cancelButtonTitle:kHarpyUpdateButtonTitle
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
        
    } else { // Allow user option to update next time user launches your app
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                            message:[NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.", appName, currentAppStoreVersion]
                                                           delegate:self
                                                  cancelButtonTitle:kHarpyCancelButtonTitle
                                                  otherButtonTitles:kHarpyUpdateButtonTitle, nil];
        
        [alertView show];
        
    }
    
}
//https://itunes.apple.com/cn/app/wen-yi-fan/id728220902?mt=8
#pragma mark - UIAlertViewDelegate Methods
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ( harpyForceUpdate ) {
        
        NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
        NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
        [[UIApplication sharedApplication] openURL:iTunesURL];
        
    } else {
        
        switch ( buttonIndex ) {
                
            case 0:{ // Cancel / Not now
                
                // Do nothing
                
            } break;
                
            case 1:{ // Update
                
                NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
                NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                [[UIApplication sharedApplication] openURL:iTunesURL];
                
            } break;
                
            default:
                break;
        }
        
    }
    
    
}

@end
