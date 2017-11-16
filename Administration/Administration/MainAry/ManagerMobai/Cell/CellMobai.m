//
//  CellMobai.m
//  Administration
//
//  Created by zhang on 2017/11/10.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellMobai.h"

@implementation CellMobai

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
    UILabel *labelShop = [[UILabel alloc]init];
    [self.contentView addSubview:labelShop];
    [labelShop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(14);
    }];
    self.labelShop = labelShop;
    
    UILabel *labelArea = [[UILabel alloc]init];
    labelArea.font = [UIFont systemFontOfSize:12];
    labelArea.textColor = GetColor(187, 188, 189, 1);
    [self.contentView addSubview:labelArea];
    [labelArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(labelShop.mas_bottom).offset(5);
        make.height.mas_equalTo(12);
    }];
    self.labelArea = labelArea;
    
    UILabel *labelAdress = [[UILabel alloc]init];
    labelAdress.font = [UIFont systemFontOfSize:12];
    labelAdress.textColor = GetColor(187, 188, 189, 1);
    [self.contentView addSubview:labelAdress];
    [labelAdress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(labelArea.mas_bottom).offset(5);
        make.height.mas_equalTo(12);
    }];
    self.labelAdress = labelAdress;
    
    UILabel *labelDate = [[UILabel alloc]init];
    labelDate.font = [UIFont systemFontOfSize:12];
    labelDate.textColor = GetColor(187, 188, 189, 1);
    [self.contentView addSubview:labelDate];
    [labelDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(labelAdress.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    self.labelDate = labelDate;
    
    UILabel *labelTime = [[UILabel alloc]init];
    labelTime.font = [UIFont systemFontOfSize:12];
    labelTime.textColor = GetColor(187, 188, 189, 1);
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(12);
    }];
    self.labelTime = labelTime;
}

-(void)setDict:(NSDictionary *)dict
{
    self.labelShop.text = [NSString stringWithFormat:@"店名：%@",dict[@"storeName"]];
    self.labelDate.text = [NSString stringWithFormat:@"日期：%@",[dict[@"dates"]substringToIndex:10]];
    self.labelArea.text = [NSString stringWithFormat:@"地区：%@%@%@",dict[@"province"],dict[@"city"],dict[@"county"]];
    self.labelAdress.text = [NSString stringWithFormat:@"地址：%@",dict[@"address"]];
    
    self.labelTime.text = [dict[@"wtime"]substringWithRange:NSMakeRange(5, 11)];
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
