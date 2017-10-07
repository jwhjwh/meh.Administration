//
//  GroupCell.h
//  Administration
//
//  Created by zhang on 2017/7/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupCell : UITableViewCell
@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *noReadLabel;
@property (nonatomic,strong)NSDictionary *model;
@end
