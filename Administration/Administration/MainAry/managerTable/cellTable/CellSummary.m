//
//  CellSummary.m
//  Administration
//
//  Created by zhang on 2017/9/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellSummary.h"

@implementation CellSummary
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
    UILabel *labelFill = [[UILabel alloc]init];
    labelFill.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:labelFill];
    [labelFill mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(12);
    }];
    self.labelFilledTime = labelFill;
    
    UILabel *labelPostion = [[UILabel alloc]init];
    labelPostion.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:labelPostion];
    [labelPostion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(labelFill.mas_bottom).offset(5);
        make.height.mas_equalTo(12);
    }];
    self.labelPostion = labelPostion;
    
    UIImageView *imageViewArrow = [[UIImageView alloc]init];
    imageViewArrow.image = [UIImage imageNamed:@"jiantou_03"];
    [self.contentView addSubview:imageViewArrow];
    [imageViewArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    UILabel *labelUpTime = [[UILabel alloc]init];
    labelUpTime.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:labelUpTime];
    [labelUpTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(imageViewArrow.mas_left).offset(-3);
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.height.mas_equalTo(10);
    }];
    self.labelUpTime = labelUpTime;
    
    UILabel *labelState = [[UILabel alloc]init];
    labelState.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:labelState];
    [labelState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(imageViewArrow.mas_left).offset(-3);
        make.top.mas_equalTo(labelUpTime.mas_bottom).offset(5);
        make.height.mas_equalTo(10);
    }];
    self.labelState = labelState;
}

-(void)setDictInfo:(NSDictionary *)dictInfo
{
    NSString *startDate = [dictInfo[@"startDate"] substringToIndex:11];
    NSString *endDate = [dictInfo[@"endDate"]substringToIndex:11];
    self.labelFilledTime.text = [NSString stringWithFormat:@"%@至%@",startDate,endDate];
    self.labelUpTime.text = [dictInfo[@"dates"] substringToIndex:16];
    self.labelState = dictInfo[@"updateTime"];
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
