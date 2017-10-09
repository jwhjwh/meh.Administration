//
//  CellSummaryList.m
//  Administration
//
//  Created by zhang on 2017/9/30.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellSummaryList.h"

@implementation CellSummaryList

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
    UILabel *labelMode = [[UILabel alloc]init];
    [self.contentView addSubview:labelMode];
    [labelMode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(17);
    }];
    self.labelMode = labelMode;
    
    UILabel *labelTime = [[UILabel alloc]init];
    labelTime.font = [UIFont systemFontOfSize:12];
    labelTime.textColor = GetColor(192, 192, 192, 192);
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(labelMode.mas_bottom).offset(8);
     //   make.height.mas_equalTo(12);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
    }];
    self.labelTime = labelTime;
    
    UILabel *labelUpTime = [[UILabel alloc]init];
    [self.contentView addSubview:labelUpTime];
    [labelUpTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(17);
    }];
    self.labelUpTime = labelUpTime;
    
    UILabel *labelState = [[UILabel alloc]init];
    labelState.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:labelState];
    [labelState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.top.mas_equalTo(labelUpTime.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    self.labelState = labelState;
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
