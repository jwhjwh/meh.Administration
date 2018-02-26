//
//  CellChargeManager.m
//  Administration
//
//  Created by zhang on 2017/12/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellChargeManager.h"

@interface CellChargeManager ()

@property (nonatomic,weak)UIImageView *imageViewHead;
@property (nonatomic,weak)UILabel *labelName;
@property (nonatomic,weak)UILabel *labelPhone;

@end

@implementation CellChargeManager

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
    UIImageView *imageViewSelect = [[UIImageView alloc]init];
    imageViewSelect.image = [UIImage imageNamed:@"weixuanzhong"];
    [self.contentView addSubview:imageViewSelect];
    self.imageViewSelect = imageViewSelect;
    
    UIImageView *imageViewHead = [[UIImageView alloc]init];
    imageViewHead.layer.cornerRadius = 25;
    imageViewHead.layer.masksToBounds = YES;
    [self.contentView addSubview:imageViewHead];
    [imageViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewSelect.mas_right).offset(8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    self.imageViewHead = imageViewHead;
    
    UILabel *labelName = [[UILabel alloc]init];
    labelName.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewHead.mas_right).offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_centerY).offset(2);
        make.height.mas_equalTo(21);
    }];
    self.labelName = labelName;
    
    UILabel *labelPhone = [[UILabel alloc]init];
    labelPhone.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:labelPhone];
    [labelPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewHead.mas_right).offset(8);
        make.top.mas_equalTo(self.contentView.mas_centerY).offset(2);
        make.height.mas_equalTo(21);
    }];
    self.labelPhone = labelPhone;
    
    UIButton *buttonDel = [[UIButton alloc]init];
    buttonDel.hidden = YES;
    buttonDel.userInteractionEnabled = NO;
    [buttonDel setTitle:@"移除" forState:UIControlStateNormal];
    [buttonDel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.contentView addSubview:buttonDel];
    [buttonDel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
    }];
    self.buttonDel = buttonDel;
    
    UILabel *labelLine = [[UILabel alloc]init];
    labelLine.hidden = YES;
    labelLine.backgroundColor = GetColor(192, 192, 192, 1);
    [self.contentView addSubview:labelLine];
    [labelLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(buttonDel.mas_left);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
        make.width.mas_equalTo(1);
    }];
    self.labelLine = labelLine;
}

-(void)setDict:(NSDictionary *)dict
{
    if ([dict[@"isSelect"]isEqualToString:@"1"]) {
        self.imageViewSelect.image = [UIImage imageNamed:@"weixuanzhong"];
    }else
    {
        self.imageViewSelect.image = [UIImage imageNamed:@"xuanzhong"];
    }
    
    self.labelName.text = dict[@"name"];
    self.labelPhone.text = dict[@"account"];
    [self.imageViewHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,dict[@"icon"]]] placeholderImage:[UIImage imageNamed:@"banben100"]];
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
