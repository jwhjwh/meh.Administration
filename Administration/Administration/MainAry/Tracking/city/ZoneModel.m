//
//  ZoneModel.m
//  城市选择
//
//  Created by Summer on 16/4/27.
//  Copyright © 2016年 iSmartAlarm. All rights reserved.
//

#import "ZoneModel.h"

@implementation ZoneModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
//kvc取值操作  取值误操作
-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
