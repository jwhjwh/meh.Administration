//
//  MesgeTableViewCell.h
//  Administration
//
//  Created by 费腾 on 17/2/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mesgeModel.h"
@interface MesgeTableViewCell : UITableViewCell
//标题图
@property (nonatomic,retain)UIImageView *logeImage;
//红点
@property (nonatomic,retain)UILabel *hongLabel;
///标题
@property (nonatomic,retain)UILabel *titleLabel;
///时间
@property (nonatomic,retain)UILabel *timeLabel;
///内容
@property (nonatomic,retain)UILabel *contLabel;
@property (nonatomic,retain)mesgeModel *model;
@end
