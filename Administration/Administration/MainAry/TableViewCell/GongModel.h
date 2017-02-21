//
//  GongModel.h
//  Administration
//
//  Created by zhang on 2017/2/21.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GongModel : NSObject
//标题
@property (nonatomic,retain)NSString *title;
//内容
@property (nonatomic,retain)NSString *content;
//截取时间
@property (nonatomic,retain)NSString *time;
//头像
@property (nonatomic,retain)NSString *url;
//id
@property (nonatomic,retain)NSString *ID;
//角色
@property (nonatomic,assign)NSInteger roleId;
@end
