//
//  CellEditInfo.m
//  Administration
//
//  Created by zhang on 2017/9/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellEditInfo.h"

@implementation CellEditInfo

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
    UILabel *labelTitle  = [[UILabel alloc]init];
    labelTitle.textColor = GetColor(102, 103, 104, 1);
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(100);
    }];
    self.labelTitle = labelTitle;
    
    UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc]init];
    textView.textColor = GetColor(188, 189, 190, 1);
    textView.scrollEnabled = NO;
    textView.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelTitle.mas_right).offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
    }];
    self.textView = textView;
    
    UILabel *labelline = [[UILabel alloc]init];
    labelline.backgroundColor = GetColor(189, 189, 189, 1);
    [self.contentView addSubview:labelline];
    [labelline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textView.mas_bottom).offset(5);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
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
