//
//  ELNAlerTool.m
//  AutomicCloseAlertDemo
//
//  Created by Elean on 16/1/11.
//  Copyright (c) 2016年 Elean. All rights reserved.
//

#import "ELNAlerTool.h"

@implementation ELNAlerTool
+ (void)showAlertMassgeWithController:(UIViewController *)ctr andMessage:(NSString *)message andInterval:(NSTimeInterval)time{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [ctr presentViewController:alert animated:YES completion:^{
       
        [self performSelector:@selector(openAlert:) withObject:alert afterDelay:time];
        
    }];
    
}

+ (void)openAlert:(UIAlertController *)alert{

    [alert dismissViewControllerAnimated:YES completion:nil];
}



+(CGFloat)heighOfString:(NSString*)string font:(UIFont*)font width:(CGFloat)width{
  
    NSDictionary *parameterDic=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
     CGRect bounds = [string boundingRectWithSize:CGSizeMake(width, 0)options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:parameterDic context:nil];
    
    return bounds.size.height;
}
+(NSString *)JSONDataString:(NSMutableArray*)theData{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
 
    if ([jsonData length]&&error== nil){
         NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonStr;
    }else{
        return nil;
    }
}
@end
