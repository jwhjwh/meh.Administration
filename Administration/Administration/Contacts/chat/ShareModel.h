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


@property (nonatomic,strong)NSMutableArray *arrayData;

@property (nonatomic,strong)NSString *stringProvince;
@property (nonatomic,strong)NSString *stringCity;
@property (nonatomic,strong)NSString *stringCountry;

@property (nonatomic,strong)NSString *StoreId;//门店信息id

@end
