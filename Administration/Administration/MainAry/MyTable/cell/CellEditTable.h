//
//  CellEditTable.h
//  Administration
//
//  Created by zhang on 2017/9/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
@interface CellEditTable : UITableViewCell
@property (nonatomic,weak)UILabel *labelTitle;
@property (nonatomic,weak)UIPlaceHolderTextView *textView;
@end
