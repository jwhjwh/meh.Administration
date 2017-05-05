//
//  VTingPromotView.m
//  VTingPopView
//
//  Created by WillyZhao on 16/8/31.
//  Copyright © 2016年 WillyZhao. All rights reserved.
//

#import "VTingPromotView.h"



@interface VTingPromotView () <UITextFieldDelegate> {
    UIButton *sureBtn;           //确认按钮
    UIButton *closeBtn;          //取消按钮
    UITextField *textfield;      //名称输入框
    
    UIView *backgroundView;      //背景view
    UIView *centerView;          //内容view
    NSString *name;
    UITapGestureRecognizer *tap; //点击事件
}



@end



@implementation VTingPromotView

-(instancetype)initWithFrame:(CGRect)frame testStr:(NSString *)testStr{
    if (self = [super initWithFrame:frame]) {
        _string=testStr;
        [self loadSubViews];        //初始化视图
        //添加键盘显示与消失通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillDismiss:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
    
}


-(void)keyBoardWillDismiss:(NSNotification *)na {
    [UIView animateWithDuration:.2f animations:^{

    }];
}


-(void)keyBoardWillAppear:(NSNotification *)na {

    [UIView animateWithDuration:.2f animations:^{
   
    }];
}

-(void)loadSubViews {

        //有输入框初始化
        //背景
        backgroundView = [[UIView alloc] initWithFrame:self.frame];
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:backgroundView];
        //内容view
        centerView = [[UIView alloc]initWithFrame:CGRectMake(30, self.frame.size.height/2-75, self.frame.size.width-60, 150)];
        centerView.layer.masksToBounds = YES;
        centerView.layer.cornerRadius = 5.0f;
        centerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:centerView];
    
    //新建分组
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,15, centerView.frame.size.width, 30)];
    label.text = _string;
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18 weight:.5f];
    [centerView addSubview:label];

    //上分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,label.bottom+9, centerView.frame.size.width,0.7)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [centerView addSubview:lineView];
 
    
    //添加新建分组容器
    textfield =[[UITextField alloc]initWithFrame:CGRectMake(0, lineView.bottom+10, centerView.frame.size.width, 30)];
    textfield.font =[UIFont systemFontOfSize:15];
    textfield.textAlignment = NSTextAlignmentCenter;
    textfield.placeholder =@"请输入美导类别名称";
    [centerView addSubview:textfield];
    
    

    
    //添加下分割线
    UIView *downLineView = [[UIView alloc]initWithFrame:CGRectMake(0,textfield.bottom+9, centerView.frame.size.width,0.7)];
    downLineView.backgroundColor = [UIColor lightGrayColor];
    [centerView addSubview:downLineView];

    //确认按钮
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame =CGRectMake(centerView.frame.size.width/2-30, downLineView.bottom+10, 60, 30);
    [centerView addSubview:sureBtn];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:GetColor(7, 138, 249, 1) forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];

  
}

-(void)showPopViewAnimate:(BOOL)animate{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (animate == YES) {
        [window addSubview:self];
        //动画效果
        centerView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        centerView.alpha = 0;
        [UIView animateWithDuration:.35 animations:^{
            centerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            centerView.alpha = 1;
        }];
    }else{
        [window addSubview:self];
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:centerView]) {
        [self dismissPopViewAnimate:YES];
    }
}

-(void)tapAction:(UITapGestureRecognizer *)tap {
    [self dismissPopViewAnimate:YES];
}

-(void)dismissPopViewAnimate:(BOOL)animate {
    [self endEditing:YES];
    if (animate) {
        [UIView animateWithDuration:.35 animations:^{
            centerView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            centerView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
        }];
    }else{
        centerView.alpha = 0;
        [centerView removeFromSuperview];
    }
}


-(void)sureBtnAction:(UIButton *)btn {
    [self dismissPopViewAnimate:YES];
        if (textfield.text.length != 0) {
            name=textfield.text;
            self.blockname(name);
        }else{
            self.blockname(name);
        }
    
}

#pragma mark UITextField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"开始输入");

}



@end
