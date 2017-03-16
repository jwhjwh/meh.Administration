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
    NSArray *titleArr = @[@"首页",@"通讯录",@"设置"] ;
    XCQ_tabbarViewController *xcq_tab = [[XCQ_tabbarViewController alloc]initWithNomarImageArr:unSeleceArr
                                                                             andSelectImageArr:selectedArr
                                                                                   andtitleArr:titleArr];
    xcq_tab.modalTransitionStyle =UIModalTransitionStyleCrossDissolve ;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = xcq_tab;
    
}


//将文字添加到图片上

+ (UIImage*)text:(NSString*)text addToView:(UIImage*)image{
    
    //设置字体样式
    
    UIFont*font = [UIFont fontWithName:@"Arial-BoldItalicMT"size:32];
    
    NSDictionary*dict =@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    CGSize textSize = [text sizeWithAttributes:dict];
    
    //绘制上下文
    
    UIGraphicsBeginImageContext(image.size);
    
    [image drawInRect:CGRectMake(0,0, image.size.width, image.size.height)];
    
    int border =10;
    
    CGRect re = {CGPointMake(image.size.width- textSize.width- border, image.size.height- textSize.height- border), textSize};
    
    //此方法必须写在上下文才生效
    [text drawInRect:re withAttributes:dict];
    
    UIImage*newImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
@end
