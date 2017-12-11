//
//  TargetTableViewController.h
//  Administration
//
//  Created by 九尾狐 on 2017/10/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargetTableViewController : UIViewController
@property (nonatomic,strong) NSString *OldTargetVisitId;
@property (strong,nonatomic) NSString *strId;
@property (nonatomic, assign) BOOL isofyou;
@property (nonatomic, assign) BOOL cellend;
@property(strong,nonatomic)NSString *shopid;//店铺id

@property (strong,nonatomic) NSString *oneStore;
@end
