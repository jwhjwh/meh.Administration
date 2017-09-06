//
//  CellPerson.m
//  Administration
//
//  Created by zhang on 2017/8/31.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellPerson.h"

@implementation CellPerson

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUI
{
    UIImageView *imageViewHead = [[UIImageView alloc]init];
    imageViewHead.layer.cornerRadius = 25;
    imageViewHead.layer.masksToBounds = YES;
    [self.contentView addSubview:imageViewHead];
    [imageViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        
    }];
    self.imageViewHead = imageViewHead;
    
    UILabel *labelName = [[UILabel alloc]init];
    labelName.textColor = [UIColor blackColor];
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.left.mas_equalTo(imageViewHead.mas_right).offset(5);
        make.height.mas_equalTo(17);
       // make.width.mas_equalTo(100);
    }];
    self.labelName = labelName;
    
    UILabel *labelAccount = [[UILabel alloc]init];
    labelAccount.textColor = GetColor(192, 192, 192, 192);
    labelAccount.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:labelAccount];
    [labelAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewHead.mas_right).offset(5);
        make.top.mas_equalTo(labelName.mas_bottom).offset(5);
        make.height.mas_equalTo(12);
      //  make.width.mas_equalTo(100);
    }];
    self.labelAccount = labelAccount;
}
-(void)setDict:(NSDictionary *)dict
{
    
    self.labelName.text = dict[@"name"];
    self.labelAccount.text = dict[@"account"];
    [self.imageViewHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,dict[@"icon"]]] placeholderImage:[UIImage imageNamed:@"banben100"]];
    
}

@end
