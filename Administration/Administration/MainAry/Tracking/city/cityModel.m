//
//  cityModel.m
//  城市选择
//
//  Created by Summer on 16/4/27.
//  Copyright © 2016年 iSmartAlarm. All rights reserved.
//

#import "cityModel.h"

@implementation cityModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.did = value;
    }
    
    
}
//kvc取值操作  取值误操作
-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
