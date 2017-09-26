//
//  InterestedModel.h
//  Administration
//
//  Created by 九尾狐 on 2017/9/25.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterestedModel : NSObject

@property (nonatomic,strong)NSString *Id; //意向客户id
@property (nonatomic,strong)NSString *Dates;//日期
@property (nonatomic,strong)NSString *Iphone;//手机
@property (nonatomic,strong)NSString *Wcode;//微信
@property (nonatomic,strong)NSString *BrandBusiness;//经营品牌
@property (nonatomic,strong)NSString *StoreLevel;//门店档次
@property (nonatomic,strong)NSString *IntentionId;//意向选择
@property (nonatomic,strong)NSString *StoreType;//门店类型
@property (nonatomic,strong)NSString *PlantingDuration;//经营年限
@property (nonatomic,strong)NSString *BeauticianNU;//美容师人数
@property (nonatomic,strong)NSString *Berths;//床位数
@property (nonatomic,strong)NSString *Comprehensive;//店家情况综合分析
@property (nonatomic,strong)NSString *DepartmentId;//提交的部门
@property (nonatomic,strong)NSString *UsersId;//创建人(后台赋值)
@property (nonatomic,strong)NSString *UserId;//共享人(后台赋值)
@property (nonatomic,strong)NSString *ShopId;//店铺id
@property (nonatomic,strong)NSString *Province;//省
@property (nonatomic,strong)NSString *City;//市
@property (nonatomic,strong)NSString *County;//县
@property (nonatomic,strong)NSString *StoreName;//店名
@property (nonatomic,strong)NSString *Address;//门店地址
@property (nonatomic,strong)NSString *ShopName;//店铺负责人姓名
@property (nonatomic,strong)NSString *UsersName;//业务人员名称

@end
