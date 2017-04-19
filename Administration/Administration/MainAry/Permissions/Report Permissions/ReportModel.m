//
//  ReportModel.m
//  Administration
//
//  Created by 九尾狐 on 2017/4/19.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ReportModel.h"

@implementation ReportModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    if([key isEqualToString:@"newName"]){
        self.Name = value;
        
    }
    
}
//kvc取值操作  取值误操作
-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
