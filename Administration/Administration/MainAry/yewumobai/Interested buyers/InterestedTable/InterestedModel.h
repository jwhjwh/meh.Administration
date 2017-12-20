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
@property (nonatomic,strong)NSString *dates;//日期
@property (nonatomic,strong)NSString *iphone;//手机
@property (nonatomic,strong)NSString *wcode;//微信
@property (nonatomic,strong)NSString *brandBusiness;//经营品牌
@property (nonatomic,strong)NSString *storeLevel;//门店档次
@property (nonatomic,strong)NSString *intentionId;//意向选择
@property (nonatomic,strong)NSString *intentionName;//意向选择名称
@property (nonatomic,strong)NSString *storeSituation;//店名情况简介
@property (nonatomic,strong)NSString *comprehensive;//店家情况综合分析
@property (nonatomic,strong)NSString *departmentId;//提交的部门
@property (nonatomic,strong)NSString *usersId;//创建人(后台赋值)
@property (nonatomic,strong)NSString *userId;//共享人(后台赋值)
@property (nonatomic,strong)NSString *shopId;//店铺id
@property (nonatomic,strong)NSString *province;//省
@property (nonatomic,strong)NSString *city;//市
@property (nonatomic,strong)NSString *county;//县
@property (nonatomic,strong)NSString *storeName;//店名
@property (nonatomic,strong)NSString *address;//门店地址
@property (nonatomic,strong)NSString *shopName;//店铺负责人姓名
@property (nonatomic,strong)NSString *usersName;//业务人员名称
@property (nonatomic,strong)NSString *state;//已升级
@end
