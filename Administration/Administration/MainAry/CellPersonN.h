//
//  CellPerson.h
//  Administration
//
//  Created by zhang on 2017/10/27.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellPersonN : UITableViewCell
@property (nonatomic,weak)UIImageView *imageViewHeader;
@property (nonatomic,weak)UILabel *labelName;
@property (nonatomic,weak)UILabel *labelAcccount;
@property (nonatomic,weak)UILabel *labelTime;
@property (nonatomic,weak)UILabel *labelPosition;
@property (nonatomic,strong)NSDictionary *dict;
@end
