//
//  BranTableViewCell.m
//  Administration
//
//  Created by zhang on 2017/4/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "BranTableViewCell.h"

@implementation BranTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
- (void) addSubviews {
    _imageVie =[[UIImageView alloc]init];
    // 设置圆角半径
    [self addSubview:_imageVie];
    _titleLabel=[[UILabel alloc]init];
    [self addSubview:_titleLabel];
    
    [_imageVie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.width.offset(54);
        make.height.offset(54);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imageVie.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.offset(20);
    }];

    
}
-(void)setBranmodel:(Brandmodle *)branmodel{
       _str =[NSString stringWithFormat:@"(%@)",branmodel.departmentName];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",branmodel.finsk,_str]];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,branmodel.finsk.length)]; //设置字体颜色
     [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(0,branmodel.finsk.length)]; //设置字体字号和字体类别
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(branmodel.finsk.length,_str.length)]; //设置字体颜色
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(branmodel.finsk.length,_str.length)]; //设置字体字号和字体类别
     _titleLabel.attributedText =AttributedStr;
      [_imageVie sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,branmodel.brandLogo]]placeholderImage:[UIImage imageNamed:@"banben100"]];

}
-(void)setModel:(branModel *)model{
         [_imageVie sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model.brandLogo]]placeholderImage:[UIImage imageNamed:@"banben100"]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
