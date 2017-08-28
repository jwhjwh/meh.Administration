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
    static ShareModel *sharedAccountManagerInstance = nil;
    static dispatch_once_t tooken;
    dispatch_once(&tooken, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    
    return sharedAccountManagerInstance;
}
@end
