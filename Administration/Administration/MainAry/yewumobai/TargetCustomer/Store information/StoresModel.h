//
//  StoresModel.h
//  Administration
//
//  Created by 九尾狐 on 2017/11/1.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoresModel : NSObject



 @property (nonatomic,strong)NSString *StoreName;//点名称
 @property (nonatomic,strong)NSString *Province;//省
 @property (nonatomic,strong)NSString *City;//市
 @property (nonatomic,strong)NSString *County;//县
 @property (nonatomic,strong)NSString *Address;//详细地址
 @property (nonatomic,strong)NSString *RideInfo;//乘车
 @property (nonatomic,strong)NSString *Area;//面积
 @property (nonatomic,strong)NSString *BrandBusiness;//其他品牌
 @property (nonatomic,strong)NSString *IntentionBrand;//意向品牌
 @property (nonatomic,strong)NSString *Berths;//床位数
 @property (nonatomic,strong)NSString *ValidNumber;//有效顾客信息
 @property (nonatomic,strong)NSString *StaffNumber;//员工人数
 @property (nonatomic,strong)NSString *JobExpires;//员工从业年限
 @property (nonatomic,strong)NSString *Problems;//存在的优势问题
 @property (nonatomic,strong)NSString *CompanyInfoId;//所属公司id
 @property (nonatomic,strong)NSString *DepartmentId;//提交的部门id
 

@end
