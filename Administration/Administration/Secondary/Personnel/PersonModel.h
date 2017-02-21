//
//  PersonModel.h
//  Administration
//
//  Created by 九尾狐 on 2017/2/21.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject


/*
 account = 18800000000;
 icon = "images/boss/1484205474610.png";
 id = 307;
 name = "\U4efb\U603b";
 roleId = 1;
 sdasd = "\U65e0\U6240\U5582";
 state = "<null>";
 
 */
@property (strong,nonatomic) NSString *account;//手机号

@property (strong,nonatomic) NSString *icon;//头像

@property (strong,nonatomic) NSString *name;// 姓名

@property (strong,nonatomic) NSString * nameid;//用户id

@property (strong,nonatomic) NSString *roleld;//人员类型

@property (strong,nonatomic) NSString *sdasd;// 个性签名


@end
