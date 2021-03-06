//
//  CellChooseArea.m
//  Administration
//
//  Created by zhang on 2017/12/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellChooseArea.h"

@implementation CellChooseArea

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
    UILabel *labelLine = [[UILabel alloc]init];
    labelLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:labelLine];
    [labelLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(1);
    }];
    self.labelLine = labelLine;
    
    UILabel *labelName = [[UILabel alloc]init];
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelLine.mas_right).offset(5);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(21);
    }];
    self.labelName = labelName;
    
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
