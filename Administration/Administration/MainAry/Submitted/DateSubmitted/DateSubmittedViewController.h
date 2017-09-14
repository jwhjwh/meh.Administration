//
//  DateSubmittedViewController.h
//  Administration
//
//  Created by 九尾狐 on 2017/3/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BAELOCKck)(NSString *content);

@interface DateSubmittedViewController : UIViewController
@property (nonatomic,copy)BAELOCKck datesubString;

@property (nonatomic,copy)NSString *contentid;

@end
