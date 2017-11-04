//
//  TargetModel.h
//  Administration
//
//  Created by 九尾狐 on 2017/10/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TargetModel : NSObject
@property (strong,nonatomic) NSString * Id;//目标客户id
@property (strong,nonatomic) NSString * Time; // 拜访日期
@property (strong,nonatomic) NSString * MeetTime; // 拜访时间段
@property (strong,nonatomic) NSString * Num; // 拜访次数
@property (strong,nonatomic) NSString * Principal; // 店铺负责人
@property (strong,nonatomic) NSString * Post; // 职务
@property (strong,nonatomic) NSString * Iphone; // 联系方式
@property (strong,nonatomic) NSString * Qcode; // 微信
@property (strong,nonatomic) NSString * StoreLevel; // 店规模
@property (strong,nonatomic) NSString * Berths; // 床位数
@property (strong,nonatomic) NSString * Beautician; // 美容师人数
@property (strong,nonatomic) NSString * PlantingDuration; // 开店年限
@property (strong,nonatomic) NSString * BrandBusiness; // 主要经营品牌
@property (strong,nonatomic) NSString * FollowBrand; // 关注品牌 // 目前所了解信息
@property (strong,nonatomic) NSString * CustomerNum; // 终端顾客总数量
@property (strong,nonatomic) NSString * ValidNum; // 有质量顾客数量
@property (strong,nonatomic) NSString * BrandPos; // 品牌定位 1.保养 2.功效 3.修复 4.其他
@property (strong,nonatomic) NSString * OtherPos; // 品牌定位的其他
@property (strong,nonatomic) NSString * SinglePrice; // 单品价格
@property (strong,nonatomic) NSString * BoxPrice; // 套盒价格
@property (strong,nonatomic) NSString * CardPrice; // 卡项价格
@property (strong,nonatomic) NSString * PackPrice; // 项目套餐
@property (strong,nonatomic) NSString * Flag; // 本年是否做过大量收现活动
@property (strong,nonatomic) NSString * Demand; // 运营协助需求 //
@property (strong,nonatomic) NSString * ShopQuestion; // 店家问题简述
@property (strong,nonatomic) NSString * Plans; // 品牌介入策略及跟进规划
@property (strong,nonatomic) NSString * Requirement;// 店家要求事项及解决办法
@property (strong,nonatomic) NSString * Notic; // 同事协助须知
@property (strong,nonatomic) NSString * PartnerTime; // 店家预订合作时间
@property (strong,nonatomic) NSString * Scheme; // 执行方案
@property (strong,nonatomic) NSString * Amount; // 合约金额
@property (strong,nonatomic) NSString * PayWay; // 打款方式 1.全款 2.分期 3.其他
@property (strong,nonatomic) NSString * Written; // 填表人
@property (strong,nonatomic) NSString * Manager; // 经理
@property (strong,nonatomic) NSString * ActiveName; // 活动名称
@property (strong,nonatomic) NSString * DealMoney; // 成交金额
@property (strong,nonatomic) NSString * LeastMoney; // 下限
@property (strong,nonatomic) NSString * DealRate; // 成交率
@property (strong,nonatomic) NSString * DepartmentId;// 提交的部门
@property (strong,nonatomic) NSString * ShopId; // 店铺id
@property (strong,nonatomic) NSString * UserId;// 共享人
@property (strong,nonatomic) NSString * Province;// 省
@property (strong,nonatomic) NSString * City;// 市
@property (strong,nonatomic) NSString * County;// 县
@property (strong,nonatomic) NSString * Address;// 门店详细地址
@property (strong,nonatomic) NSString * StoreName;// 店名


@end
