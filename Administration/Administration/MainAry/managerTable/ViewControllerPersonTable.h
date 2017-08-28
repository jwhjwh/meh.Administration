//
//  ViewControllerPersonTable.h
//  Administration
//
//  Created by zhang on 2017/8/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerPersonTable : BaseViewController
@property (nonatomic,strong)NSString *stringTitle;
@property (nonatomic,strong)NSString *roleId;
@property (nonatomic,strong)NSString *departmentId;
@property (nonatomic,strong)NSString *num;
//被查看人的userid和角色ID
@property (nonatomic,strong)NSString *userid;
@property (nonatomic,strong)NSString *rid;
@property (nonatomic,strong)NSString *positionName;//职位
@end
