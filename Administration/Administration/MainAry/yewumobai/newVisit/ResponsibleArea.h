//
//  ResponsibleArea.h
//  Administration
//
//  Created by 九尾狐 on 2017/12/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResponsibleArea : UIViewController
typedef void (^ReturnTextBlock)(NSString *prostr,NSString *citystr,NSString *countcity);
@property (nonatomic,strong) NSString *points;
@property (nonatomic,strong) NSString *DepartmentId;
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
@end
