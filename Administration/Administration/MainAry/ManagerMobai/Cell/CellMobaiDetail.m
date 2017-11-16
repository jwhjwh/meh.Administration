//
//  CellMobaiDetail.m
//  Administration
//
//  Created by zhang on 2017/11/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellMobaiDetail.h"

@implementation CellMobaiDetail

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
    UILabel *labelTitle = [[UILabel alloc]init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(21);
        
    }];
    self.labelTitle = labelTitle;
    
    UILabel *labelContent = [[UILabel alloc]init];
    labelContent.textColor = GetColor(192, 192, 192, 1);
    [self.contentView addSubview:labelContent];
    [labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelTitle.mas_right).offset(20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(21);
    }];
    self.labelContent = labelContent;
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
