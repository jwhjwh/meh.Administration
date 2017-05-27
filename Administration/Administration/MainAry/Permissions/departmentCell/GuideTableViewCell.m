//
//  GuideTableViewCell.m
//  Administration
//
//  Created by zhang on 2017/4/27.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "GuideTableViewCell.h"

@implementation GuideTableViewCell
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

    
    [self addSubview:_titleLabel];
    
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.width.offset(30);
      
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_image.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.offset(30);
    }];
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(branModel *)model{
   _titleLabel.text =model.levelName;
    
}
@end
