//
//  CellEditTable.m
//  Administration
//
//  Created by zhang on 2017/9/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellEditTable.h"

@implementation CellEditTable

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
    UILabel *labelTitle = [[UILabel alloc]init];
    labelTitle.textColor = GetColor(117, 118, 119, 1);
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
        make.width.mas_equalTo(140);
    }];
    self.labelTitle = labelTitle;
    
    UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc]init];
    textView.textColor = GetColor(127, 128, 129, 192);
    textView.font = [UIFont systemFontOfSize:17];
    textView.scrollEnabled = NO;
    [self.contentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelTitle.mas_right).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
    }];
    textView.editable = NO;
    self.textView = textView;
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
