//
//  GuideTableViewCell.h
//  Administration
//
//  Created by zhang on 2017/4/27.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "branModel.h"
@interface GuideTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *image;
@property (nonatomic,strong)branModel *model;
@end
