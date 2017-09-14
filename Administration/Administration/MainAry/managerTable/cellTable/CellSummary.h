//
//  CellSummary.h
//  Administration
//
//  Created by zhang on 2017/9/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellSummary : UITableViewCell
@property (nonatomic,weak)UILabel *labelFilledTime;
@property (nonatomic,weak)UILabel *labelPostion;
@property (nonatomic,weak)UILabel *labelUpTime;
@property (nonatomic,weak)UILabel *labelState;
@property (nonatomic,strong)NSDictionary *dictInfo;
@end
