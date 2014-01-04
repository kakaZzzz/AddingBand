//
//  BTAppDelegate.m
//  AddingBand
//
//  Created by kaka' on 13-11-1.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import "BTAppDelegate.h"
#import "BTCustomTabBarController.h"
//程序引导页面
#import "BTGuideViewController.h"
//同步页面
#import "BTSyncTwoViewController.h"
#import "BTGetData.h"
#import "BTUserSetting.h"
#import "UMSocialData.h"//友盟分享组件
#import "UMSocial.h"
#import "UMSocialConfig.h"
#import "BTPhysicalStandard.h"
#import "BTGirthStandard.h"
@implementation BTAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
     
    // Override point for customization after application launch.
    //同步页面
    [BTSyncTwoViewController shareSyncTwoview];
    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
    //将tabBarController设置为根视图
    self.tabBarController = [[BTCustomTabBarController alloc] init];
    self.window.rootViewController = _tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    /*程序启动引导页 我给注释掉了 */
    //如果是第一次启动 加载启动页面
    //    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
    //        [BTGuideViewController show];
    //    }
    
    //测试用 默认给一些用户信息
    NSManagedObjectContext *context =[(BTAppDelegate *) [UIApplication sharedApplication].delegate managedObjectContext];
    
    //往context中插入一个对象
    
    NSArray *data = [BTGetData getFromCoreDataWithPredicate:nil entityName:@"BTUserSetting" sortKey:nil];
    if (data.count == 0) {
        BTUserSetting *userSetting = [NSEntityDescription insertNewObjectForEntityForName:@"BTUserSetting" inManagedObjectContext:context];
        userSetting.birthday = @"2012.12.24";
        userSetting.dueDate =  @"2013.12.24";
        userSetting.menstruation =@"2013.12.24";
        // self.contentArray = [NSArray arrayWithObjects:@"",@"13466668888",@"yitu@126.com",@"修改密码",@"",userData.birthday,userData.dueDate,userData.pregnancy,@"",@"",@"",@"", nil];
        [context save:nil];
    }
    
    
    /**
     *  将宫高和腹围数据 写入数据库文件
     */
    //
    [self writeToCoredataWithFundalHeightLimit];
    [self writeToCoredataWithGirthLimit];
   
    
 
    
    
    
//    //分享 注册
//    [ShareSDK registerApp:@"fa5b01a73b0"];
//    
//    /**
//     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
//     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
//     **/
//    [ShareSDK connectSinaWeiboWithAppKey:@"48993404"
//                               appSecret:@"cffc91bba791bdc887684f2ab20c09c3"
//                             redirectUri:@"http://www.sharesdk.cn"];
    
    
    //友盟分享
    [UMSocialData setAppKey:@"52b7fae256240bd52f18fdd2"];
    
    [UMSocialConfig setWXAppId:@"wxd9a39c7122aa6516" url:nil];//微信
    //[WXApi registerApp:@"wxd9a39c7122aa6516"];//微信
    
   // [UMSocialConfig setQQAppId:@"100424468" url:nil importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    return YES;
}
//将宫高写入coredata文件
- (void)writeToCoredataWithFundalHeightLimit
{
    
    
    //宫高 
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:1];
    for (int i = 20; i < 42; i ++) {
        [array1 addObject:[NSNumber numberWithInt:(i - 1)*7]];
    }
    
    NSArray *array2 = [NSArray arrayWithObjects:@"16",@"17",@"18",@"19",@"20",@"21",@"21.5",@"22.5",@"23",@"23.5",@"24",@"25",@"26",@"27",@"27.5",@"28.5",@"29.8",@"29.8",@"29.8",@"29.8",@"29.8",@"29.8", nil];
    
    NSArray *array3 = [NSArray arrayWithObjects:@"20.5",@"21.5",@"22.5",@"23.5",@"24.5",@"25.5",@"26.5",@"27.5",@"28.5",@"29.5",@"30.5",@"31.5",@"32.5",@"33.5",@"34.5",@"34.5",@"34.5",@"34.5",@"34.5",@"34.5",@"34.5",@"34.5", nil];
    
   
    
    NSError *error;
    for (int i = 0; i<22; i ++) {
        BTPhysicalStandard *new = [NSEntityDescription insertNewObjectForEntityForName:@"BTPhysicalStandard" inManagedObjectContext:_managedObjectContext];
        
        new.title = @"宫高";
        new.day = [array1 objectAtIndex:i];
        new.offLimit = [array2 objectAtIndex:i];
        new.onLimit = [array3 objectAtIndex:i];
        
        
        [_managedObjectContext save:&error];
        // 及时保存
        if(![_managedObjectContext save:&error]){
            NSLog(@"%@", [error localizedDescription]);
        }

    }
    
}
//将腹围写入coredata文件
- (void)writeToCoredataWithGirthLimit
{
    
    
    //腹围
     NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:1];
    for (int i = 20; i < 42; i ++) {
        [array1 addObject:[NSNumber numberWithInt:(i - 1)*7]];
    }
    NSArray *array2 = [NSArray arrayWithObjects:@"76",@"77",@"78",@"79",@"80",@"80.5",@"81",@"81.5",@"82",@"82.5",@"83",@"83.5",@"84",@"84.5",@"85",@"85.5",@"86",@"87",@"88",@"89",@"89",@"89",nil];
    
    NSArray *array3 = [NSArray arrayWithObjects:@"89",@"89.5",@"90",@"90.5",@"91",@"91",@"92",@"93",@"94",@"94.5",@"94.5",@"95",@"95",@"96.5",@"97",@"97.5",@"98",@"98.5",@"99",@"99.5",@"100",@"100",nil];
    
    
    
    
    NSError *error;
    for (int i = 0; i<22; i ++) {
        BTGirthStandard *new = [NSEntityDescription insertNewObjectForEntityForName:@"BTGirthStandard" inManagedObjectContext:_managedObjectContext];
        
        new.title = @"宫高";
        new.day = [array1 objectAtIndex:i];
        new.offLimit = [array2 objectAtIndex:i];
        new.onLimit = [array3 objectAtIndex:i];
        
        
        [_managedObjectContext save:&error];
        // 及时保存
        if(![_managedObjectContext save:&error]){
            NSLog(@"%@", [error localizedDescription]);
        }
        
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [UMSocialSnsService  applicationDidBecomeActive];
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    
   // return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation

{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    //return [WXApi handleOpenURL:url delegate:self];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
