//
//  CellChargeManager.h
//  Administration
//
//  Created by zhang on 2017/12/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellChargeManager : UITableViewCell
@property (nonatomic,weak)UIButton *buttonDel;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,weak)UIImageView *imageViewSelect;
@property (nonatomic,weak)UILabel *labelLine;
@end
