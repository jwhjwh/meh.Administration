//
//  Userpas.h
//  Administration
//
//  Created by zhang on 2017/5/20.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Userpas : NSObject
@property (nonatomic, copy) NSString *userid;
@property (nonatomic,assign)int  isopen;
@property (nonatomic,copy ) NSString *password;
+ (instancetype)modalWith:(NSString *)userid password:(NSString*)password isopen:(int)isopen;
@end
