//
//  ZJLXRTableViewCell.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ZJLXRTableViewCell.h"

@implementation ZJLXRTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
- (void) addSubviews {
    _TXImage=[[UIImageView alloc]init];
    // 设置圆角半径
    _TXImage.layer.masksToBounds = YES;
    _TXImage.layer.cornerRadius =27.0f;
    [self addSubview:_TXImage];
    _zhiLabel=[[UILabel alloc]init];
    _zhiLabel.textAlignment=NSTextAlignmentRight;
    _zhiLabel.font=[UIFont systemFontOfSize:12];
    _zhiLabel.textColor=[UIColor lightGrayColor];
    [self addSubview:_zhiLabel];
   
    _NameLabel=[[UILabel alloc]init];
    _NameLabel.font=[UIFont systemFontOfSize:17];
    
    [self addSubview:_NameLabel];
    
    _TelLabel=[[UILabel alloc]init];
    _TelLabel.textColor=[UIColor lightGrayColor];
   
    [self addSubview:_TelLabel];
    [_TXImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.width.offset(54);
        make.height.offset(54);
    }];
  
    [_NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_TXImage.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(_TXImage.mas_top);
        make.height.offset(30);
    }];
    [_zhiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(_NameLabel.mas_bottom);
        make.width.offset(130);
        make.height.offset(16);
    }];
    [_TelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(_NameLabel.mas_bottom);
        make.left.mas_equalTo(_TXImage.mas_right).offset(10);
        make.bottom.mas_equalTo(_TXImage.mas_bottom);
    }];

}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setModel:(DirtmsnaModel *)model{
   self.NameLabel.text=model.name;
   self.TelLabel.text=model.account;
//   self.TXImage.image=[[UIImage alloc] initWithContentsOfFile:model.icon];
    [self.TXImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model.icon]] placeholderImage:[UIImage  imageNamed:@"tx23"]];
   self.zhiLabel.text=model.NewName;
}
@end
