//
//  CellPerson.h
//  Administration
//
//  Created by zhang on 2017/8/31.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellPerson : UITableViewCell
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,weak)UIImageView *imageViewHead;
@property (nonatomic,weak)UILabel *labelName;
@property (nonatomic,weak)UILabel *labelAccount;
@end
