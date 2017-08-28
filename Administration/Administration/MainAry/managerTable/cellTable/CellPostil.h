//
//  CellPostil.h
//  testView
//
//  Created by zhang on 2017/8/18.
//  Copyright © 2017年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
@interface CellPostil : UITableViewCell
@property (nonatomic,weak)UIImageView *imageViewH;
@property (nonatomic,weak)UIButton *buttonComp;
@property (nonatomic,weak)UILabel *labelTime;
@property (nonatomic,weak)UIPlaceHolderTextView *textView1;
@property (nonatomic,weak)UIPlaceHolderTextView *textView2;
@property (nonatomic,assign)NSInteger integer;
@property (nonatomic,weak)UIView *viewText;
@property (weak, nonatomic) NSLayoutConstraint *heightConstraint;
@end
