//
//  ZXYAlertView.h
//  AlertViewDemo
//
//  Created by Apple on 16/9/8.
//  Copyright © 2016年 深圳中业兴融互联网金融服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXYAlertView;

@protocol ZXYAlertViewDelegate <NSObject>
@optional

- (void)alertView:(ZXYAlertView *)alertView clickedCustomButtonAtIndex:(NSInteger)buttonIndex;


@end


@interface ZXYAlertView : UIView
/** 标题(默认“提示”)*/
@property (nonatomic, copy) NSString    *title;
/** 内容 */
@property (nonatomic, copy) NSAttributedString    *content;
/** 按钮名字数组 */
@property (nonatomic, strong)NSArray    *buttonArray;

@property (weak, nonatomic) id <ZXYAlertViewDelegate> delegate;

+ (instancetype)alertViewDefault;
- (void)show;

@end
