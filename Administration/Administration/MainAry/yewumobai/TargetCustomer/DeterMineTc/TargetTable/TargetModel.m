//
//  TargetModel.m
//  Administration
//
//  Created by 九尾狐 on 2017/10/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TargetModel.h"

@implementation TargetModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    if([key isEqualToString:@"id"]){
        self.Id = value;
        
    }
    
}
//kvc取值操作  取值误操作
-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
