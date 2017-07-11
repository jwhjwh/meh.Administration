//
//  GroupModel.m
//  Administration
//
//  Created by zhang on 2017/7/10.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"joinType"]) {
        self.joinType= value;
    }
}

-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
    
}

@end
