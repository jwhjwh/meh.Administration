//
//  GroupMenberCell.h
//  Administration
//
//  Created by zhang on 2017/7/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMenberCell : UITableViewCell
@property (nonatomic) BOOL isSelected;
@property (strong, nonatomic) UIImageView *selectImage;
@property (strong, nonatomic)  UIImageView *TXImage;//头像
@property (strong, nonatomic)  UILabel *nameLabel;//姓名
@property (strong, nonatomic)  UILabel *TelLabel;//电话
@property (strong, nonatomic)  UILabel *zhiLabel;//职位
@property (nonatomic) BOOL isMe;
@end
