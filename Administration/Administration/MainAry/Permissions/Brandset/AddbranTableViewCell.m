//
//  AddbranTableViewCell.m
//  Administration
//
//  Created by zhang on 2017/4/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AddbranTableViewCell.h"

@implementation AddbranTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews{
    
    _titleLabel=[[UILabel alloc]init];
    _titleLabel.font=[UIFont systemFontOfSize:18];
    _titleLabel.textColor=[UIColor lightGrayColor];
    [self addSubview:_titleLabel];
    _BarnLabel=[[UITextField alloc]init];
    [self addSubview:_BarnLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.offset(20);
    }];
    [_BarnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(10);
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

@end
