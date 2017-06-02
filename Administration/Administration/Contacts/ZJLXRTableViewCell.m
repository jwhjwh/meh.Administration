//
//  ZJLXRTableViewCell.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ZJLXRTableViewCell.h"
CGFloat const ZJLXRTableViewCellPadding = 10;
@interface ZJLXRTableViewCell()
@property (nonatomic) NSLayoutConstraint *titleWithAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *titleWithoutAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *detailWithAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *detailWithoutAvatarLeftConstraint;
@end
@implementation ZJLXRTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
          _showAvatar = YES;
        [self addSubviews];
    }
    return self;
}
- (void) addSubviews {
    _TXImage=[[UIImageView alloc]init];
    // 设置圆角半径
      _TXImage.translatesAutoresizingMaskIntoConstraints = NO;
    _TXImage.layer.masksToBounds = YES;
    _TXImage.layer.cornerRadius =25.0f;
    [self.contentView addSubview:_TXImage];
  
    _zhiLabel=[[UILabel alloc]init];
    _zhiLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _zhiLabel.textAlignment=NSTextAlignmentRight;
    _zhiLabel.font=[UIFont systemFontOfSize:12];
    _zhiLabel.textColor=[UIColor lightGrayColor];
    [self addSubview:_zhiLabel];
    _NameLabel=[[UILabel alloc]init];
    _NameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _NameLabel.font=[UIFont systemFontOfSize:17];
    
    [self.contentView addSubview:_NameLabel];
   
    _TelLabel=[[UILabel alloc]init];
    _TelLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _TelLabel.textColor=[UIColor lightGrayColor];
   
    [self.contentView addSubview:_TelLabel];
//    [_TXImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.mas_left).offset(10);
//        make.top.mas_equalTo(self.mas_top).offset(10);
//        make.width.offset(54);
//        make.height.offset(54);
//    }];
  
//    [_NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_TXImage.mas_right).offset(10);
//        make.right.mas_equalTo(self.mas_right).offset(-10);
//        make.top.mas_equalTo(_TXImage.mas_top);
//        make.height.offset(30);
//    }];
//    [_zhiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.mas_right).offset(-10);
//        make.top.mas_equalTo(_NameLabel.mas_bottom);
//        make.width.offset(55);
//        make.height.offset(16);
//    }];
//    [_TelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.mas_right).offset(-10);
//        make.top.mas_equalTo(_NameLabel.mas_bottom);
//        make.left.mas_equalTo(_TXImage.mas_right).offset(10);
//        make.bottom.mas_equalTo(_TXImage.mas_bottom);
//    }];
    [self _setupAvatarViewConstraints];
    [self _setupTimeLabelConstraints];
    [self _setupTitleLabelConstraints];
    [self _setupDetailLabelConstraints];
}

#pragma mark - Setup Constraints

/*!
 @method
 @brief 设置avatarView的约束
 @discussion
 @return
 */
- (void)_setupAvatarViewConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.TXImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:ZJLXRTableViewCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.TXImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-ZJLXRTableViewCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.TXImage attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:ZJLXRTableViewCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.TXImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.TXImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.TXImage attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
}

/*!
 @method
 @brief 设置timeLabel的约束
 @discussion
 @return
 */
- (void)_setupTimeLabelConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.zhiLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.NameLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:ZJLXRTableViewCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.zhiLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-ZJLXRTableViewCellPadding]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.zhiLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0]];
}

/*!
 @method
 @brief 设置titleLabel的约束
 @discussion
 @return
 */
- (void)_setupTitleLabelConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.NameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:ZJLXRTableViewCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.NameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:-ZJLXRTableViewCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.NameLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.zhiLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-ZJLXRTableViewCellPadding]];
    
    self.titleWithAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.NameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.TXImage attribute:NSLayoutAttributeRight multiplier:1.0 constant:ZJLXRTableViewCellPadding];
    self.titleWithoutAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.NameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:ZJLXRTableViewCellPadding];
    [self addConstraint:self.titleWithAvatarLeftConstraint];
}

/*!
 @method
 @brief 设置detailLabel的约束
 @discussion
 @return
 */
- (void)_setupDetailLabelConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.TelLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.NameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.TelLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-ZJLXRTableViewCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.TelLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.zhiLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:-ZJLXRTableViewCellPadding]];
    
    self.detailWithAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.TelLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.TXImage attribute:NSLayoutAttributeRight multiplier:1.0 constant:ZJLXRTableViewCellPadding];
    self.detailWithoutAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.TelLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:ZJLXRTableViewCellPadding];
    [self addConstraint:self.detailWithAvatarLeftConstraint];
}

#pragma mark - setter

- (void)setShowAvatar:(BOOL)showAvatar
{
    if (_showAvatar != showAvatar) {
        _showAvatar = showAvatar;
        self.TXImage.hidden = !showAvatar;
        if (_showAvatar) {
            [self removeConstraint:self.titleWithoutAvatarLeftConstraint];
            [self removeConstraint:self.detailWithoutAvatarLeftConstraint];
            [self addConstraint:self.titleWithAvatarLeftConstraint];
            [self addConstraint:self.detailWithAvatarLeftConstraint];
        }
        else{
            [self removeConstraint:self.titleWithAvatarLeftConstraint];
            [self removeConstraint:self.detailWithAvatarLeftConstraint];
            [self addConstraint:self.titleWithoutAvatarLeftConstraint];
            [self addConstraint:self.detailWithoutAvatarLeftConstraint];
        }
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
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
