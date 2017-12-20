//
//  AddCustomer.h
//  Administration
//
//  Created by 九尾狐 on 2017/12/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCustomer : UIViewController
@property (nonatomic, assign)BOOL issend;
@property (strong,nonatomic) NSString *shopid;//门店信息id
@property (strong,nonatomic) NSString *StoreClerkId;
@property (strong,nonatomic) NSString *strId;//职位id
@property (strong,nonatomic) NSString *shopname;
@end
