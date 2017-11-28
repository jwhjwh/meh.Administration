//
//  DPYJViewController.h
//  Administration
//
//  Created by 九尾狐 on 2017/11/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BAELOCKck)(NSString *content,int num);
@interface DPYJViewController : UIViewController
@property(nonatomic,strong)NSString *number;
@property (nonatomic,copy)BAELOCKck blcokStr;
@property (nonatomic) BOOL modifi;
@property (nonatomic,strong)NSString *dateStr;
@end
