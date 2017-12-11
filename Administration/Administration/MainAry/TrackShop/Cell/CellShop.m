//
//  CellShop.m
//  Administration
//
//  Created by zhang on 2017/12/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellShop.h"

@interface CellShop ()

@property (nonatomic,weak)UILabel *labelShop;
@property (nonatomic,weak)UILabel *labelAddress;
@property (nonatomic,weak)UILabel *labelName;
@property (nonatomic,weak)UILabel *labelPerson;

@end

@implementation CellShop

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
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"详情>>" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(21);
    }];
    self.buttonDetail = button;
    
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"店名";
    label1.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labelShop = [[UILabel alloc]init];
    labelShop.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:labelShop];
    [labelShop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right).offset(20);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.right.mas_equalTo(button.mas_left).offset(-20);
        make.height.mas_equalTo(21);
    }];
    self.labelShop = labelShop;
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"地址";
    label2.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(label1.mas_bottom).offset(8);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labelAddress = [[UILabel alloc]init];
    labelAddress.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:labelAddress];
    [labelAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label2.mas_right).offset(20);
        make.top.mas_equalTo(labelShop.mas_bottom).offset(8);
        make.right.mas_equalTo(button.mas_left).offset(-20);
        make.height.mas_equalTo(21);
    }];
    self.labelAddress = labelAddress;
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"老板";
    label3.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(label2.mas_bottom).offset(8);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labelName = [[UILabel alloc]init];
    labelName.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label3.mas_right).offset(20);
        make.top.mas_equalTo(labelAddress.mas_bottom).offset(8);
        make.right.mas_equalTo(button.mas_left).offset(-20);
        make.height.mas_equalTo(21);
    }];
    self.labelName = labelName;
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.text = @"负责人";
    label4.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(label3.mas_bottom).offset(8);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labelPerson = [[UILabel alloc]init];
    labelPerson.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:labelPerson];
    [labelPerson mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label4.mas_right).offset(20);
        make.top.mas_equalTo(labelName.mas_bottom).offset(8);
        make.right.mas_equalTo(button.mas_left).offset(-20);
        make.height.mas_equalTo(21);
    }];
    self.labelPerson = labelPerson;
}

-(void)setDict:(NSDictionary *)dict
{
    NSString *shopName = @"" ;
    NSString *province = @"";
    NSString *city = @"";
    NSString *country = @"";
    NSString *boss = @"";
    NSString *name = @"";
    
    if (![dict[@"storeName"] isKindOfClass:[NSNull class]]) {
        shopName = dict[@"storeName"];
    }
    
    if (![dict[@"province"] isKindOfClass:[NSNull class]]) {
        province =dict[@"province"];
    }
    if (![dict[@"city"] isKindOfClass:[NSNull class]]) {
        city = dict[@"city"];
    }
    if (![dict[@"county"] isKindOfClass:[NSNull class]]) {
        country = dict[@"county"];
    }
    if (![dict[@"boss"] isKindOfClass:[NSNull class]]) {
        boss = dict[@"boss"];
    }
    
    if (![dict[@"name"] isKindOfClass:[NSNull class]]) {
        name = dict[@"name"];
    }
    
    self.labelShop.text = shopName;
    self.labelAddress.text = [NSString stringWithFormat:@"%@%@%@",province,city,country];
    
    self.labelName.text = boss;
    self.labelPerson.text = name;
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
