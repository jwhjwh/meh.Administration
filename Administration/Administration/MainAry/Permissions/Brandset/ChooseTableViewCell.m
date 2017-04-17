//
//  ChooseTableViewCell.m
//  Administration
//
//  Created by zhang on 2017/4/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ChooseTableViewCell.h"

@implementation ChooseTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
- (void) addSubviews {
    _image =[[UIImageView alloc]init];
    // 设置圆角半径
    [self addSubview:_image];
    _titleLabel=[[UILabel alloc]init];
    _titleLabel.font=[UIFont systemFontOfSize:20];
    
    [self addSubview:_titleLabel];
    
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(40);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.width.offset(54);
        make.height.offset(54);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_image.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.offset(20);
    }];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (self.editing) {
        if (selected) {
            // 编辑状态去掉渲染
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.backgroundView.backgroundColor = [UIColor whiteColor];
            // 左边选择按钮去掉渲染背景
            UIView *view = [[UIView alloc] initWithFrame:self.multipleSelectionBackgroundView.bounds];
            view.backgroundColor = [UIColor whiteColor];
            self.selectedBackgroundView = view;
            
        }
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
