//
//  RecordTableViewCell.h
//  Administration
//
//  Created by 九尾狐 on 2017/9/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell
@property(nonatomic,retain)UILabel *dianmingLabel;//店名
@property(nonatomic,retain)UILabel *shijianLabel;//时间
@property(nonatomic,retain)UILabel *RectordLabel;//内容 --地区--地址---日期

@property(nonatomic,retain)UILabel *StateLabel;//阶段
@property(nonatomic,retain)UIImageView *StateImage;//阶段

@property(nonatomic,retain)UILabel *UserIdLabel;//同事
@property(nonatomic,retain)UIImageView *UserIdImage;//同事

@property(nonatomic,retain)UILabel *DepartmentIdLabel;//部门
@property(nonatomic,retain)UIImageView *DepartmentIdImage;//部门
@end
