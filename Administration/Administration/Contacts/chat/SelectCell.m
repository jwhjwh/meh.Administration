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
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(25);
    }];
    
    _TXImage=[[UIImageView alloc]init];
    // 设置圆角半径
    _TXImage.translatesAutoresizingMaskIntoConstraints = NO;
    _TXImage.layer.masksToBounds = YES;
    _TXImage.layer.cornerRadius =25.0f;
    [self.contentView addSubview:_TXImage];
    [self.TXImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectImage.mas_right).offset(3);
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.editing) {
        if (selected) {
            // 编辑状态去掉渲染
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.backgroundView.backgroundColor = [UIColor whiteColor];
            // 左边选择按钮去掉渲染背景
            UIView *view = [[UIView alloc] initWithFrame:self.multipleSelectionBackgroundView.bounds];
            view.backgroundColor = [UIColor whiteColor];
            self.selectedBackgroundView = view;
            
        }
    }
    
}

- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
    //不要破坏原本的系统动作
    [super setEditing:editting animated:animated];
//    //进入编辑状态
//    //背景视图生成，以准备设置选中和未选中的不同背景色
//    self.backgroundView = [[UIView alloc] init];
//    self.backgroundView.backgroundColor = [UIColor whiteColor];
//    self.selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(6.0f,CGRectGetHeight(self.bounds)/2 - 14.5f,29.0f,29.0f)];
//    self.selectImage.alpha = 1.0f;
//    [self addSubview:self.selectImage];
    //更新选中与否的界面显示
    [self setChecked:_isSelected];
    
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
    
    //需要记录到成员量中
    
}

-(void)setModel:(DirtmsnaModel *)model{
    self.NameLabel.text=model.name;
    self.TelLabel.text=model.account;
    //   self.TXImage.image=[[UIImage alloc] initWithContentsOfFile:model.icon];
    [self.TXImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model.icon]] placeholderImage:[UIImage  imageNamed:@"tx23"]];
    self.zhiLabel.text=[NSString stringWithFormat:@"%@ ",model.NewName];
    if ([model.NewName containsString:@"总监"]||[model.NewName containsString:@"经理"]) {
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
