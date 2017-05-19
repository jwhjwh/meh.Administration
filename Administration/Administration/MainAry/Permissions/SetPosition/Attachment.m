//
//  Attachment.m
//  Administration
//
//  Created by 九尾狐 on 2017/4/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "Attachment.h"

@implementation Attachment


- (instancetype)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        //布局子视图
        //self.backgroundColor = [UIColor whiteColor];
        [self subViewUI];
    }
    return self;
}
-(void)subViewUI{
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.height.mas_equalTo(self.mas_height).offset(-1);
        make.width.mas_equalTo(1);
    }];
    
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view1.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
}
@end
