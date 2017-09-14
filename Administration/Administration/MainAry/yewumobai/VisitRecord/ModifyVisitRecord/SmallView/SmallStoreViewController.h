//
//  SmallStoreViewController.h
//  Administration
//
//  Created by 九尾狐 on 2017/9/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BAELOCK)(NSString *type,NSString *year,NSString *perpon,NSString *beds);

@interface SmallStoreViewController : UIViewController
@property (nonatomic,copy)BAELOCK blcokString;

@property (nonatomic) BOOL modifi;

@property (nonatomic,strong)NSArray *dateAry;

@end
