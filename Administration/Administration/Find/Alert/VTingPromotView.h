//
//  VTingPromotView.h
//  VTingPopView
//
//  Created by WillyZhao on 16/8/31.
//  Copyright © 2016年 WillyZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BclokSuccess)(NSString *pwd);  //点击确认后密码返回

@interface VTingPromotView : UIView
@property (nonatomic, strong) BclokSuccess blockname;
@property (nonatomic, strong) NSString *string;
//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame testStr:(NSString *)testStr;

//弹出密码提示框
-(void)showPopViewAnimate:(BOOL)animate;

//消失密码提示框
-(void)dismissPopViewAnimate:(BOOL)animate;

@end
