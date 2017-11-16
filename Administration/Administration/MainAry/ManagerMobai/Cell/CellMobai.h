//
//  CellMobai.h
//  Administration
//
//  Created by zhang on 2017/11/10.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellMobai : UITableViewCell

@property (nonatomic,weak)UILabel *labelShop;
@property (nonatomic,weak)UILabel *labelArea;
@property (nonatomic,weak)UILabel *labelAdress;
@property (nonatomic,weak)UILabel *labelDate;
@property (nonatomic,weak)UILabel *labelTime;

@property (nonatomic,strong)NSDictionary *dict;

@end
