//
//  BranTableViewCell.h
//  Administration
//
//  Created by zhang on 2017/4/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "branModel.h"
#import "Brandmodle.h"
@interface BranTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *imageVie;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,strong)branModel *model;
@property (nonatomic,strong)Brandmodle *branmodel;
@end
