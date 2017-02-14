//
//  AppDelegate.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AppDelegate.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:4.0];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
        //如果是第一次启动的话,使用UserGuideViewController (用户引导页面) 作为根视图
        UserGuideViewController *userGuideViewController = [[UserGuideViewController alloc] init];
        self.window.rootViewController = userGuideViewController;
        [userGuideViewController release];
    }
//    else
//    {
//        NSLog(@"不是第一次启动");
//        //如果不是第一次启动的话,使用LoginViewController作为根视图
//        ViewController *VC = [[ViewController alloc] init];
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        NSString *name = [userDefault objectForKey:@"name"];
//        if (name == nil){
//            self.window.rootViewController = VC;
//            [VC release];
//            
//        }
        else{
            
//            ViewController *VC = [[ViewController alloc] init];
//            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//            NSString *name = [userDefault objectForKey:@"name"];
//            NSLog(@"账号是:%@",name);
            NSArray *selectedArr = @[@"zihome",@"zilianxiren",@"zishezhi"]  ;
            NSArray *unSeleceArr = @[@"huihome",@"huilianxiren",@"huishezhi"] ;
            NSArray *titleArr = @[@"首页",@"联系人",@"设置"] ;
            
            
            XCQ_tabbarViewController *xcq_tab = [[XCQ_tabbarViewController alloc]initWithNomarImageArr:unSeleceArr
                                                                                     andSelectImageArr:selectedArr
                                                                                           andtitleArr:titleArr];
            xcq_tab.modalTransitionStyle =UIModalTransitionStyleCrossDissolve ;
            
            self.window.rootViewController = xcq_tab ;
            
        }
        
   // }
    

    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];

    
    
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
