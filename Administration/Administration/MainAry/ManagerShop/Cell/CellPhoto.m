//
//  CellPhoto.m
//  Administration
//
//  Created by zhang on 2018/3/1.
//  Copyright © 2018年 九尾狐. All rights reserved.
//

#import "CellPhoto.h"

@implementation CellPhoto

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    UILabel *label = [[UILabel alloc]init];
    label.text = @"照片";
    label.textColor = GetColor(117, 118, 119, 1);
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(21);
    }];
    
    self.imageViewPhoto = [[UIImageView alloc]init];
    self.imageViewPhoto.image = [UIImage imageNamed:@"tjtx"];
    self.imageViewPhoto.userInteractionEnabled = YES;
    [self.contentView addSubview:self.imageViewPhoto];
    [self.imageViewPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).offset(150);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
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
