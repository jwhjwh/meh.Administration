//
//  ZxdObject.m
//  Administration
//
//  Created by zhang on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ZxdObject.h"

@implementation ZxdObject
+(void)rootController{
    NSArray *selectedArr = @[@"zihome",@"zilianxiren",@"zishezhi"]  ;
    NSArray *unSeleceArr = @[@"huihome",@"huilianxiren",@"huishezhi"] ;
    NSArray *titleArr = @[@"首页",@"联系人",@"设置"] ;
    XCQ_tabbarViewController *xcq_tab = [[XCQ_tabbarViewController alloc]initWithNomarImageArr:unSeleceArr
                                                                             andSelectImageArr:selectedArr
                                                                                   andtitleArr:titleArr];
    xcq_tab.modalTransitionStyle =UIModalTransitionStyleCrossDissolve ;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = xcq_tab;
    
}
@end
