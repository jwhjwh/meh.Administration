//
//  EmistController.h
//  Administration
//
//  Created by zhang on 2017/5/9.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^EBLOCK)(NSMutableArray *arr);
@interface EmistController : UIViewController
@property (nonatomic,strong)EBLOCK blockArr;
@property (nonatomic,strong)NSString *str;
@property (nonatomic,assign)int num;
@property (nonatomic,strong)NSString *BarandID;

@property (nonatomic,strong)NSString *Numstr;
@property (nonatomic,strong)NSString *GroupNumber;
@end
