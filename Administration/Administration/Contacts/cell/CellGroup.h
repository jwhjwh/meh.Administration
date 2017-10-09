//
//  CellGroup.h
//  Administration
//
//  Created by zhang on 2017/8/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellGroup : UITableViewCell
@property (strong, nonatomic)  UIButton *locationButton;
@property (strong, nonatomic)  UILabel *labelDivision;
@property (strong, nonatomic)  UIImageView *TXImage;//头像
@property (strong, nonatomic)  UILabel *nameLabel;//姓名
@property (strong, nonatomic)  UILabel *TelLabel;//电话
@property (strong, nonatomic)  UILabel *zhiLabel;//职位
@end
