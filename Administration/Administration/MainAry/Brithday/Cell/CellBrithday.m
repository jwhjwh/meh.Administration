//
//  CellBrithday.m
//  Administration
//
//  Created by zhang on 2017/11/25.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CellBrithday.h"

@interface CellBrithday ()

@property (nonatomic,weak)UIImageView *imageViewHead;
@property (nonatomic,weak)UILabel *labelName;
@property (nonatomic,weak)UILabel *labelPostion;
@property (nonatomic,weak)UILabel *labelBrithday;
@property (nonatomic,weak)UILabel *labelLater;

@end

@implementation CellBrithday

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
        make.left.mas_equalTo (self.contentView.mas_left).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    self.imageViewHead = imageViewHead;
    
    UILabel *labelName = [[UILabel alloc]init];
    labelName.textColor = GetColor(106, 106, 106, 1);
    labelName.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewHead.mas_right).offset(5);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(14);
    }];
    self.labelName = labelName;
    
    UILabel *labelPostion = [[UILabel alloc]init];
    labelPostion.font = [UIFont systemFontOfSize:12];
    labelPostion.textColor = GetColor(153, 152, 153, 1);
    [self.contentView addSubview:labelPostion];
    [labelPostion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewHead.mas_right).offset(5);
        make.top.mas_equalTo(labelName.mas_bottom).offset(5);
        make.height.mas_equalTo(12);
    }];
    self.labelPostion = labelPostion;
    
    UILabel *labelBrithday = [[UILabel alloc]init];
    labelBrithday.font = [UIFont systemFontOfSize:12];
    labelBrithday.textColor = GetColor(150, 150, 150, 1);
    [self.contentView addSubview:labelBrithday];
    [labelBrithday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageViewHead.mas_right).offset(5);
        make.top.mas_equalTo(labelPostion.mas_bottom).offset(5);
        make.height.mas_equalTo(12);
    }];
    self.labelBrithday = labelBrithday;
    
    UILabel *labelLater = [[UILabel alloc]init];
    labelLater.font = [UIFont systemFontOfSize:12];
    labelLater.textColor = GetColor(112, 112, 112, 1);
    [self.contentView addSubview:labelLater];
    [labelLater mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.mas_equalTo(labelBrithday.mas_bottom);
        make.height.mas_equalTo(12);
    }];
    self.labelLater = labelLater;
}

-(void)setDict:(NSDictionary *)dict
{
    NSURL *urlIcon = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,dict[@"icon"]]];
    [self.imageViewHead sd_setImageWithURL:urlIcon placeholderImage:[UIImage imageNamed:@"banben100"]];
    
    self.labelName.text = dict[@"name"];
    self.labelPostion.text = dict[@"newName"];
    self.labelLater.text = [NSString stringWithFormat:@"提前%@天",dict[@"days"]];
    
    if ([dict[@"flag"]intValue]==1) {
        self.labelBrithday.text = [NSString stringWithFormat:@"阴历 %@",dict[@"lunarBirthday"]];
    }else
    {
        self.labelBrithday.text = [NSString stringWithFormat:@"阳历 %@",dict[@"solarBirthday"]];
    }
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
