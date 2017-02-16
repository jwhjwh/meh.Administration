//
//  ZJLXRTableViewCell.h
//  Administration
//
//  Created by 九尾狐 on 2017/2/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJLXRTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *TXImage;//头像
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;//姓名
@property (weak, nonatomic) IBOutlet UILabel *TelLabel;//电话
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;//时间
@end
