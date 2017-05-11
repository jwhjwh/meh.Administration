//
//  EMlistTableViewCell.h
//  Administration
//
//  Created by zhang on 2017/5/9.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirtmsnaModel.h"
@interface EMlistTableViewCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *TXImage;//头像
@property (strong, nonatomic)  UILabel *NameLabel;//姓名
@property (strong, nonatomic)  UILabel *TelLabel;//电话
@property (strong, nonatomic)  UILabel *zhiLabel;//职位
@property (nonatomic,retain)DirtmsnaModel *model;
@end
