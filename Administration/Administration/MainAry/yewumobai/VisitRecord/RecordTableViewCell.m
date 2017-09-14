//
//  RecordTableViewCell.m
//  Administration
//
//  Created by 九尾狐 on 2017/9/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "RecordTableViewCell.h"

@implementation RecordTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
- (void) addSubviews {
    _shijianLabel = [[UILabel alloc]init];
    _shijianLabel.font = [UIFont systemFontOfSize:11];
    _shijianLabel.textColor = GetColor(145, 146, 147, 1);
    [self addSubview:_shijianLabel];
    
    
    _dianmingLabel = [[UILabel alloc]init];
    _dianmingLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_dianmingLabel];
    
    _RectordLabel = [[UILabel alloc]init];
    _RectordLabel.font = [UIFont systemFontOfSize:14];
    _RectordLabel.textColor = GetColor(145, 146, 147, 1);
    _RectordLabel.numberOfLines = 0;
    [self addSubview:_RectordLabel];
    
    [_shijianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-30);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    [_dianmingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.height.mas_offset(30);
        make.right.mas_equalTo(_shijianLabel.mas_left).offset(-5);
    }];
    [_RectordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_dianmingLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        make.right.mas_equalTo(self.mas_right).offset(-30);
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

@end
