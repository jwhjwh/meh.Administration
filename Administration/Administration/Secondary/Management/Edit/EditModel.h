//
//  EditModel.h
//  Administration
//
//  Created by 九尾狐 on 2017/2/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditModel : NSObject

/*
 account = 18800000088; 账号
address = "\U6cb3\U5317\U7701\U77f3\U5bb6\U5e84\U5e02\U8f9b\U96c6\U5e02\U738b\U53e3\U9547\U90ed\U897f\U6751";
 age = 25; 年龄
 birthday = "1992-01-11 00:00:00.0"; 出生
 brandName = "<null>"; 所属品牌
 email = "<null>"; 邮箱
 icon = "images/user/1484185249081.png"; 头像
 id = "<null>";
 idNo = 130185123456780032; 身份证号
 interests = "\U751f\U547d\U5728\U4e8e\U6298\U817e"; 兴趣爱好
 name = "\U9a6c\U817e"; 真实姓名
 qcode = 12345678;      qq
 rname = "<null>";  职位
 roleId = 8;    角色id
 sdasd = "\U751f\U547d\U5728\U4e8e\U6298\U817e"; 个性签名
 usersId = 319;   用户id
 wcode = mateng;  微信
 */
@property (strong,nonatomic) NSString *account;   //账号
@property (strong,nonatomic) NSString *NewName;     //职位
//修改前
@property (strong,nonatomic) NSString *rname;     //职位名字
//修改前
@property (strong,nonatomic) NSString *brandName; //所属品牌

@property (strong,nonatomic) NSString *departmentName; //所属部门

@property (strong,nonatomic) NSString *name;      //真实姓名

@property (strong,nonatomic) NSString *birthday;  //出生年月

@property (strong,nonatomic) NSString *age;       //年龄

@property (strong,nonatomic) NSString *suDepartment;

@property (strong,nonatomic) NSString *glDepartment;

@property (strong,nonatomic) NSString *address;   //现居地址

@property (strong,nonatomic) NSString *wcode;     //微信

@property (strong,nonatomic) NSString *qcode;      //qq号

@property (strong,nonatomic) NSString *interests; //兴趣爱好

@property (strong,nonatomic) NSString *sdasd;     //个性签名

@property (strong,nonatomic) NSString *roleId;     //职位id

@property (strong,nonatomic) NSString *icon;  //头像

@property (assign,nonatomic) NSInteger state; //判别使用状态

@property (assign,nonatomic) NSString *departmentID;//部门id


@property (assign,nonatomic) NSString *LevelName; //类别

@property (assign,nonatomic) NSString *levelID; //类别。phone

@property (assign,nonatomic) NSString *phone;

@property (assign,nonatomic) NSString *isPermission;//权限
@property (assign,nonatomic) NSString *uuid;

@property (assign,nonatomic) NSString *usersid;
@end
