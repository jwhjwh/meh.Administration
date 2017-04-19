//
//  multiController.h
//  Administration
//
//  Created by zhang on 2017/4/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BLOCK)(NSMutableArray *array);
@interface multiController : UIViewController
@property (nonatomic,strong)BLOCK blockArr;
@end
