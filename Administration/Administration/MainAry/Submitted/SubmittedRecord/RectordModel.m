//
//  RectordModel.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/10.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "RectordModel.h"

@implementation RectordModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    if([key isEqualToString:@"id"]){
        self.Pid = value;
    }
    
}
//kvc取值操作  取值误操作
-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
