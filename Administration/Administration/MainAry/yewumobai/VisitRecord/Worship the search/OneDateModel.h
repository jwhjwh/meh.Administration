//
//  OneDateModel.h
//  Administration
//
//  Created by 九尾狐 on 2017/9/20.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneDateModel : NSObject

@property (strong,nonatomic) NSString *ShopId;//店铺id
@property (strong,nonatomic) NSString *StoreName;//店铺名字
@property (strong,nonatomic) NSString *Province;//省
@property (strong,nonatomic) NSString *City;//市
@property (strong,nonatomic) NSString *County;//区
@property (strong,nonatomic) NSString *Address;//详细地址
@property (strong,nonatomic) NSString *wtime;//时间

@property (strong,nonatomic) NSString *dates;

@end
