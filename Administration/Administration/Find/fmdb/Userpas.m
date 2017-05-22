//
//  Userpas.m
//  Administration
//
//  Created by zhang on 2017/5/20.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "Userpas.h"

@implementation Userpas
+ (instancetype)modalWith:(NSString *)userid password:(NSString*)password isopen:(NSString*)isopen{
    Userpas *model = [[self alloc] init];
    model.userid = userid;
    model.password = password;
    model.isopen = isopen;
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
    
}

@end
