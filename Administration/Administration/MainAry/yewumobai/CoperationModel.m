//
//  CoperationModel.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CoperationModel.h"

@implementation CoperationModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.shId = value;
        
    }
    
    
}
//kvc取值操作  取值误操作
-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
