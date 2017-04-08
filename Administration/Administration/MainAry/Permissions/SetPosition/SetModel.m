
//
//  SetModel.m
//  Administration
//
//  Created by 九尾狐 on 2017/4/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "SetModel.h"

@implementation SetModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    if([key isEqualToString:@"newName"]){
        self.NewName = value;
        
    }
    
}
//kvc取值操作  取值误操作
-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
