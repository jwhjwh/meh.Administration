//
//  AddotherController.h
//  Administration
//
//  Created by zhang on 2017/5/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BLOCKStr)();
@interface AddotherController : UIViewController
@property (nonatomic,strong)BLOCKStr Str;
@property (nonatomic,strong)NSString *departmentNum;
@property (nonatomic,strong)NSString *depatrtname;
@end
