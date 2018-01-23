//
//  inftionTableViewCell.m
//  Administration
//
//  Created by zhang on 2017/2/25.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "inftionTableViewCell.h"

@implementation inftionTableViewCell
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

        make.top.mas_equalTo(self.mas_top).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.width.mas_equalTo(140);
    }];
    [_xingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_mingLabel.mas_right).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        //make.centerY.mas_equalTo(_mingLabel.mas_centerY);
        make.top.mas_equalTo(self.mas_top).offset(8);
       // make.height.offset(20);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
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
