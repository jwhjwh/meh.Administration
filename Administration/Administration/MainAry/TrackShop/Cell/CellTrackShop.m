//
//  CellTrackShop.m
//  Administration
//
//  Created by zhang on 2017/12/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellTrackShop.h"

@interface CellTrackShop ()

@property (nonatomic,weak)UILabel *labelName;
@property (nonatomic,weak)UILabel *labelAccount;
@property (nonatomic,weak)UILabel *labelTime;
@property (nonatomic,weak)UILabel *labelUpTime;

@end

@implementation CellTrackShop

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
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *labelName = [[UILabel alloc]init];
    labelName.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(21);
    }];
    self.labelName = labelName;
    
    UILabel *labelAccount = [[UILabel alloc]init];
    labelAccount.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:labelAccount];
    [labelAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(labelName.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
    self.labelAccount = labelAccount;
    
    UILabel *labelTime = [[UILabel alloc]init];
    labelTime.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(21);
    }];
    self.labelTime = labelTime;
    
    UILabel *labelUpTime = [[UILabel alloc]init];
    labelUpTime.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:labelUpTime];
    [labelUpTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.top.mas_equalTo (labelTime.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
    }];
    self.labelUpTime = labelUpTime;
}

-(void)setDict:(NSDictionary *)dict
{
    self.labelName.text = dict[@"usersName"];
    self.labelAccount.text = dict[@"account"];
    self.labelTime.text = [dict[@"times"]substringToIndex:10];
    self.labelUpTime.text = [NSString stringWithFormat:@"上传：%@",[dict[@"dates"]substringWithRange:NSMakeRange(5, 11)]];
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
