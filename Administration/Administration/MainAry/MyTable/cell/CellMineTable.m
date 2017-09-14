//
//  CellMineTable.m
//  Administration
//
//  Created by zhang on 2017/9/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellMineTable.h"

@implementation CellMineTable

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
    UILabel *labelTime = [[UILabel alloc]init];
    labelTime.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(17);
    }];
    self.labelTime = labelTime;
    
    UILabel *labelDescribe = [[UILabel alloc]init];
    labelDescribe.font = [UIFont systemFontOfSize:15];
    labelDescribe.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:labelDescribe];
    [labelDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(labelTime.mas_bottom).offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.height.mas_equalTo(15);
    }];
    self.labelDescribe = labelDescribe;
    
    UILabel *labelUptime = [[UILabel alloc]init];
    labelUptime.font = [UIFont systemFontOfSize:13];
    labelUptime.textColor = GetColor(192, 192, 192, 1);
    [self.contentView addSubview:labelUptime];
    [labelUptime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.height.mas_equalTo(13);
    }];
    self.labelUpTime = labelUptime;

}

-(void)setDict:(NSDictionary *)dict
{
    if (dict[@"dateLine"]) {
        NSString *date = [dict[@"dateLine"] substringToIndex:10];
        self.labelTime.text = [NSString stringWithFormat:@"日期：%@",date];
    }
    if (dict[@"dates"]) {
        self.labelUpTime.text = [dict[@"dates"] substringToIndex:16];
    }
    self.labelDescribe.text = [NSString stringWithFormat:@"概要描述%@",dict[@"describe"]];
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
