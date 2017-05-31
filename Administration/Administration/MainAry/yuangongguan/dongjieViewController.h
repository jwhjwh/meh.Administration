//
//  dongjieViewController.h
//  Administration
//
//  Created by zhang on 2017/3/4.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^successBlock)();
typedef void (^suBlock)();
typedef void (^stateBlock)(NSString *str);
@interface dongjieViewController : UIViewController
@property (nonatomic,retain)NSString *state;//状态
@property (nonatomic,retain)NSString *uresID;
@property (nonatomic,copy)successBlock Block;
@property (nonatomic,copy)suBlock suBlock;
@property (nonatomic,copy)stateBlock stateBlock;
-(void)xiugaishiyonzhuangtaicodeStr:(NSString*)codeStr;
@end
