//
//  GroupCell.m
//  Administration
//
//  Created by zhang on 2017/7/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "GroupCell.h"

@implementation GroupCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.headImageView];
        self.headImageView.layer.cornerRadius = 25;
        self.headImageView.layer.masksToBounds = YES;

        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(50);
        }];
        
        self.nameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.left).offset(65);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(20);
        }];
        
        self.noReadLabel = [[UILabel alloc]init];
        self.noReadLabel.layer.cornerRadius = 25;
        self.noReadLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:self.noReadLabel];
        [self.noReadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(40);
        }];
        
        
    }
    return self;
}

//-(void)setModel:(NSDictionary *)model;
//{
//    
//    model = self.model;
//    self.nameLabel.text = [NSString stringWithFormat:@"%@",model[@"name"]];
//    
//    NSString *stringUrl = [NSString stringWithFormat:@"%@%@",KURLHeader,model[@"img"]];
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:stringUrl] placeholderImage:[UIImage imageNamed:@"banben100"]];
//    int unread = [model[@"unread"] intValue];
//    if (unread!=0) {
//        self.noReadLabel.text = [NSString stringWithFormat:@"%@",model[@"unread"]];
//    }
//    else
//    {
//        self.noReadLabel.hidden = YES;
//    }
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
