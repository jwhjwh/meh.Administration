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
#import <UserNotifications/UserNotifications.h>
#import "AppDelegate+EaseMob.h"
#import "ChatUIHelper.h"
#import "IQKeyboardManager.h"
#import "ViewController.h"
//两次提示的默认间隔//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 2.0;

@interface AppDelegate ()<EMChatManagerDelegate,EMClientDelegate>
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    IQKeyboardManager *managerr = [IQKeyboardManager sharedManager];
    managerr.enable = YES;
    managerr.overrideKeyboardAppearance = YES;
    managerr.shouldResignOnTouchOutside = YES;
    managerr.enableAutoToolbar = YES;
    
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
    EMOptions *options = [EMOptions optionsWithAppkey:@"1126170609115009#jwhdzkereport"];
    options.apnsCertName = @"chatdemoui_dev";
   
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
//创建并初始化一个引擎对象
    BMKMapManager *manager = [[BMKMapManager alloc] init];
    //启动地图引擎
    BOOL success=[manager start:@"FQDQmegyIeDvRlhoshmfZWHCNMSVnwcS" generalDelegate:nil];
    
    if (!success) {
        DDLog(@"失败");
    }
// 3.初始化web缓存配置, appkey需要自己去LeanCloud官网注册存储服务
    [UserWebManager config:launchOptions
                     appId:@"TG0ANDydo2dDbs2mqxSlKCAc-gzGzoHsz"
                    appKey:@"rxuzVo2hSvaidwukDjvxCQpj"];
    return YES;
}

-(void)didReceiveMessages:(NSArray *)aMessages{
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];

        switch (state) {
            case UIApplicationStateActive:
                 [[ChatUIHelper shareHelper] playSoundAndVibration];
                break;
            case UIApplicationStateInactive:
                 [[ChatUIHelper shareHelper] playSoundAndVibration];
                break;
            case UIApplicationStateBackground:
                for(EMMessage *message in aMessages){

                [[ChatUIHelper shareHelper] showNotificationWithMessage:message];
                }   
                break;
            default:
                break;
        }  
}

- (void)userAccountDidLoginFromOtherDevice
{
    // [self _clearHelper];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", @"Prompt") message:NSLocalizedString(@"聊天异地登录", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"确定",@"OK") otherButtonTitles:nil, nil];
    [alertView show];
    [[EMClient sharedClient] logout:YES];
    
    
    ViewController *vc = [[ViewController alloc]init];
    
    [self.window.rootViewController presentViewController:vc animated:YES completion:^{
    
}];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

- (void)applicationWillResignActive:(UIApplication *)application {
   
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (_tabbarController) {
    [_tabbarController jumpToChatList];
   }
    [self easemobApplication:application didReceiveRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (_tabbarController) {
        [_tabbarController didReceiveLocalNotification:notification];
    }
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    [self easemobApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    if (_tabbarController) {
        [_tabbarController didReceiveUserNotification:response.notification];
    }
    completionHandler();
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
