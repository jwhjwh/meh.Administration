//
//  CellCity.h
//  Administration
//
//  Created by zhang on 2017/11/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellCity : UITableViewCell

@property (nonatomic,weak)UIImageView *imageViewSelect;
@property (nonatomic,weak)UILabel *labelName;
@property (nonatomic)BOOL isSelect;
@end
