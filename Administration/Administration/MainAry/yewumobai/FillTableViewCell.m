//
//  FillTableViewCell.m
//  Administration
//
//  Created by zhang on 2017/3/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "FillTableViewCell.h"

@implementation FillTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
- (void) addSubviews {
    _mingLabel=[[UILabel alloc]init];
    _mingLabel.font=[UIFont systemFontOfSize:16];
    [self addSubview:_mingLabel];
    _xingLabel=[[UILabel alloc]init];
    _xingLabel.numberOfLines=0;
    _xingLabel.font=[UIFont systemFontOfSize:14];
    [self addSubview:_xingLabel];
    [_mingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.offset(220);
        make.height.offset(30);
    }];
    [_xingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_mingLabel.mas_right);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.centerY.mas_equalTo(_mingLabel.mas_centerY);
        make.height.offset(20);
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
