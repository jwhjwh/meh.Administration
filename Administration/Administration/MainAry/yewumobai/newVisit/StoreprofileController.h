//
//  StoreprofileController.h
//  Administration
//
//  Created by zhang on 2017/3/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BAELOCK)(NSString *type,NSString *year,NSString *perpon,NSString *beds);
@interface StoreprofileController : UIViewController
@property (nonatomic,copy)BAELOCK blcokString;
@property(nonatomic,strong)NSMutableArray *strary;
@end
