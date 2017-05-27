//
//  GuanglixqVController.h
//  Administration
//
//  Created by zhang on 2017/3/4.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^cellBlock)();
@interface GuanglixqVController : UIViewController
@property (nonatomic,retain)NSString *uresID;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,copy)cellBlock Cellblock;
@end
