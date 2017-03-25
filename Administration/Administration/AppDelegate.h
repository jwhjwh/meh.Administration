//
//  AppDelegate.h
//  Administration
//
//  Created by 九尾狐 on 2017/2/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,EMChatManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) XCQ_tabbarViewController *tabbarController;
@end

