//
//  CalendarDisplyManager.h
//  阳历转阴历
//
//  Created by 孙云飞 on 2016/11/3.
//  Copyright © 2016年 孙云飞. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Solar;
@class Lunar;
@interface CalendarDisplyManager : NSObject
//公历转农历
+ (Lunar *)obtainLunarFromSolar:(Solar *)solar;
//农历转公历
+ (Solar *)obtainSolarFromLunar:(Lunar *)solar;
//转换为农历显示形式
+ (NSArray *)resultWithLunar:(Lunar *)lunar resultFormat:(NSString *)year Month:(NSString *)month Day:(NSString *)day;

//+ (NSArray *)resultSolarWithLunar:(Lunar *)lunar resultFormat:(NSString *)year Month:(NSString *)month Day:(NSString *)day;
//星座
+ (NSString *)obtainConstellationFromSolar:(Solar *)solar;
@end
