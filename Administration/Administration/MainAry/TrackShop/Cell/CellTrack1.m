//
//  CellTrack1.m
//  Administration
//
//  Created by zhang on 2017/12/5.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellTrack1.h"

@implementation CellTrack1

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
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (self.contentView.mas_left).offset(8);
        make.top.mas_equalTo (self.contentView.mas_top).offset(8);
        make.bottom.mas_equalTo (self.contentView.mas_bottom).offset(-8);
        make.width.mas_equalTo(150);
    }];
    self.labelTitle = labelTitle;
    
    UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc]init];
    textView.scrollEnabled = NO;
    textView.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelTitle.mas_right).offset(20);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
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
