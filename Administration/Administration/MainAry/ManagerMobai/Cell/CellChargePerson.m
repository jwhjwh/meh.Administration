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
    
    UIImageView *imageViewAdd = [[UIImageView alloc]init];
    imageViewAdd.layer.cornerRadius = 20;
    imageViewAdd.layer.masksToBounds = YES;
    imageViewAdd.userInteractionEnabled = YES;
    imageViewAdd.image = [UIImage imageNamed:@"tj_ico01"];
    [self.contentView addSubview:imageViewAdd];
    [imageViewAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.mas_equalTo(labelTitle.mas_bottom).offset(5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    self.imageViewAdd = imageViewAdd;
    
    UIButton *buttonDel = [[UIButton alloc]init];
    buttonDel.hidden = YES;
    buttonDel.userInteractionEnabled = NO;
    buttonDel.layer.cornerRadius = 20;
    buttonDel.layer.masksToBounds = YES;
    [buttonDel setImage:[UIImage imageNamed:@"sc_ico01"] forState:UIControlStateNormal];
    [self.contentView addSubview:buttonDel];
    [buttonDel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewAdd.mas_right).offset(10);
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
        make.left.mas_equalTo(imageViewAdd.mas_right);
        make.top.mas_equalTo(labelTitle.mas_bottom).offset(3);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(5);
    }];
    self.buttonRed = buttonRed;
    
    UILabel *labelName = [[UILabel alloc]init];
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(imageViewAdd.mas_bottom).offset(5);
        make.height.mas_equalTo(21);
    }];
    self.labelName = labelName;
}

-(void)setDict:(NSDictionary *)dict
{
    self.labelName.text = dict[@"name"];
    self.labelTitle.text = dict[@"charge"];
    
    if (![dict[@"icon"]isEqualToString:@"tj_ico01"]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,dict[@"icon"]]];
        
        [self.imageViewAdd sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banben100"]];
    }
    
//    if (![dict[@"name"] isEqualToString:@""]) {
//        self.buttonDel.hidden = NO;
//        self.buttonDel.userInteractionEnabled = YES;
//    }
    
//    if ([dict[@"icon"] isEqualToString:@""]) {
//        [self.buttonAdd setImage:[UIImage imageNamed:@"banben100"] forState:UIControlStateNormal];
//    }else
//    {
//        [self.buttonAdd.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,dict[@"icon"]]] placeholderImage:[UIImage imageNamed:@"banben100"]];
//    }
//    [self.buttonAdd setImage:[UIImage imageNamed:dict[@"icon"]] forState:UIControlStateNormal];
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
