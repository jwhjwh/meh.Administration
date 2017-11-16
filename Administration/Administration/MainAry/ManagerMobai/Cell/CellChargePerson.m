//
//  CellChargePerson.m
//  Administration
//
//  Created by zhang on 2017/11/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellChargePerson.h"

@implementation CellChargePerson

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
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(21);
    }];
    self.labelTitle = labelTitle;
    
    UIButton *buttonAdd = [[UIButton alloc]init];
    buttonAdd.layer.cornerRadius = 20;
    buttonAdd.layer.masksToBounds = YES;
    [self.contentView addSubview:buttonAdd];
    [buttonAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.mas_equalTo(labelTitle.mas_bottom).offset(5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    self.buttonAdd = buttonAdd;
    
    UIButton *buttonDel = [[UIButton alloc]init];
    buttonDel.hidden = YES;
    buttonDel.userInteractionEnabled = NO;
    buttonDel.layer.cornerRadius = 20;
    buttonDel.layer.masksToBounds = YES;
    [buttonDel setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
    [self.contentView addSubview:buttonDel];
    [buttonDel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(buttonAdd.mas_right).offset(10);
        make.top.mas_equalTo(labelTitle.mas_bottom).offset(5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    self.buttonDel = buttonDel;
    
    UIButton *buttonRed = [[UIButton alloc]init];
    buttonRed.hidden = YES;
    buttonRed.userInteractionEnabled = NO;
    [buttonRed setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.contentView addSubview:buttonRed];
    [buttonRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(buttonAdd.mas_right);
        make.top.mas_equalTo(labelTitle.mas_bottom).offset(3);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(5);
    }];
    self.buttonRed = buttonRed;
    
    UILabel *labelName = [[UILabel alloc]init];
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(buttonAdd.mas_bottom).offset(5);
        make.height.mas_equalTo(21);
    }];
    self.labelName = labelName;
}

-(void)setDict:(NSDictionary *)dict
{
    self.labelName.text = dict[@"name"];
    self.labelTitle.text = dict[@"charge"];
    [self.buttonAdd setImage:[UIImage imageNamed:dict[@"icon"]] forState:UIControlStateNormal];
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
