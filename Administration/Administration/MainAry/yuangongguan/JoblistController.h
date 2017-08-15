//
//  JoblistController.h
//  Administration
//
//  Created by zhang on 2017/5/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoblistController : UIViewController
@property (nonatomic,assign)int Num;

@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) UIImage *imageGroup;
@property (nonatomic,strong) NSString *stringGroup;
@property (nonatomic) BOOL isAddMenber;
@property (nonatomic,strong) NSString *groupID;
@property (nonatomic,strong) NSString *groupinformationId;
@property (nonatomic) BOOL isManager;
@end
