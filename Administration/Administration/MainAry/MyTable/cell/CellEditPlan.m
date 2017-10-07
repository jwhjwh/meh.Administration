//
//  CellEditPlan.m
//  Administration
//
//  Created by zhang on 2017/9/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellEditPlan.h"

@implementation CellEditPlan

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
    UILabel *LabelTitle = [[UILabel alloc]init];
    [self.contentView addSubview:LabelTitle];
    [LabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(14);
    }];
    self.LabelTitle = LabelTitle;
    
    UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc]init];
    textView.textColor = GetColor(188, 189, 190, 1);
    textView.scrollEnabled = NO;
    textView.layer.borderColor = GetColor(188, 189, 190, 1).CGColor;
    textView.layer.borderWidth = 1.0f;
    textView.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(LabelTitle.mas_bottom).offset(8);
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
    }];
    self.textView = textView;
    
    UILabel *labelNumber = [[UILabel alloc]init];
    labelNumber.font = [UIFont systemFontOfSize:10];
    labelNumber.textColor = GetColor(240, 50, 74, 1);
    labelNumber.hidden = YES;
    [self.contentView addSubview:labelNumber];
    [labelNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(10);
    }];
    self.labelNumber = labelNumber;
    
    UIImageView *imagePostil = [[UIImageView alloc]init];
    imagePostil.image = [UIImage imageNamed:@"pz_ico01"];
    imagePostil.hidden = YES;
    [self.contentView addSubview:imagePostil];
    [imagePostil mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(labelNumber.mas_right).offset(-1);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    self.imagePositil = imagePostil;
    
    
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
