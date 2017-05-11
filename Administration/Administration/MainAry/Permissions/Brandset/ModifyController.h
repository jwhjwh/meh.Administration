//
//  ModifyController.h
//  Administration
//
//  Created by zhang on 2017/4/21.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BLOCK)(NSMutableArray *array);
@interface ModifyController : UIViewController
@property (nonatomic,strong)BLOCK blockArr;
@property (nonatomic,strong)NSString *departmentID;

@end
