//
//  AddbranController.h
//  Administration
//
//  Created by zhang on 2017/4/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BLOCKStr)();
@interface AddbranController : UIViewController
@property (nonatomic,strong)BLOCKStr blockStr;
@end
