//
//  InputboxController.h
//  Administration
//
//  Created by zhang on 2017/3/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BAELOCKck)(NSString *content,int num);
@interface InputboxController : UIViewController
@property(nonatomic,strong)NSString *number;
@property (nonatomic,copy)BAELOCKck blcokStr;
@end
