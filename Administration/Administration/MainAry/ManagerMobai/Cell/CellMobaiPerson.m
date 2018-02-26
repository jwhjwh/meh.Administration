//
//  CellMobaiPerson.m
//  Administration
//
//  Created by zhang on 2017/11/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellMobaiPerson.h"

@implementation CellMobaiPerson

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
    UIImageView *imageViewHeader = [[UIImageView alloc]init];
    imageViewHeader.layer.cornerRadius = 25;
    imageViewHeader.layer.masksToBounds = YES;
    [self.contentView addSubview:imageViewHeader];
    [imageViewHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    self.imageViewHeader = imageViewHeader;
    
    UILabel *labelName = [[UILabel alloc]init];
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewHeader.mas_right).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(17);
    }];
    self.labelName = labelName;
    
    UILabel *labelAccount = [[UILabel alloc]init];
    labelAccount.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:labelAccount];
    [labelAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewHeader.mas_right).offset(8);
        make.top.mas_equalTo(labelName.mas_bottom).offset(5);
        make.height.mas_equalTo(12);
    }];
    self.labelAccount = labelAccount;
    
    UILabel *labelPostion = [[UILabel alloc]init];
    [self.contentView addSubview:labelPostion];
    [labelPostion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
        make.height.mas_equalTo(17);
    }];
    self.labelPosition = labelPostion;
    
    UILabel *labelDepartment = [[UILabel alloc]init];
    [self.contentView addSubview:labelDepartment];
    [labelDepartment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(21);
    }];
    self.labelDepartment = labelDepartment;
}

-(void)setDict:(NSDictionary *)dict
{
    [self.imageViewHeader sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,dict[@"icon"]]] placeholderImage:[UIImage imageNamed:@"banben100"]];
    self.labelName.text = dict[@"name"];
    self.labelAccount.text = dict[@"account"];
    self.labelDepartment.text = dict[@"departmentName"];
    self.labelPosition.text = dict[@"newName"];
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
