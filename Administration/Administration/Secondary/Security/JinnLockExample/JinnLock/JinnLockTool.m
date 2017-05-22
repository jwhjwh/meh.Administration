/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/jinnchang
 **
 **  FileName: JinnLockTool.m
 **  Description: 密码管理工具
 **
 **  History
 **  -----------------------------------------------------------------------------------------------
 **  Author: jinnchang
 **  Date: 16/8/10
 **  Version: 1.0.0
 **  Remark: Create
 **************************************************************************************************/

#import "JinnLockTool.h"
#import "JinnLockConfig.h"
#import "USFmdbTool.h"
#import "Userpas.h"

@implementation JinnLockTool

#pragma mark - 手势密码管理

/**
 *  是否允许手势解锁(应用级别的)
 *
 *  @return
 */
+ (BOOL)isGestureUnlockEnabled
{
    NSString *fuzzyQuerySql = [NSString stringWithFormat:@"SELECT * FROM t_userpas WHERE userid = %@",[USER_DEFAULTS  objectForKey:@"phone"]];
    NSArray *modals = [USFmdbTool queryData:fuzzyQuerySql];
    if(modals.count>0){
       Userpas *model =modals[0];
        if ([model.isopen isEqualToString:@"NO"]) {
           return NO;
        }else{
            return YES;
        }
        
    }else{
         return NO;
    }

//    return [[NSUserDefaults standardUserDefaults] boolForKey:kJinnLockGestureUnlockEnabled];
}

/**
 *  设置是否允许手势解锁功能
 *
 *  @param enabled
 */
+ (void)setGestureUnlockEnabled:(BOOL)enabled
{
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kJinnLockGestureUnlockEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  当前已经设置的手势密码
 *
 *  @return
 */
+ (NSString *)currentGesturePasscode
{
    NSString *fuzzyQuerySql = [NSString stringWithFormat:@"SELECT * FROM t_userpas WHERE userid = %@",[USER_DEFAULTS  objectForKey:@"phone"]];
     NSArray *modals = [USFmdbTool queryData:fuzzyQuerySql];
    Userpas *model =modals[0];
    return model.password;
}

/**
 *  设置新的手势密码
 *
 *  @param passcode
 */
+ (void)setGesturePasscode:(NSString *)passcode
{
   
    [[NSUserDefaults standardUserDefaults] setObject:passcode forKey:kJinnLockPasscode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 指纹解锁管理
/**
 *  是否支持指纹识别(系统级别的)
 *
 *  @return
 */
+ (BOOL)isTouchIdSupported
{
    NSError *error;
    
    return [[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
}
/**
 *  是否允许指纹解锁(应用级别的)
 *
 *  @return
 */
+ (BOOL)isTouchIdUnlockEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kJinnLockTouchIdUnlockEnabled];
}
/**
 *  设置是否允许指纹解锁功能
 *
 *  @param enabled
 */
+ (void)setTouchIdUnlockEnabled:(BOOL)enabled
{
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kJinnLockTouchIdUnlockEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
