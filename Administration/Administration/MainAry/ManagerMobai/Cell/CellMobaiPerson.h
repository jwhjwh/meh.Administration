//
//  CellMobaiPerson.h
//  Administration
//
//  Created by zhang on 2017/11/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellMobaiPerson : UITableViewCell

@property (nonatomic,weak)UIImageView *imageViewHeader;
@property (nonatomic,weak)UILabel *labelName;
@property (nonatomic,weak)UILabel *labelAccount;
@property (nonatomic,weak)UILabel *labelPosition;
@property (nonatomic,weak)UILabel *labelDepartment;
@property (nonatomic,strong)NSDictionary *dict;
@end
