//
//  mesgeModel.h
//  Administration
//
//  Created by zhang on 2017/2/20.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mesgeModel : NSObject
//判断
@property (nonatomic,retain)NSString *flag;
//判断显示年月周总结
@property (nonatomic,retain)NSString *tableName;
//截取时间
@property (nonatomic,retain)NSString *dates;
@end
