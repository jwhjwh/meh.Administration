//
//  tcModel.h
//  Administration
//
//  Created by 九尾狐 on 2017/10/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tcModel : NSObject
@property (strong,nonatomic) NSString *Id;// 陌拜记录id
@property (strong,nonatomic) NSString *Time;//拜访日期
@property (strong,nonatomic) NSString *StoreName;//店名
@property (strong,nonatomic) NSString *Province;//省
@property (strong,nonatomic) NSString *City;//市
@property (strong,nonatomic) NSString *County;//县
@property (strong,nonatomic) NSString *Address;//门店地址

@property (strong,nonatomic) NSString *ShopId;//门店地址
@end
