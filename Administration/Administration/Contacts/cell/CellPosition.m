//
//  CellPosition.m
//  Administration
//
//  Created by zhang on 2017/7/19.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellPosition.h"

@implementation CellPosition

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labelPosition = [[UILabel alloc]init];
        [self.contentView addSubview:self.labelPosition];
        [self.labelPosition mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(14);
        }];
        
        self.imageViewArrow = [[UIImageView alloc]init];
        self.imageViewArrow.image = [UIImage imageNamed:@"jiantou_03"];
        [self.contentView addSubview:self.imageViewArrow];
        [self.imageViewArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(16);
        }];
    }
    return self;
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
