//
//  CellPermission.h
//  Administration
//
//  Created by zhang on 2017/10/31.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellPermission : UITableViewCell
@property (nonatomic,weak)UIButton *buttonSelect;
@property (nonatomic,strong)NSArray *arrayData;
@property (nonatomic,strong)UILabel *labelMan;
@property (nonatomic,strong)UILabel *labelPostion;
@end
