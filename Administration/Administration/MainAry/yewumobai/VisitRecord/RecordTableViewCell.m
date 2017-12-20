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
    
    
    _UserIdLabel = [[UILabel alloc]init];
    _UserIdLabel.font = [UIFont systemFontOfSize:11];
    _UserIdLabel.textColor = GetColor(230, 165, 108, 1);
    [self addSubview:_UserIdLabel];
    
    _UserIdImage = [[UIImageView alloc]init];
    [self addSubview:_UserIdImage];
    
    
    _DepartmentIdLabel = [[UILabel alloc]init];
    _DepartmentIdLabel.font = [UIFont systemFontOfSize:11];
    _DepartmentIdLabel.textColor = GetColor(113, 180, 114, 1);
    [self addSubview:_DepartmentIdLabel];
    
    _DepartmentIdImage = [[UIImageView alloc]init];
    [self addSubview:_DepartmentIdImage];
    
    _StateLabel = [[UILabel alloc]init];
    _StateLabel.font = [UIFont systemFontOfSize:11];
    _StateLabel.textColor = GetColor(158, 91, 185, 1);
    [self addSubview:_StateLabel];
    
    _StateImage = [[UIImageView alloc]init];
    [self addSubview:_StateImage];
    
    
    [_shijianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-30);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    
    
    
    
    
    
    [_UserIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shijianLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-30);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    [_UserIdImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shijianLabel.mas_bottom).offset(8);
        make.right.mas_equalTo(_UserIdLabel.mas_left).offset(-5);
        make.height.mas_offset(12);
        make.width.mas_offset(12);
    }];
    
    [_DepartmentIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_UserIdLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-30);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    
    [_DepartmentIdImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_UserIdLabel.mas_bottom).offset(8);
        make.right.mas_equalTo(_DepartmentIdLabel.mas_left).offset(-5);
        make.height.mas_offset(15);
        make.width.mas_offset(15);
    }];
    
    [_StateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_DepartmentIdLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-30);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(90);
    }];
    
    [_StateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_DepartmentIdLabel.mas_bottom).offset(8);
        make.right.mas_equalTo(_StateLabel.mas_left).offset(-5);
        make.height.mas_offset(13);
        make.width.mas_offset(14);
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
