//
//  UIView+WLFrame.h
//  YIJIKUAISONG
//
//  Created by 费腾 on 16/7/5.
//  Copyright © 2016年 费腾. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface UIView (WLFrame)

//  高度
@property (nonatomic,assign) CGFloat height;
//  宽度
@property (nonatomic,assign) CGFloat width;

//  Y
@property (nonatomic,assign) CGFloat top;
//  X
@property (nonatomic,assign) CGFloat left;

//  Y + Height
@property (nonatomic,assign) CGFloat bottom;
//  X + width
@property (nonatomic,assign) CGFloat right;
- (void)addCornerRadiusWithcorners:(UIRectCorner)corners AndRadii:(CGSize)radii;
@end
