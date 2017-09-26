//
//  CellDrafts.h
//  Administration
//
//  Created by zhang on 2017/9/26.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellDrafts : UITableViewCell
@property (nonatomic,weak)UILabel *labelName;
@property (nonatomic,weak)UILabel *labelTime;
@property (nonatomic,weak)UILabel *labelUpTime;
@property (nonatomic,strong)NSDictionary *dict;
@end
