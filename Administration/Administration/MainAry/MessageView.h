//
//  MessageView.h
//  Administration
//
//  Created by 费腾 on 17/2/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageView : UIView
//创建两个属性(为外界提供接口)
@property(nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UIView *view;
@end
