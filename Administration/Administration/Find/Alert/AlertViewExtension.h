//
//  AlertViewExtension.h
//  AlertView
//
//  Created by alive on 2017/2/4.
//  Copyright © 2017年 刘学丽. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlertViewExtension;
@protocol alertviewExtensionDelegate <NSObject>

-(void)clickBtnSelector:(UIButton *)btn;

@end
@interface AlertViewExtension : UIView


//取消按钮
@property(nonatomic,strong)UIButton *cancelBtn;
//确定按钮
@property(nonatomic,strong)UIButton *sureBtn;
//提示view
@property(nonatomic,strong)UILabel *tipeLabel;

//提示view
@property(nonatomic,strong)UIView *tipebackView;
@property(nonatomic,assign)id<alertviewExtensionDelegate>delegate;


//设置提示view的宽高
-(void)setbackviewframeWidth:(CGFloat)width Andheight:(CGFloat)height;

//设置提示语
-(void)settipeTitleStr:(NSString *)tipeStr Andfont:(CGFloat)font;
@end
