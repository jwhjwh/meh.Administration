//
//  CellTbale.m
//  Administration
//
//  Created by zhang on 2017/8/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellTbale.h"

@implementation CellTbale

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *labelMold = [[UILabel alloc]init];
        labelMold.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:labelMold];
        [labelMold mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(5);
            make.left.mas_equalTo(self.contentView.mas_left).offset(5);
            make.height.mas_equalTo(17);
        }];
        self.labelMold = labelMold;
        
        UILabel *labelName = [[UILabel alloc]init];
        labelName.font = [UIFont systemFontOfSize:14];
        labelName.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:labelName];
        [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
           // make.top.mas_equalTo(labelMold.mas_bottom).offset(2);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.contentView.mas_left).offset(5);
            make.height.mas_equalTo(14);
        }];
        self.lableName = labelName;
        
        UILabel *labelAccount = [[UILabel alloc]init];
        labelAccount.font = [UIFont systemFontOfSize:12];
        labelAccount.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:labelAccount];
        [labelAccount mas_makeConstraints:^(MASConstraintMaker *make) {
           // make.top.mas_equalTo(labelName.mas_bottom).offset(2);
            make.left.mas_equalTo(self.contentView.mas_left).offset(5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
            make.height.mas_equalTo(12);
        }];
        self.lableAccount = labelAccount;
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"jiantou_03"];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(9);
            make.height.mas_equalTo(15);
        }];
        
        UILabel *labelTime = [[UILabel alloc]init];
        labelTime.font = [UIFont systemFontOfSize:12];
        labelTime.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:labelTime];
        [labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(imageView.mas_left).offset(8);
            make.top.mas_equalTo(self.contentView.mas_top).offset(5);
            make.height.mas_equalTo(12);
        }];
        self.labelTime = labelTime;
        
        UILabel *labelStatus = [[UILabel alloc]init];
        labelStatus.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:labelStatus];
        [labelStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(imageView.mas_left).offset(8);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(12);
        }];
        self.labelStatus = labelStatus;
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

@end
