//
//  shopAssModel.m
//  Administration
//
//  Created by 九尾狐 on 2017/12/4.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "shopAssModel.h"

@implementation shopAssModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.AssustantId = value;
        
    }
    
    
}
//kvc取值操作  取值误操作
-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
