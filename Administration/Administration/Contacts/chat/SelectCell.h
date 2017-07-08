//
//  SelectCell.h
//  Administration
//
//  Created by zhang on 2017/7/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirtmsnaModel.h"
#import "LVModel.h"
@interface SelectCell : UITableViewCell
@property (nonatomic) BOOL isSelected;
@property (strong,nonatomic) UIImageView *selectImage;
@property (strong, nonatomic)  UIImageView *TXImage;//头像
@property (strong, nonatomic)  UILabel *NameLabel;//姓名
@property (strong, nonatomic)  UILabel *TelLabel;//电话
@property (strong, nonatomic)  UILabel *zhiLabel;//职位
@property (nonatomic,retain)DirtmsnaModel *model;
@property (nonatomic,retain)LVModel *LVmodel;
@property(nonatomic, assign) BOOL   checked;  
- (void)setChecked:(BOOL)checked;
@end
