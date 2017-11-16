//
//  ActiviTableViewCell.h
//  Administration
//
//  Created by 九尾狐 on 2017/11/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActiviTableViewCell : UITableViewCell
@property (nonatomic,weak)UILabel *labelMode;
@property (nonatomic,weak)UILabel *labelDate;

@property (nonatomic,weak)UIImageView *imageView1;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic)BOOL isSelect;
@end
