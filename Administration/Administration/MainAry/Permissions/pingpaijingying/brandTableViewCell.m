//
//  brandTableViewCell.m
//  Administration
//
//  Created by zhang on 2017/3/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "brandTableViewCell.h"

@implementation brandTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews{
    _image =[[UIImageView alloc]init];
    // 设置圆角半径
    [self addSubview:_image];
    _titleLabel=[[UILabel alloc]init];
    _titleLabel.font=[UIFont systemFontOfSize:20];
    
    [self addSubview:_titleLabel];
    
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.width.offset(54);
        make.height.offset(54);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_image.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.offset(20);
    }];
}
-(void)setModle:(Brandmodle *)modle{
  _titleLabel.text=modle.finsk;
    NSLog(@"%@",modle.brandLogo);
    if ([modle.brandLogo hasPrefix:@"images"]) {
        [_image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,modle.brandLogo]] placeholderImage:[UIImage  imageNamed:@"tx23"]];
    }else{
        if (!(modle.brandLogo==nil)) {
            NSData *_decodedImageData = [[NSData alloc]initWithBase64Encoding:modle.brandLogo];
            _image.image = [UIImage imageWithData:_decodedImageData];
        }

        
    }
  
}
- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
