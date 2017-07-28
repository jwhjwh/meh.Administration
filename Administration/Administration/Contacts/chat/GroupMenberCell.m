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
         self.selectImage.image = [UIImage imageNamed:@"yuanhuan_03"];
        [self.contentView addSubview:self.selectImage];
//        [self.selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self.contentView.mas_centerY);
//            make.height.mas_equalTo(30);
//            make.width.mas_equalTo(30);
//            if ([self.selectIndex isEqualToString:@"2"]) {
//               
//                make.left.mas_equalTo(self.contentView.mas_left).offset(8);
//            }
//            else
//            {
//                
//                make.left.mas_equalTo(self.contentView.mas_left);
//            }
//        }];
        
        self.TXImage = [[UIImageView alloc]init];
        self.TXImage.layer.cornerRadius = 25;
        self.TXImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.TXImage];
        [self.TXImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.selectImage.mas_right).offset(8);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(50);
        }];

        
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
        
        
        
        
        self.locationButton = [[UIButton alloc]init];
        [self.locationButton setTitle:@"查看位置" forState:UIControlStateNormal];
        [self.locationButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.locationButton addTarget:self action:@selector(checkLocation) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.locationButton];
        [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-24);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
           // make.width.mas_equalTo(40);
            make.height.mas_equalTo(12);
        }];
        
        self.labelDivision = [[UILabel alloc]init];
        self.labelDivision.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.labelDivision];
        [self.labelDivision mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.locationButton.mas_left).offset(-12);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(28);
        }];
        
        self.zhiLabel = [[UILabel alloc]init];
        self.zhiLabel.textColor = [UIColor lightGrayColor];
        self.zhiLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.zhiLabel];
        [self.zhiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-30);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(14);
        }];

    }
    return self;
}

- (void) setChecked:(BOOL)checked
{
    //选中
    if (self.isSelected)
    {
        //勾选的图标
        self.selectImage.image  = [UIImage imageNamed:@"xuanzhong"];
        self.isSelected = YES;
    }
    //反选
    else
    {
        //反选的图标
        self.selectImage.image  = [UIImage imageNamed:@"weixuanzhong"];
        self.isSelected = NO;
    }
    
}


-(void)checkLocation
{
    NSLog(@"查看位置");
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
