//
//  SelectCell.m
//  Administration
//
//  Created by zhang on 2017/7/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "SelectCell.h"

@implementation SelectCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubviews];
    }
    return self;
}
- (void) addSubviews {
    
    
    self.selectImage = [[UIImageView alloc]init];
    self.selectImage.translatesAutoresizingMaskIntoConstraints = NO;
    self.selectImage.image = [UIImage imageNamed:@"weixuanzhong"];
    [self.contentView addSubview:self.selectImage];
    [self.selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];
    
    _TXImage=[[UIImageView alloc]init];
    // 设置圆角半径
    _TXImage.translatesAutoresizingMaskIntoConstraints = NO;
    _TXImage.layer.masksToBounds = YES;
    _TXImage.layer.cornerRadius =25.0f;
    [self.contentView addSubview:_TXImage];
    [self.TXImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(28);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    _NameLabel=[[UILabel alloc]init];
    _NameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _NameLabel.font=[UIFont systemFontOfSize:17];
    [self.contentView addSubview:_NameLabel];
    [self.NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.TXImage.mas_right).offset(5);
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(14);
    }];
    
    _TelLabel=[[UILabel alloc]init];
    _TelLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _TelLabel.textColor=[UIColor lightGrayColor];
    [self.contentView addSubview:_TelLabel];
    [self.TelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.TXImage.mas_right).offset(5);
        make.top.mas_equalTo(self.NameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(14);
    }];

    _zhiLabel=[[UILabel alloc]init];
    _zhiLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _zhiLabel.textAlignment=NSTextAlignmentCenter;
    _zhiLabel.font=[UIFont systemFontOfSize:12];
    _zhiLabel.textColor=[UIColor lightGrayColor];
    [self addSubview:_zhiLabel];
    [self.zhiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
       // make.height.mas_equalTo(12);
        make.top.mas_equalTo(self.contentView.top).offset(30);
        
    }];
    
}

-(void)setModel:(NSDictionary *)model{
    self.NameLabel.text=model[@"name"];
    self.TelLabel.text=model[@"account"];
    //   self.TXImage.image=[[UIImage alloc] initWithContentsOfFile:model.icon];
    [self.TXImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model[@"image"]]] placeholderImage:[UIImage  imageNamed:@"tx23"]];
 //   self.TXImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:model[@"image"]]];
    NSString *zhiwei;
    if ([[NSString stringWithFormat:@"%@",model[@"newName"]] containsString:@","]) {
        for (int i=0;i<[model[@"newName"]length];i++) {
            NSString *string = [model[@"newName"] substringWithRange:NSMakeRange(i, 1)];
            if ([string isEqualToString:@","]) {
                zhiwei = [model[@"newName"]substringToIndex:i];
                self.zhiLabel.text=[NSString stringWithFormat:@"%@...",zhiwei];
                break;
            }
        }
    }else
    {
        zhiwei = model[@"newName"];
        self.zhiLabel.text=zhiwei;
    }
    
    
    if ([zhiwei containsString:@"总监"]||[zhiwei containsString:@"经理"]) {
        _zhiLabel.textColor=[UIColor whiteColor];
        _zhiLabel.layer.cornerRadius =3.0f;
        _zhiLabel.layer.masksToBounds = YES;
        self.zhiLabel.backgroundColor=GetColor(205,176,218,1);
    }
}
-(void)setLVmodel:(LVModel *)LVmodel{
    self.NameLabel.text=LVmodel.name;
    self.TelLabel.text=LVmodel.Call;
    //   self.TXImage.image=[[UIImage alloc] initWithContentsOfFile:model.icon];
    [self.TXImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,LVmodel.image]] placeholderImage:[UIImage  imageNamed:@"tx23"]];
    self.zhiLabel.text=[NSString stringWithFormat:@"%@ ",LVmodel.roleld];
    if ([LVmodel.roleld containsString:@"总监"]||[LVmodel.roleld containsString:@"经理"]) {
        _zhiLabel.textColor=[UIColor whiteColor];
        _zhiLabel.layer.cornerRadius =3.0f;
        _zhiLabel.layer.masksToBounds = YES;
        self.zhiLabel.backgroundColor=GetColor(205,176,218,1);
    }
}

@end
