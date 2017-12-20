//
//  ProvinceModel.m
//  城市选择
//
//  Created by Summer on 16/4/27.
//  Copyright © 2016年 iSmartAlarm. All rights reserved.
//

#import "ProvinceModel.h"



@implementation ProvinceModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.mid = value;
    }
    
    
}
//kvc取值操作  取值误操作
-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}


@end
