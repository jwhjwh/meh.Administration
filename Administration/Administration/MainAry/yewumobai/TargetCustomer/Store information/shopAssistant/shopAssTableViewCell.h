//
//  shopAssTableViewCell.h
//  Administration
//
//  Created by 九尾狐 on 2017/12/4.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shopAssModel.h"
@interface shopAssTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *dayLabel;
@property (nonatomic,strong)UILabel *phoneleLabel;
@property (nonatomic,strong)shopAssModel *modle;
@end
