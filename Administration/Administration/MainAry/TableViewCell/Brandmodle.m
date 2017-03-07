//
//  Brandmodle.m
//  Administration
//
//  Created by zhang on 2017/3/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "Brandmodle.h"

@implementation Brandmodle
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID= value;
    }
}

-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
    
}
@end
