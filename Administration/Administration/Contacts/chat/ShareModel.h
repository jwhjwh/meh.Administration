//
//  ShareModel.h
//  Administration
//
//  Created by zhang on 2017/8/9.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject
+(ShareModel *)shareModel;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic) BOOL isGroup;
@property (nonatomic) BOOL isDefaultGroup;
@property (nonatomic,strong)NSArray *arrayPosition;
@property (nonatomic,strong)NSString *joinType;
@property (nonatomic,strong)NSString *sort;
@property (nonatomic,strong)NSString *roleID;
@property (nonatomic,strong)NSString *num; //1.市场 2.业务 3.财务 4.客服
@property (nonatomic,strong)NSString *postionName;//职位名称
@property (nonatomic,strong)NSString *departmentID;

@property (nonatomic,strong)NSString *state;


@property (nonatomic,strong)NSMutableArray *arrayData;

@property (nonatomic,strong)NSString *stringProvince;
@property (nonatomic,strong)NSString *stringCity;
@property (nonatomic,strong)NSString *stringCountry;
@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,strong)NSString *StoreId;//门店信息id

@property (nonatomic,strong)NSString *flag;//阴历阳历标记
@property (nonatomic,strong)NSString *stringGregorian; //阳历生日
@property (nonatomic,strong)NSString *stringChinese;  //阴历生日

/*店家跟踪*/

@property (nonatomic,strong)NSDictionary *dictShop;
@property (nonatomic,strong)NSString *shopID;
@property (nonatomic,strong)NSString *storeName;
@property (nonatomic,strong)NSMutableArray *arrayArea;

/*店家管理*/
@property (nonatomic,strong)NSString *wenti;//遇到问题
@property (nonatomic,strong)NSString *jingying; //经营状况
@property (nonatomic,strong)NSString *chaodao; //常到顾客
@property (nonatomic,strong)NSString *tuoke; //拓客计划
@property (nonatomic,strong)NSString *stringArea;
@property (nonatomic,strong)NSString *addressDetil;//详细地址
@property (nonatomic,strong)NSString *dianping; //点评建议

@property (nonatomic,strong)NSString *jiankeng; //顾客身体状况
@property (nonatomic,strong)NSString *zaizuo; //正在做的项目
@property (nonatomic,strong)NSString *teshu; //特殊情况说明
@property (nonatomic,strong)NSString *xiaofei; //消费分析

@property (nonatomic,strong)NSString *techang; //特长
@property (nonatomic,strong)NSString *pingpan; //评判
@property (nonatomic)BOOL showRightItem;
@end
