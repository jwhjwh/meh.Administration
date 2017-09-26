//
//  CellDrafts.m
//  Administration
//
//  Created by zhang on 2017/9/26.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellDrafts.h"

@implementation CellDrafts

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
    UILabel *labelName = [[UILabel alloc]init];
    labelName.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(17);
    }];
    self.labelName = labelName;
    
    UILabel *labelTime =[[UILabel alloc]init];
    labelTime.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(labelName.mas_bottom).offset(5);
        make.height.mas_equalTo(15);
    }];
    self.labelTime = labelTime;
    
    UILabel *labelUpTime = [[UILabel alloc]init];
    labelUpTime.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:labelUpTime];
    [labelUpTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(17);
    }];
    self.labelUpTime = labelUpTime;
}

-(void)setDict:(NSDictionary *)dict
{
    if (dict[@"dateLine"]) {
        self.labelTime.text = [dict[@"dateLine"] substringToIndex:9];
    }
    
    if (dict[@"dates"]) {
        self.labelUpTime.text = [dict[@"dates"] substringWithRange:NSMakeRange(5, 16)];
    }
    
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
