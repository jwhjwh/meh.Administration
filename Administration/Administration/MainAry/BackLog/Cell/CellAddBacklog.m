//
//  CellAddBacklog.m
//  Administration
//
//  Created by zhang on 2017/10/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellAddBacklog.h"

@implementation CellAddBacklog


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
    UILabel *labelDate = [[UILabel alloc]init];
    labelDate.text = @"日期";
    labelDate.textColor = GetColor(102, 103, 104, 1);
    [self.contentView addSubview:labelDate];
    [labelDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(100);
    }];
    self.labelDate = labelDate;
    
    UIButton *startDate = [[UIButton alloc]init];
  //  startDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    startDate.tag = 100;
    [startDate setBackgroundColor:[UIColor whiteColor]];
    [startDate setTitle:@"选择日期" forState:UIControlStateNormal];
    [startDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [self.contentView addSubview:startDate];
    [startDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelDate.mas_right);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(21);
    }];
    self.startDate = startDate;
    
    UILabel *labelzhi = [[UILabel alloc]init];
    labelzhi.text = @"至";
    [self.contentView addSubview:labelzhi];
    [labelzhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(startDate.mas_right);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(21);
    }];
    self.labelzhi =labelzhi;
    
    UIButton *endDate = [[UIButton alloc]init];
  //  endDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    endDate.tag = 200;
    [endDate setBackgroundColor:[UIColor whiteColor]];
    [endDate setTitle:@"选择日期" forState:UIControlStateNormal];
    [endDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [self.contentView addSubview:endDate];
    [endDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelzhi.mas_right);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(21);
    }];
    self.endDate = endDate;
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
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
