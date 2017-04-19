//
//  someModel.m
//  Administration
//
//  Created by 九尾狐 on 2017/4/19.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "someModel.h"

@implementation someModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    if([key isEqualToString:@"newName"]){
        self.Name = value;
        
    }
    
}
-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
