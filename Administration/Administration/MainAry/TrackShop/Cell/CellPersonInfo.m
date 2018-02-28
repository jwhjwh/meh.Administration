//
//  CellPersonInfo.m
//  Administration
//
//  Created by zhang on 2017/12/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellPersonInfo.h"

@interface CellPersonInfo ()

@property (nonatomic,weak)UILabel *labelName;
@property (nonatomic,weak)UILabel *labelBrithday;
@property (nonatomic,weak)UILabel *labelAge;
@property (nonatomic,weak)UILabel *labelAccount;

@end

@implementation CellPersonInfo

-(void)setUI
{
    UILabel *labelName = [[UILabel alloc]init];
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(21);
    }];
    self.labelName = labelName;
    
    UILabel *labelBrithday = [[UILabel alloc]init];
    [self.contentView addSubview:labelBrithday];
    [labelBrithday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelName.mas_right).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(21);
    }];
    self.labelBrithday = labelBrithday;
    
    UILabel *labelAge = [[UILabel alloc]init];
    [self.contentView addSubview:labelAge];
    [labelAge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelBrithday.mas_right).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(21);
    }];
    self.labelAge = labelAge;
    
    UILabel *labelAccount = [[UILabel alloc]init];
    [self.contentView addSubview:labelAccount];
    [labelAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelAge.mas_right).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(21);
    }];
    self.labelAccount = labelAccount;
}

-(void)setDict:(NSDictionary *)dict
{
    self.labelName.text = dict[@"name"];
    if (![dict[@"flag"]isKindOfClass:[NSNull class]]) {
        if ([dict[@"flag"]intValue]==1) {
            self.labelBrithday.text = dict[@"lunarBirthday"];
        }else
        {
            self.labelBrithday.text = dict[@"solarBirthday"];
        }
    }
    
    
    self.labelAge.text = [NSString stringWithFormat:@"%@",dict[@"age"]];
    self.labelAccount.text = dict[@"phone"];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
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
