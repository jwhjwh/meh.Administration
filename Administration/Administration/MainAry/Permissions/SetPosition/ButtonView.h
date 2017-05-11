//
//  ButtonView.h
//  Administration
//
//  Created by 九尾狐 on 2017/4/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonView : UIView

@property (strong,nonatomic) UIButton* ZWbutton;

@property (strong,nonatomic) UIImageView* ZWimage;


- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)height;

@end
