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
@end
