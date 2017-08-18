//
//  DirectorController.h
//  Administration
//
//  Created by zhang on 2017/5/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^DIREBLOCK)(NSMutableArray *arr);
@interface DirectorController : UIViewController
@property (nonatomic,strong)DIREBLOCK blockArray;
@property (nonatomic,strong)NSString *str;
@property (nonatomic,assign)int Num;
@property (nonatomic,strong)NSString *BarandID;
@property (nonatomic,strong)NSString *Numstr;

@property (nonatomic,strong)NSString *GroupNumber;
@end
