//
//  ChoosePostionViewController.h
//  Administration
//
//  Created by zhang on 2017/7/5.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePostionViewController : BaseViewController
@property (nonatomic,strong)NSString *str;
@property (nonatomic,assign)int Num;
@property (nonatomic,assign)int dataShow;
@property (nonatomic,strong)NSString *DepartmentID;
@property (nonatomic,strong)NSString *Numstr;
@property (nonatomic,strong) NSString *stringGroup;
@property (nonatomic,strong) UIImage *imageGroup;
@property (nonatomic)BOOL isHaveGroup;
@property (nonatomic)BOOL isCreateGroup;
@property (nonatomic,strong)NSString *groupID;
@property (nonatomic,strong) NSString *groupinformationId;
@end
