//
//  CellPersonManager.m
//  Administration
//
//  Created by zhang on 2018/1/17.
//  Copyright © 2018年 九尾狐. All rights reserved.
//

#import "CellPersonManager.h"

@interface CellPersonManager ()
@property (nonatomic,weak)UIImageView *imageViewHead;
@property (nonatomic,weak)UILabel *labelName;
@property (nonatomic,weak)UILabel *labelAcccount;
@property (nonatomic,weak)UILabel *labelPostion;
@end

@implementation CellPersonManager

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
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewHead.mas_right).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.height.mas_equalTo(21);
    }];
    self.labelName = labelName;
    
    UILabel *labelAccount = [[UILabel alloc]init];
    [self.contentView addSubview:labelAccount];
    [labelAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewHead.mas_right).offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
        make.height.mas_equalTo(21);
    }];
    self.labelAcccount = labelAccount;
    
    UILabel *labelPostion = [[UILabel alloc]init];
    [self.contentView addSubview:labelPostion];
    [labelPostion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo (self.contentView.mas_right).offset(-8);
        make.height.mas_equalTo(21);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
    }];
    self.labelPostion = labelPostion;
    
}

-(void)setDict:(NSDictionary *)dict
{
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,dict[@"icon"]]];
    [self.imageViewHead sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"banben100"]];
    
    self.labelName.text = dict[@"name"];
    self.labelAcccount.text = dict[@"account"];
    self.labelPostion.text = dict[@"newName"];
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
