//
//  BranTableViewCell.m
//  Administration
//
//  Created by zhang on 2017/4/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "BranTableViewCell.h"

@implementation BranTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
- (void) addSubviews {
    _imageVie =[[UIImageView alloc]init];
    // 设置圆角半径
    [self addSubview:_imageVie];
    _titleLabel=[[UILabel alloc]init];
    _titleLabel.font=[UIFont systemFontOfSize:20];
    
    [self addSubview:_titleLabel];
    
    [_imageVie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.width.offset(54);
        make.height.offset(54);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imageVie.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.offset(20);
    }];

    
}
-(void)setModel:(branModel *)model{
       
       [_imageVie sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model.brandLogo]]placeholderImage:[UIImage imageNamed:@"banben100"]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
