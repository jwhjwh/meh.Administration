//
//  CellPostil.m
//  Administration
//
//  Created by zhang on 2017/8/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellPostil.h"

@implementation CellPostil
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *labelPosition = [[UILabel alloc]init];
        [self.contentView addSubview:labelPosition];
        [labelPosition mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
            make.top.mas_equalTo(self.contentView.mas_top).offset(8);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(14);
        }];
        self.labelPosition = labelPosition;
        
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
