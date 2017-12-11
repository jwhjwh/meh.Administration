//
//  RecotdModel.h
//  Administration
//
//  Created by 九尾狐 on 2017/9/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecotdModel : NSObject


@property (strong,nonatomic) NSString *Id;// 陌拜记录id
@property (strong,nonatomic) NSString *dates;//拜访日期
@property (strong,nonatomic) NSString *storeName;//店名
@property (strong,nonatomic) NSString *province;//省
@property (strong,nonatomic) NSString *city;//市
@property (strong,nonatomic) NSString *county;//县
@property (strong,nonatomic) NSString *address;//门店地址

@property (strong,nonatomic) NSString *wtime;//门店地址

@property (strong,nonatomic) NSString *State;//阶段

@property (strong,nonatomic) NSString *UserId;//同事

@property (strong,nonatomic) NSString *DepartmentId;//部门
@end
