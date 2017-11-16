//
//  StoresModel.h
//  Administration
//
//  Created by 九尾狐 on 2017/11/1.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoresModel : NSObject



 @property (nonatomic,strong)NSString *storeName;//点名称
 @property (nonatomic,strong)NSString *province;//省
 @property (nonatomic,strong)NSString *city;//市
 @property (nonatomic,strong)NSString *county;//县
 @property (nonatomic,strong)NSString *address;//详细地址
 @property (nonatomic,strong)NSString *rideInfo;//乘车
 @property (nonatomic,strong)NSString *area;//面积
 @property (nonatomic,strong)NSString *brandBusiness;//其他品牌
 @property (nonatomic,strong)NSString *intentionBrand;//意向品牌
 @property (nonatomic,strong)NSString *berths;//床位数
 @property (nonatomic,strong)NSString *validNumber;//有效顾客信息
 @property (nonatomic,strong)NSString *staffNumber;//员工人数
 @property (nonatomic,strong)NSString *jobExpires;//员工从业年限
 @property (nonatomic,strong)NSString *problems;//存在的优势问题
 @property (nonatomic,strong)NSString *companyInfoId;//所属公司id
 @property (nonatomic,strong)NSString *departmentId;//提交的部门id
 

@end
