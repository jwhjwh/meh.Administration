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
    EMOptions *options = [EMOptions optionsWithAppkey:@"easemob-demo#chatdemoui"];
    options.apnsCertName = @"chatdemoui_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    EMError *error1 = [[EMClient sharedClient] loginWithUsername:@"8001" password:@"111111"];
    if (!error1) {
        DDLog(@"登陆成功");
    }
    //创建并初始化一个引擎对象
    BMKMapManager *manager = [[BMKMapManager alloc] init];
    //启动地图引擎
    BOOL success=[manager start:@"KKLHXDn0aDkN9PHzbAKB7cCcArMX1U7h" generalDelegate:nil];
    
    if (!success) {
        NSLog(@"失败");
    }
    // 3.初始化web缓存配置, appkey需要自己去LeanCloud官网注册存储服务
  
    [UserWebManager config:launchOptions
                     appId:@"TG0ANDydo2dDbs2mqxSlKCAc-gzGzoHsz"
                    appKey:@"rxuzVo2hSvaidwukDjvxCQpj"];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
   
}

// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
  [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
  [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
