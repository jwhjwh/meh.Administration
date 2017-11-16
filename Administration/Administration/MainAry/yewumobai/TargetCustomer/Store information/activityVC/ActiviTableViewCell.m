//
//  ActiviTableViewCell.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ActiviTableViewCell.h"

@implementation ActiviTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}
-(void)setUI
{
    UIImageView *imageView1 = [[UIImageView alloc]init];
    imageView1.image = [UIImage imageNamed:@"weixuanzhong"];
    [self.contentView addSubview:imageView1];
    self.imageView1 = imageView1;
    
    
    UILabel *labelMode = [[UILabel alloc]init];
    labelMode.textColor = GetColor(72, 74, 75, 1);
    labelMode.font =[UIFont systemFontOfSize:17];
    labelMode.numberOfLines = 2;
   
    
    [self.contentView addSubview:labelMode];
    [labelMode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView1.mas_right).offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-110);
        make.height.mas_equalTo(50);
    }];
    self.labelMode = labelMode;
    
    UILabel *labelDate = [[UILabel alloc]init];
    labelDate.font = [UIFont systemFontOfSize:15];
    labelDate.textColor = GetColor(127, 128, 120, 1);
    [self.contentView addSubview:labelDate];
    [labelDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.height.mas_equalTo(15);
    }];
    self.labelDate = labelDate;

}

-(void)setDict:(NSDictionary *)dict
{
    
    
    self.labelDate.text = [dict[@"dates"]substringWithRange:NSMakeRange(5, 11)];
    
    self.labelMode.text = dict[@"summarys"];
    
    
    
    
    
    
   
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
