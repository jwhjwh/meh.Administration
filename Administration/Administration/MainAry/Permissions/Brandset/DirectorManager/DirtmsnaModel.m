//
//  DirtmsnaModel.m
//  Administration
//
//  Created by zhang on 2017/5/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "DirtmsnaModel.h"

@implementation DirtmsnaModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"newName"]) {
        self.NewName= value;
    }
}

-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
    
}

@end
