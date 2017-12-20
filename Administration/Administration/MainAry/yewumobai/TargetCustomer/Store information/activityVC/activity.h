//
//  activity.h
//  Administration
//
//  Created by 九尾狐 on 2017/11/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface activity : UIViewController
@property (nonatomic,strong)NSString *dateStr; //Summarys    内容
@property (nonatomic) BOOL modifi;

@property (nonatomic,strong)NSString *StoreId;//门店id
@property (nonatomic,strong)NSString *SummaryTypeid;//年份id


@property (nonatomic,strong)NSString *Summaryid;//活动概要id
//Summarys    内容
//Summaryid。活动概要id
//SummaryTypeid。活动概要年份id
//Storeid。 门店id
@property (strong,nonatomic) NSString *strId;

@property (strong,nonatomic) NSString *shopname;

@end
