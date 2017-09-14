//
//  CellMyTable.h
//  Administration
//
//  Created by zhang on 2017/9/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellMyTable : UITableViewCell
@property (nonatomic,weak)UIImageView *imageViewHead;
@property (nonatomic,weak)UILabel *labelName;
@property (nonatomic,weak)UILabel *labelPosition;
@property (nonatomic,weak)UILabel *labelTime;
@property (nonatomic,weak)UILabel *labelUpTime;
@property (nonatomic,weak)UILabel *labelDescribe;
@property (nonatomic,strong)NSDictionary *dict;
@end
