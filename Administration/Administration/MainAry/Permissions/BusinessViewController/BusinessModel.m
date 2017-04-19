//
//  BusinessModel.m
//  Administration
//
//  Created by 九尾狐 on 2017/4/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "BusinessModel.h"

@implementation BusinessModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    if([key isEqualToString:@"id"]){
        self.ID = value;
        
    }
    
}
//kvc取值操作  取值误操作
-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
