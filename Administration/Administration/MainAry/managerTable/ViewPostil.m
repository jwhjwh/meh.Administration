//
//  ViewPostil.m
//  Administration
//
//  Created by zhang on 2017/8/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewPostil.h"

@implementation ViewPostil

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    UIView *viewTop = [[UIView alloc]init];
    [self addSubview:viewTop];
    [viewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
        //make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.mas_right);
    }];
    self.viewTop = viewTop;
    
    UIButton *buttonAdd = [[UIButton alloc]init];
    [buttonAdd setTitle:@"添加批注 +" forState:UIControlStateNormal];
    [buttonAdd setTitleColor:GetColor(134,110 ,97 ,1) forState:UIControlStateNormal];
    [viewTop addSubview:buttonAdd];
    [buttonAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewTop.mas_left).offset(8);
        make.top.mas_equalTo(viewTop.mas_top);
        make.bottom.mas_equalTo(viewTop.mas_bottom);
        make.width.mas_equalTo(100);
    }];
    self.buttonAdd = buttonAdd;
    
    UIView *viewBottom = [[UIView alloc]init];
    viewBottom.backgroundColor = [UIColor clearColor];
    [self addSubview:viewBottom];
    [viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(viewTop.mas_bottom).offset(5);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    self.viewBottom = viewBottom;
    
    UILabel *labelTime = [[UILabel alloc]init];
    labelTime.textColor = [UIColor lightGrayColor];
    labelTime.font = [UIFont systemFontOfSize:10];
    [viewBottom addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewBottom.mas_left).offset(8);
        make.top.mas_equalTo(viewBottom.mas_top);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(10);
    }];
    self.labelTime = labelTime;
    
    UIButton *buttonComp = [[UIButton alloc]init];
    [buttonComp setTitle:@"完成" forState:UIControlStateNormal];
    [buttonComp setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [viewBottom addSubview:buttonComp];
    [buttonComp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(viewBottom.mas_left).offset(-8);
        make.top.mas_equalTo(viewBottom.mas_top);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(10);
    }];
    self.buttonComp = buttonComp;
    
    UIView *viewText = [[UIView alloc]init];
    viewText.backgroundColor = [UIColor lightGrayColor];
    [viewBottom addSubview:viewText];
    [viewText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewBottom.mas_left).offset(8);
        make.top.mas_equalTo(buttonComp.mas_bottom).offset(3);
        make.bottom.mas_equalTo(viewBottom.mas_bottom);
        make.right.mas_equalTo(viewBottom.mas_right);
    }];
    
    UIPlaceHolderTextView *textView1 = [[UIPlaceHolderTextView alloc]init];
    textView1.textColor = [UIColor lightGrayColor];
    textView1.font = [UIFont systemFontOfSize:14];
    textView1.backgroundColor = GetColor(235, 227, 203, 1);
    NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc]initWithString:@"批注对象：例：@“本月计划超额完成”"];
    [attString1 addAttribute:NSForegroundColorAttributeName value:GetColor(145, 124, 102, 1) range:NSMakeRange(0, 3)];
    textView1.placeholder = (NSString *)attString1;
    [viewText addSubview:textView1];
    [textView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewText.mas_left);
        make.right.mas_equalTo(viewText.mas_right);
        make.top.mas_equalTo(viewText.mas_top);
        make.height.mas_equalTo(viewText.height/2);
    }];
    self.textView1 = textView1;
    
    UIPlaceHolderTextView *textView2 = [[UIPlaceHolderTextView alloc]init];
    textView2.textColor = [UIColor lightGrayColor];
    textView2.font = [UIFont systemFontOfSize:14];
    textView2.backgroundColor = GetColor(235, 227, 203, 1);
    NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc]initWithString:@"批注对象：例：@“本月计划超额完成”"];
    [attString2 addAttribute:NSForegroundColorAttributeName value:GetColor(145, 124, 102, 1) range:NSMakeRange(0, 3)];
    textView2.placeholder = (NSString *)attString1;
    [viewText addSubview:textView2];
    [textView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewText.mas_left);
        make.right.mas_equalTo(viewText.mas_right);
        make.top.mas_equalTo(textView1.mas_bottom).offset(1);
        make.bottom.mas_equalTo(viewText.mas_bottom);
    }];
    self.textView2 = textView2;
}
-(void)addPostil
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
