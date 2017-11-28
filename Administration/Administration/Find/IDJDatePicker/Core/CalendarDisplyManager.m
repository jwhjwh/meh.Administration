//
//  CalendarDisplyManager.m
//  阳历转阴历
//
//  Created by 孙云飞 on 2016/11/3.
//  Copyright © 2016年 孙云飞. All rights reserved.
//

#import "CalendarDisplyManager.h"
#import "Lunar.h"
#import "Solar.h"
#import "LunarSolarTransform.h"
@implementation CalendarDisplyManager
//公历转农历
+ (Lunar *)obtainLunarFromSolar:(Solar *)solar{

    return [LunarSolarTransform solarToLunar:solar];
}
//农历转公历
+ (Solar *)obtainSolarFromLunar:(Lunar *)solar{

    return [LunarSolarTransform lunarToSolar:solar];
}

//转换为农历显示形式
+ (NSArray *)resultWithLunar:(Lunar *)lunar resultFormat:(NSString *)year Month:(NSString *)month Day:(NSString *)day{

    NSString *formatFormat = [LunarSolarTransform formatWithLunar:lunar];
    return  [formatFormat componentsSeparatedByString:@"-"];
   // lunarFormatBlock(lunarArray[0],lunarArray[1],lunarArray[2]);
}

//转换为阳历显示形式
//+ (NSArray *)resultSolarWithLunar:(Lunar *)lunar resultFormat:(NSString *)year Month:(NSString *)month Day:(NSString *)day
//{
//   
//}


//星座
+ (NSString *)obtainConstellationFromSolar:(Solar *)solar{

    return [LunarSolarTransform constellationFromSolar:solar];
}
@end
