//
//  branModel.h
//  Administration
//
//  Created by zhang on 2017/4/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface branModel : NSObject

@property (nonatomic,strong)NSString *brandLogo;
@property (nonatomic,strong)NSString * finsk;
@property (nonatomic,strong)NSString *ID;

//部门设置
@property (nonatomic,strong)NSString *Name;
@property (nonatomic,strong)NSString *Num;
//美导
@property (nonatomic,strong)NSString  *levelName;
@property (nonatomic,strong)NSString  *num;
@end
