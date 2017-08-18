//
//  ModifyController.h
//  Administration
//
//  Created by zhang on 2017/5/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BLOCKBarndname)(NSString *str);
@interface ModifyController : UIViewController
@property (nonatomic,strong)NSString *BarandID;
@property (nonatomic,strong)BLOCKBarndname blockStr;

@property (nonatomic,strong)NSString *GroupNumber;
@end
