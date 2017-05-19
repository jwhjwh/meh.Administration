//
//  EditotherController.h
//  Administration
//
//  Created by zhang on 2017/5/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BLOCKOtherStr)();
typedef void  (^OtherStr)(NSString *str);
@interface EditotherController : UIViewController
@property (nonatomic,strong)NSString *nameStr;
@property (nonatomic,strong)NSString *BarandID;
@property (nonatomic,strong)BLOCKOtherStr Str;
@property (nonatomic,strong)OtherStr String;
@property (nonatomic,strong)NSString *departNum;
@end
