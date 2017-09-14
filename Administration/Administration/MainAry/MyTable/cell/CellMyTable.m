//
//  CellMyTable.m
//  Administration
//
//  Created by zhang on 2017/9/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellMyTable.h"

@implementation CellMyTable

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
    UIImageView *imageVeiwHead = [[UIImageView alloc]init];
    imageVeiwHead.layer.cornerRadius = 20;
    imageVeiwHead.layer.masksToBounds = YES;
    [self.contentView addSubview:imageVeiwHead];
    [imageVeiwHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    self.imageViewHead = imageVeiwHead;
    
    UILabel *labelName = [[UILabel alloc]init];
    labelName.textColor = [UIColor lightGrayColor];
    labelName.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageVeiwHead.mas_right).offset(5);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(15);
    }];
    self.labelName = labelName;
    
    UILabel *labelPostion = [[UILabel alloc]init];
    labelPostion.textColor = GetColor(192, 192, 192, 1);
    labelPostion.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:labelPostion];
    [labelPostion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageVeiwHead.mas_right).offset(5);
        make.top.mas_equalTo(labelName.mas_bottom).offset(3);
        make.height.mas_equalTo(13);
    }];
    self.labelPosition = labelPostion;
    
    UILabel *labelTime = [[UILabel alloc]init];
    labelTime.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(labelPostion.mas_bottom).offset(13);
        make.height.mas_equalTo(17);
    }];
    self.labelTime = labelTime;
    
    UILabel *labelDescribe = [[UILabel alloc]init];
    labelDescribe.numberOfLines = 0;
    labelDescribe.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:labelDescribe];
    [labelDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(8);
        make.right.mas_equalTo(self.contentView).offset(-8);
        make.top.mas_equalTo(labelTime.mas_bottom).offset(5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    self.labelDescribe = labelDescribe;
    
    UILabel *labelUpTime = [[UILabel alloc]init];
    labelUpTime.font = [UIFont systemFontOfSize:13];
    labelUpTime.textColor = GetColor(192, 192, 192, 1);
    [self.contentView addSubview:labelUpTime];
    [labelUpTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.right.mas_equalTo(self.contentView).offset(-8);
        make.height.mas_equalTo(13);
    }];
    self.labelUpTime = labelUpTime;
}

-(void)setDict:(NSDictionary *)dict
{
    self.labelName.text  = dict[@"name"];
    [self.imageViewHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,dict[@"icon"]]] placeholderImage:[UIImage imageNamed:@"banben100"]];
    self.labelPosition.text = dict[@"newName"];
    if (dict[@"dateLine"]) {
        NSString *stringDate = [dict[@"dateLine"] substringToIndex:10];
        self.labelTime.text = [NSString stringWithFormat:@"日期：%@",stringDate];
    }
    if (dict[@"dates"]) {
        self.labelUpTime.text = [dict[@"dates"]substringToIndex:16];
    }
    self.labelDescribe.text = dict[@"describe"];

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
