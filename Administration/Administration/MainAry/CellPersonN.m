
//
//  CellPerson.m
//  Administration
//
//  Created by zhang on 2017/10/27.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellPersonN.h"

@implementation CellPersonN

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
    UIImageView *imageViewHead = [[UIImageView alloc]init];
    imageViewHead.layer.cornerRadius = 20;
    imageViewHead.layer.masksToBounds = YES;
    [self.contentView addSubview:imageViewHead];
    [imageViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    self.imageViewHeader = imageViewHead;
    
    UILabel *labelName = [[UILabel alloc]init];
    labelName.textColor = GetColor(74, 75, 77, 1);
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewHead.mas_right).offset(5);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(14);
    }];
    self.labelName = labelName;
    
    UILabel *labelAccount = [[UILabel alloc]init];
    labelAccount.font = [UIFont systemFontOfSize:13];
    labelAccount.textColor = GetColor(115, 116, 117, 1);
    [self.contentView addSubview:labelAccount];
    [labelAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewHead.mas_right).offset(5);
        make.top.mas_equalTo(labelName.mas_bottom).offset(5);
        make.height.mas_equalTo(13);
    }];
    self.labelAcccount = labelAccount;
    
    UILabel *labelTime = [[UILabel alloc]init];
    labelTime.font = [UIFont systemFontOfSize:12];
    labelTime.textColor = GetColor(115, 116, 117, 1);
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(6);
        make.height.mas_equalTo(12);
    }];
    self.labelTime = labelTime;
    
    UILabel *labelPosition = [[UILabel alloc]init];
    labelPosition.font = [UIFont systemFontOfSize:12];
    labelPosition.textColor = GetColor(115, 116, 117, 1);
    [self.contentView addSubview:labelPosition];
    [labelPosition mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.top.mas_equalTo(labelTime.mas_bottom).offset(5);
        make.height.mas_equalTo(12);
    }];
    self.labelPosition = labelPosition;
}

-(void)setDict:(NSDictionary *)dict
{
    [self.imageViewHeader sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,dict[@"icon"]]] placeholderImage:[UIImage imageNamed:@"banben100"]];
    self.labelName.text = dict[@"name"];
    self.labelPosition.text = dict[@"post"];
    self.labelAcccount.text = dict[@"account"];
    self.labelTime.text = [dict[@"time"]substringWithRange:NSMakeRange(5, 11)];
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
