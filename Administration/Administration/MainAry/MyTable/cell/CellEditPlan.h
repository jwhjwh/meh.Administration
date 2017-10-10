//
//  CellEditPlan.h
//  Administration
//
//  Created by zhang on 2017/9/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
@interface CellEditPlan : UITableViewCell
@property (nonatomic,weak)UILabel *LabelTitle;
@property (nonatomic,weak)UIPlaceHolderTextView *textView;
@property (nonatomic,weak)UIButton *buttonPostil;
@property (nonatomic,weak)UILabel *labelNumber;
@end
