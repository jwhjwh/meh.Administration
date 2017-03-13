//
//  InputboxController.h
//  Administration
//
//  Created by zhang on 2017/3/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BAELOCK)(NSString *content);
@interface InputboxController : UIViewController
@property(nonatomic,strong)NSString *number;
@property (nonatomic,copy)BAELOCK blcokStr;
@end
