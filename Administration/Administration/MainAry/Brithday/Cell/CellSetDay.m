//
//  CellSetDay.m
//  Administration
//
//  Created by zhang on 2017/11/3.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellSetDay.h"

@implementation CellSetDay

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
    UIImageView *imageViewSelect = [[UIImageView alloc]init];
    imageViewSelect.image = [UIImage imageNamed:@"weixuanzhong"];
    [self.contentView addSubview:imageViewSelect];
    [imageViewSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(8);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    self.imageViewSelect = imageViewSelect;
    
    UILabel *labelTitle = [[UILabel alloc]init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewSelect.mas_right).offset(5);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(21);
    }];
    self.labelTitle = labelTitle;
}
@end
