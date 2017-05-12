//
//  ZYJHeadLineModel.m
//  ZYJHeadLineView
//
//  Created by 张彦杰 on 16/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZYJHeadLineModel.h"

@implementation ZYJHeadLineModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
//kvc取值操作  取值误操作
-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
