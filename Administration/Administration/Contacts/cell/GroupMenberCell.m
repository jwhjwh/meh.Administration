//
//  GroupMenberCell.m
//  Administration
//
//  Created by zhang on 2017/7/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "GroupMenberCell.h"

@implementation GroupMenberCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectImage = [[UIImageView alloc]init];
        self.selectImage.layer.cornerRadius = 15;
        self.selectImage.layer.masksToBounds = YES;
        self.selectImage.image = [UIImage imageNamed:@"weixuanzhong"];
        [self.contentView addSubview:self.selectImage];
        
        
        self.TXImage = [[UIImageView alloc]init];
        self.TXImage.layer.cornerRadius = 25;
        self.TXImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.TXImage];
        if (self.isMe) {
            [self.selectImage removeFromSuperview];
            [self.TXImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView.mas_left).offset(8);
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.height.mas_equalTo(50);
                make.width.mas_equalTo(50);
                
            }];
        }else
        {
            [self.TXImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.selectImage.mas_right).offset(8);
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.height.mas_equalTo(50);
                make.width.mas_equalTo(50);
            }];
        }
        
        
        self.nameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.TXImage.mas_right).offset(5);
            make.top.mas_equalTo(self.contentView.mas_top).offset(8);
            make.height.mas_equalTo(17);
        }];
        
        
        self.TelLabel = [[UILabel alloc]init];
        self.TelLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.TelLabel];
        [self.TelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.TXImage.mas_right).offset(5);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
        }];
    
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
