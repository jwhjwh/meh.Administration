//
//  SubmittedModel.h
//  Administration
//
//  Created by 九尾狐 on 2017/3/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubmittedModel : NSObject

/*
 account = 15600000008;
 dateTimes = "2017-03-07 11:51:05.0";
 describe = q;
 icon = "<null>";
 id = 797;
 name = 8;
 picture = "images/picReport/1488858665825.jpg";
 usersId = 346;
 
 */
@property (nonatomic,strong) NSString *account;//账号

@property (nonatomic,strong) NSString *dateTimes;//日期

@property (nonatomic,strong) NSString *describe;//内容

@property (nonatomic,strong) NSString *icon;//头像

@property (nonatomic,strong) NSString *pid;//id

@property (nonatomic,strong) NSString *name;//姓名

@property (nonatomic,strong)NSString *picture;//报岗图片




@end
