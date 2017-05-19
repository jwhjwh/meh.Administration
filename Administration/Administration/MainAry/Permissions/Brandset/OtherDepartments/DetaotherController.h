//
//  DetaotherController.h
//  Administration
//
//  Created by zhang on 2017/5/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BLOCKBarndStr)();
@interface DetaotherController : UIViewController
@property (nonatomic,strong)NSString *nameStr;
@property (nonatomic,strong)NSString *BarandID;
@property (nonatomic,strong)BLOCKBarndStr blockStr;

@property (nonatomic,strong)NSString *departmentNum;
@end
