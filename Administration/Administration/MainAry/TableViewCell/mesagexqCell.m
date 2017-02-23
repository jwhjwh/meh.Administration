//
//  mesagexqCell.m
//  Administration
//
//  Created by 费腾 on 17/2/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "mesagexqCell.h"

@implementation mesagexqCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews{
    _biaoLabel=[[UILabel alloc]init];
    [self addSubview:_biaoLabel];
    _button=[UIButton buttonWithType:UIButtonTypeCustom];
    [_button setImage:[UIImage imageNamed:@"tjpco02"]forState:UIControlStateNormal];
    [self addSubview:_button];
    _TextField = [[UITextView alloc]init];
    _TextField.layer.borderColor = UIColor.grayColor.CGColor;
    _TextField.layer.borderWidth = 1;
    _TextField.layer.cornerRadius = 6;
    _TextField.layer.masksToBounds = YES;
    [self addSubview:_TextField];
    [_biaoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.width.offset(Scree_width-70);
        make.height.offset(35);
    }];
    [_button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_biaoLabel.top).offset(5);
        make.left.mas_equalTo(_biaoLabel.mas_right).offset(5);
        make.width.offset(35);
        make.height.offset(20);
    }];
    [_TextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_biaoLabel.mas_bottom);
        make.left.mas_equalTo(_biaoLabel.mas_left);
        make.width.offset(Scree_width-20);
        make.height.offset(25);
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
