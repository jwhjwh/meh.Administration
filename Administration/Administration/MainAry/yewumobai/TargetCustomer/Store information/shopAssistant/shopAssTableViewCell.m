//
//  shopAssTableViewCell.m
//  Administration
//
//  Created by 九尾狐 on 2017/12/4.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "shopAssTableViewCell.h"

@implementation shopAssTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews{
    
    _nameLabel=[[UILabel alloc]init];
    _nameLabel.font=[UIFont systemFontOfSize:15];
    
    [self addSubview:_nameLabel];

    _dayLabel=[[UILabel alloc]init];
    _dayLabel.font=[UIFont systemFontOfSize:15];
    
    [self addSubview:_dayLabel];
    
    _phoneleLabel=[[UILabel alloc]init];
    _phoneleLabel.font=[UIFont systemFontOfSize:15];
    
    [self addSubview:_phoneleLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.width.mas_offset(100);
        make.height.offset(20);
    }];
    
    
    [_phoneleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(100);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.offset(20);
    }];
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_right).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.right.mas_equalTo(_phoneleLabel.mas_left).offset(-15);
        make.height.offset(20);
    }];
}
-(void)setModle:(shopAssModel *)modle{
    _nameLabel.text=modle.name;
    NSInteger k = [modle.flag integerValue];
    NSString *stringInt = [NSString stringWithFormat:@"%ld",k];
    if ([stringInt isEqualToString:@"1"]) {
        _dayLabel.text = modle.lunarBirthday;
    }else{
        _dayLabel.text = modle.solarBirthday;
    }
    _phoneleLabel.text = modle.phone;
    
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
