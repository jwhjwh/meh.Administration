//
//  CellMineTable.h
//  Administration
//
//  Created by zhang on 2017/9/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellMineTable : UITableViewCell
@property (nonatomic,weak)UILabel *labelTime;
@property (nonatomic,weak)UILabel *labelDescribe;
@property (nonatomic,weak)UILabel *labelUpTime;
@property (nonatomic,strong)NSDictionary *dict;
@end
