//
//  ShareModel.m
//  Administration
//
//  Created by zhang on 2017/8/9.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ShareModel.h"
@implementation ShareModel
+(ShareModel *)shareModel
{
    static ShareModel *sharMode = nil;
    static dispatch_once_t tooken;
    dispatch_once(&tooken, ^{
        
        sharMode = [[self alloc] init];
        
        sharMode.arrayData = [NSMutableArray array];
        sharMode.arrayArea = [NSMutableArray array];
        
        sharMode.jiankeng = @"";
        sharMode.teshu = @"";
        sharMode.zaizuo = @"";
        sharMode.xiaofei = @"";
        
        sharMode.techang = @"";
        sharMode.pingpan = @"";
        
        sharMode.loginViewController = [[ViewController alloc]init];
    });
    
    
    return sharMode;
}

@end
