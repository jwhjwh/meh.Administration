//
//  CellShop.h
//  Administration
//
//  Created by zhang on 2017/12/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellShop : UITableViewCell

@property (nonatomic,weak)UIImageView *imageViewSelect;
@property (nonatomic,weak)UIButton *buttonDetail;
@property (nonatomic,strong)NSDictionary *dict;

@end
