//
//  ModifyVisitModel.h
//  Administration
//
//  Created by 九尾狐 on 2017/9/9.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModifyVisitModel : NSObject

@property (nonatomic,strong)NSString *VisitID;          //意向客户id
@property (nonatomic,strong)NSString *Dates;            //日期
@property (nonatomic,strong)NSString *UsersId;          //创建人
@property (nonatomic,strong)NSString *UsersName;        //创建人姓名
@property (nonatomic,strong)NSString *Iphone;           //手机
@property (nonatomic,strong)NSString *Wcode;            //微信
@property (nonatomic,strong)NSString *BrandBusiness;    //经营品牌
@property (nonatomic,strong)NSString *StoreLevel;       //门店档次
@property (nonatomic,strong)NSString *StoreType;        //门店类型
@property (nonatomic,strong)NSString *PlantingDuration; //经营年限
@property (nonatomic,strong)NSString *BeauticianNU;     //美容师人数
@property (nonatomic,strong)NSString *Berths;           //床位数
@property (nonatomic,strong)NSString *ProjectBrief;     //关注项目及所需要信息简要
@property (nonatomic,strong)NSString *MeetingTime;      //会谈起始时间概要说
@property (nonatomic,strong)NSString *Modified;         //备注
@property (nonatomic,strong)NSString *ShopId;           //店铺id
@property (nonatomic,strong)NSString *Province;         //省
@property (nonatomic,strong)NSString *City;             //市
@property (nonatomic,strong)NSString *County;           //县
@property (nonatomic,strong)NSString *StoreName;        //店名
@property (nonatomic,strong)NSString *Address;          //门店地址
@property (nonatomic,strong)NSString *ShopName;         //店铺负责人姓名

@property (nonatomic,strong)NSString *state; //已升级
@property (nonatomic,strong)NSString *userId;//共享人(后台赋
@property (nonatomic,strong)NSString *departmentId;//提交的部门
@end
/*

 
 
 */
