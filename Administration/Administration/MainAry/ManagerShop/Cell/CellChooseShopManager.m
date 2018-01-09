//
//  CellChooseShopManager.m
//  Administration
//
//  Created by zhang on 2017/12/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellChooseShopManager.h"

@interface CellChooseShopManager ()
@property (nonatomic,weak)UILabel *labelName;
@property (nonatomic,weak)UIImageView *imageViewSelect;
@end

@implementation CellChooseShopManager


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
    [imageViewSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    self.imageViewSelect = imageViewSelect;
    
    UILabel *labelName = [[UILabel alloc]init];
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewSelect.mas_right).offset(8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(21);
    }];
    self.labelName = labelName;
}

-(void)setDict:(NSDictionary *)dict
{
    if ([dict[@"isSelect"]isEqualToString:@"1"]) {
        self.imageViewSelect.image = [UIImage imageNamed:@"weixuanzhong"];
    }else
    {
        self.imageViewSelect.image = [UIImage imageNamed:@"xuanzhong"];
    }
    
    self.labelName.text = dict[@"storeName"];
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
