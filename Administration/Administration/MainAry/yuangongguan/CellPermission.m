//
//  CellPermission.m
//  Administration
//
//  Created by zhang on 2017/10/31.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellPermission.h"

@implementation CellPermission

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
    UILabel *labelMan = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 110, 12)];
    labelMan.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:labelMan];
//    [labelMan mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
//        make.top.mas_equalTo(15);
//        make.height.mas_equalTo(12);
//        make.width.mas_equalTo(110);
//    }];
    self.labelMan = labelMan;
    
    UILabel *labelPostion = [[UILabel alloc]initWithFrame:CGRectMake(140, 37, 100, 21)];
    labelPostion.layer.borderColor = GetColor(192, 192, 192, 1).CGColor;
    labelPostion.layer.borderWidth = 1.0f;
    labelPostion.layer.cornerRadius = 3.0f;
    labelPostion.layer.masksToBounds = YES;
    labelPostion.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:labelPostion];
//    [labelPostion mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(labelMan.mas_right).offset(30);
//        make.top.mas_equalTo(labelMan.mas_bottom).offset(20);
//        make.height.mas_equalTo(21);
//        make.width.mas_equalTo(100);
//    }];
    self.labelPostion = labelPostion;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(250, 42, 15, 15)];
    [button setImage:[UIImage imageNamed:@"xk_ico01"] forState:UIControlStateNormal];
    [self.contentView addSubview:button];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(labelPostion.mas_right).offset(5);
//        make.top.mas_equalTo(labelMan.mas_bottom).offset(22);
//        make.height.mas_equalTo(15);
//        make.width.mas_equalTo(15);
//    }];
    self.buttonSelect = button;
    
    
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
