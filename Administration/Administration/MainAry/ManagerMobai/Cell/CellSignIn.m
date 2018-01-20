//
//  CellSignIn.m
//  Administration
//
//  Created by zhang on 2017/12/27.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellSignIn.h"

@interface CellSignIn ()
@property (nonatomic,weak)UILabel *labelAddress;
@property (nonatomic,weak)UILabel *labelTime;
@property (nonatomic,weak)UILabel *labelMood;

@end

@implementation CellSignIn

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
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"地址：";
    [self.contentView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(60);
    }];
    
    UILabel *labelAddress = [[UILabel alloc]init];
    labelAddress.numberOfLines = 0;
    [self.contentView addSubview:labelAddress];
    [labelAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
    }];
    self.labelAddress = labelAddress;
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"时间：";
    [self.contentView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(labelAddress.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(60);
    }];
    
    UILabel *labelTime = [[UILabel alloc]init];
    labelTime.numberOfLines = 0;
    [self.contentView addSubview:labelTime];
    [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label2.mas_right).offset(8);
        make.top.mas_equalTo(labelAddress.mas_bottom).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
    }];
    self.labelTime = labelTime;
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"心情描述：";
    [self.contentView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.top.mas_equalTo(labelTime.mas_bottom).offset(8);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(90);
    }];
    
    UILabel *labelMood = [[UILabel alloc]init];
    labelMood.numberOfLines = 0;
    [self.contentView addSubview:labelMood];
    [labelMood mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label3.mas_right).offset(8);
        make.top.mas_equalTo(labelTime.mas_bottom).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.bottom.mas_equalTo (self.contentView.mas_bottom).offset(-8);
    }];
    self.labelMood = labelMood;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDict:(NSDictionary *)dict
{
    
    self.labelMood.text = dict[@"moodDescribe"];
    self.labelTime.text = [dict[@"dates"]substringWithRange:NSMakeRange(5, 11)];
    
    self.labelAddress.text = dict[@"address"];
}

@end
