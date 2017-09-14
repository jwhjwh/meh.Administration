//
//  CellInfo.m
//  Administration
//
//  Created by zhang on 2017/8/24.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellInfo.h"

@implementation CellInfo

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:@"cell"];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    UILabel *labelTitle = [[UILabel alloc]init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(100);
    }];
    self.labelTitle = labelTitle;
    
    UILabel *labelInfo = [[UILabel alloc]init];
    labelInfo.textColor = GetColor(192, 192, 192, 1);
    [self.contentView addSubview:labelInfo];
    [labelInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelTitle.mas_right).offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(14);
    }];
    self.labelInfo = labelInfo;
    
    UILabel *labelLine = [[UILabel alloc]init];
    labelLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:labelLine];
    [labelLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
    [self.contentView addSubview:labelLine];
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
