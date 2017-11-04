//
//  GongTableViewCell.m
//  Administration
//
//  Created by 费腾 on 17/2/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "GongTableViewCell.h"

@implementation GongTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}
- (void) addSubviews {
    _logoImage=[[UIImageView alloc]init];
    _logoImage.layer.masksToBounds = YES;
    // 设置圆角半径
    _logoImage.layer.cornerRadius =24.0f;
    [self addSubview:_logoImage];
    _timeLabel=[[UILabel alloc]init];
    
    _timeLabel.textAlignment=NSTextAlignmentRight;
    _timeLabel.font=[UIFont systemFontOfSize:14];
    _timeLabel.textColor=[UIColor lightGrayColor];
    [self addSubview:_timeLabel];
    
    _titleLabel=[[UILabel alloc]init];
    
    [self addSubview:_titleLabel];
    _whoLabel=[[UILabel alloc]init];
  
    _whoLabel.font=[UIFont systemFontOfSize:14];
    _whoLabel.textColor=[UIColor lightGrayColor];
    [self addSubview:_whoLabel];
    _contLabel=[[UILabel alloc]init];
    _contLabel.font=[UIFont systemFontOfSize:16];
    _contLabel.numberOfLines=0;
    [self addSubview:_contLabel];
    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.width.offset(48);
        make.height.offset(48);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_logoImage.mas_right).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(_logoImage.mas_top);
        make.height.offset(20);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.width.offset(130);
        make.height.offset(16);
    }];
    [_whoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(_timeLabel.mas_bottom);
        make.left.mas_equalTo(_logoImage.mas_right).offset(5);
        make.height.offset(16);
    }];
    
    [_contLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(_whoLabel.mas_bottom).offset(2);
        make.left.mas_equalTo(_logoImage.mas_right).offset(5);
        make.height.offset(60);
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setGongModel:(GongModel *)gongModel{
    _titleLabel.text=gongModel.title;
    NSString *timeStr = [gongModel.time substringWithRange:NSMakeRange(5,11)];
    _timeLabel.text=timeStr;
    _contLabel.text=gongModel.content;
      [_logoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,gongModel.url]] placeholderImage:[UIImage  imageNamed:@"tx23"]];
    if (gongModel.roleId ==1) {
          _whoLabel.text=@"来自老板";
    } else if (gongModel.roleId == 7){
         _whoLabel.text=@"来自行政";
    }
    
}

-(void)setDict:(NSDictionary *)dict
{
    _titleLabel.text=dict[@"title"];
    NSString *timeStr = [dict[@"time"] substringWithRange:NSMakeRange(5,11)];
    _timeLabel.text=timeStr;
    _contLabel.text=dict[@"content"];
    
    if (dict[@"url"]) {
       [_logoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,dict[@"url"]]] placeholderImage:[UIImage  imageNamed:@"tx23"]]; 
    }
    
    
        _whoLabel.text=[NSString stringWithFormat:@"来自%@",dict[@"newName"]];
    
}

@end
