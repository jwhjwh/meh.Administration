//
//  DepmentController.h
//  Administration
//
//  Created by zhang on 2017/5/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepmentController : UIViewController
@property (nonatomic,strong)NSString *str;
@property (nonatomic,assign)int Num;
@property (nonatomic,assign)int dataShow;
@property (nonatomic,strong)NSString *DepartmentID;
@property (nonatomic,strong)NSString *Numstr;
@property (nonatomic,strong)EaseUserModel *model;
@property (nonatomic)BOOL isManager;
@end
