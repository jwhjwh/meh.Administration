//
//  HoderReusableView.m
//  Administration
//
//  Created by zhang on 2017/5/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "HoderReusableView.h"

@implementation HoderReusableView
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}
- (void)addSubviews {
    _label=[[UILabel alloc]init];
    _label.text =@"名称";
    [self addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.offset(20);
    }];
}
@end
