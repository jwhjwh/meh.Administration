//
//  ButtonView.m
//  Administration
//
//  Created by 九尾狐 on 2017/4/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ButtonView.h"

@implementation ButtonView

- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)height
{
    self = [super initWithFrame:frame];
    if (self) {
        //布局子视图
        self.backgroundColor = [UIColor whiteColor];
        [self subViewUI:height ];
    }
    return self;
}

-(void)subViewUI:(CGFloat)height {
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(1);
    }];
    
    _ZWbutton = [[UIButton alloc]init];
    [_ZWbutton.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [_ZWbutton.layer setCornerRadius:3];
    [_ZWbutton.layer setBorderWidth:1];//设置边界的宽度
    [_ZWbutton.layer setBorderColor:([UIColor lightGrayColor].CGColor)];
    _ZWbutton.titleLabel.font = [UIFont systemFontOfSize: kWidth*25];
    [_ZWbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _ZWbutton.contentEdgeInsets = UIEdgeInsetsMake(3,2,3,2);
    _ZWbutton.titleLabel.numberOfLines = 0;
    [self addSubview:_ZWbutton];
    
    [_ZWbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view1.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(self.mas_height).offset(-height);
    }];
    
    
    
    _ZWimage = [[UIImageView alloc]init];
    [self addSubview:_ZWimage];
    [_ZWimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.width.mas_equalTo(kWidth*20);
        make.height.mas_equalTo(kHeight*20);
    }];

}

@end
