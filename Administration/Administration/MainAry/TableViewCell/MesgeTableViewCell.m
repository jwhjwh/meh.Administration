//
//  MesgeTableViewCell.m
//  Administration
//
//  Created by 费腾 on 17/2/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "MesgeTableViewCell.h"

@implementation MesgeTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
- (void) addSubviews {
    _logeImage=[[UIImageView alloc]init];
    // 设置圆角半径
    [self addSubview:_logeImage];
    _timeLabel=[[UILabel alloc]init];
    _timeLabel.textAlignment=NSTextAlignmentRight;
    _timeLabel.font=[UIFont systemFontOfSize:12];
    _timeLabel.textColor=[UIColor lightGrayColor];
    [self addSubview:_timeLabel];
    _hongLabel=[[UILabel alloc]init];
    _hongLabel.layer.masksToBounds = YES;
    // 设置圆角半径
    _hongLabel.layer.cornerRadius =5.0f;
   
    [_logeImage addSubview:_hongLabel];
    _titleLabel=[[UILabel alloc]init];
    _titleLabel.font=[UIFont systemFontOfSize:20];
    
    [self addSubview:_titleLabel];

    _contLabel=[[UILabel alloc]init];
    _contLabel.textColor=[UIColor lightGrayColor];
    _contLabel.numberOfLines=0;
    [self addSubview:_contLabel];
    [_logeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.width.offset(54);
        make.height.offset(54);
    }];
    [_hongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_logeImage.mas_right).offset(-8);
        make.top.mas_equalTo(_logeImage.mas_top);
        make.width.offset(10);
        make.height.offset(10);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_logeImage.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(_logeImage.mas_top);
        make.height.offset(20);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.width.offset(130);
        make.height.offset(16);
    }];
    [_contLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(_timeLabel.mas_bottom);
        make.left.mas_equalTo(_logeImage.mas_right).offset(10);
        make.bottom.mas_equalTo(_logeImage.mas_bottom);
    }];
    
   
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)setModel:(mesgeModel *)model{
  _hongLabel.backgroundColor=[UIColor redColor];
  NSString *timeStr = [model.dates substringWithRange:NSMakeRange(5,11)];
    _timeLabel.text=timeStr;
    
    if ([model.tableName isEqualToString:@"MarketDayReport"]|| [model.tableName isEqualToString:@"ClerkDayReport"]
        || [model.tableName isEqualToString:@"SecretaryDayReport"]) {
        _contLabel.text=@"店报表有新的动态";
    } else if ([model.tableName isEqualToString:@"MarketWeekPlanReport"]|| [model.tableName isEqualToString:@"ClerkWeekPlanReport"]
               || [model.tableName isEqualToString:@"SecretaryWeekPlanReport"]) {
        _contLabel.text=@"周计划有新的动态";
    } else if ([model.tableName isEqualToString:@"MarketMonthPlanReport" ]|| [model.tableName isEqualToString:@"SecretaryMonthPlanReport"]) {
       _contLabel.text=@"月计划有新的动态";
    } else if ([model.tableName isEqualToString:@"MarketMonthSumReport"] || [model.tableName isEqualToString:@"SecretaryMonthSumReport"]) {
        _contLabel.text=@"月总结有新的动态";
    } else if ([model.tableName isEqualToString:@"MarketWeekSumReport"] || [model.tableName isEqualToString:@"SecretaryWeekSumReport"]
               || [model.tableName isEqualToString:@"ClerkWeekSumReport"]) {
        _contLabel.text=@"周总结有新的动态";
    }
    if ([model.flag isEqual:@"1"]) {
        _logeImage.image=[UIImage imageNamed:@"baobiaoguanli"];
        _titleLabel.text=@"报表管理";
    }else{
        _titleLabel.text=@"我的报表";
        _logeImage.image=[UIImage imageNamed:@"baobiaomokuai"];
    }
}
@end
