//
//  GongTableViewCell.h
//  Administration
//
//  Created by 费腾 on 17/2/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GongTableViewCell : UITableViewCell
///头像
@property (nonatomic,retain)UIImageView *logoImage;
///标题
@property (nonatomic,retain)UILabel *titleLabel;
///时间
@property (nonatomic,retain)UILabel *timeLabel;
///发送人
@property (nonatomic,retain)UILabel *whoLabel;
///内容
@property (nonatomic,retain)UILabel *contLabel;
@end
