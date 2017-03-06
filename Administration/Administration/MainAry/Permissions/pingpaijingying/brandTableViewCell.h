//
//  brandTableViewCell.h
//  Administration
//
//  Created by zhang on 2017/3/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brandmodle.h"
@interface brandTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *image;
@property (nonatomic,strong)Brandmodle *modle;
@end
