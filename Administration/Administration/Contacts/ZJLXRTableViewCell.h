//
//  ZJLXRTableViewCell.h
//  Administration
//
//  Created by 九尾狐 on 2017/2/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirtmsnaModel.h"
#import "LVModel.h"
@interface ZJLXRTableViewCell : UITableViewCell
/** @brief 是否显示头像，默认为YES */
@property (nonatomic) BOOL showAvatar;
@property (strong, nonatomic)  UIImageView *TXImage;//头像
@property (strong, nonatomic)  UILabel *NameLabel;//姓名
@property (strong, nonatomic)  UILabel *TelLabel;//电话
@property (strong, nonatomic)  UILabel *zhiLabel;//职位
@property (nonatomic,retain)DirtmsnaModel *model;
@property (nonatomic,retain)LVModel *LVmodel;
@end
