//
//  AppDelegate.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AppDelegate.h"
#import "JinnLockViewController.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:2.0];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *token=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"token"]];
    NSLog(@"%@",token);
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
       
        //如果是第一次启动的话,使用UserGuideViewController (用户引导页面) 作为根视图
        UserGuideViewController *userGuideViewController = [[UserGuideViewController alloc] init];
        self.window.rootViewController = userGuideViewController;
        [userGuideViewController release];
    }else if(token.length==0||[token isEqualToString:@"(null)"]){
      
        //如果不是第一次启动的话,使用LoginViewController作为根视图
        ViewController *VC = [[ViewController alloc] init];
        self.window.rootViewController = VC;
       
    }else{
        
        if ([JinnLockTool isGestureUnlockEnabled])
        {
            JinnLockViewController *lockViewController = [[JinnLockViewController alloc] initWithDelegate:nil
                                                                                                     type:JinnLockTypeVerify
                                                                                               appearMode:JinnLockAppearModePresent];
            self.window.rootViewController =lockViewController;
        }else{
        [ZxdObject rootController];
        }
   }

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //创建并初始化一个引擎对象
    BMKMapManager *manager = [[BMKMapManager alloc] init];
    //启动地图引擎
BOOL success=[manager start:@"KKLHXDn0aDkN9PHzbAKB7cCcArMX1U7h" generalDelegate:nil];
    
    if (!success) {
        NSLog(@"失败");
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
