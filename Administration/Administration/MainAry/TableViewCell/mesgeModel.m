
//
//  mesgeModel.m
//  Administration
//
//  Created by zhang on 2017/2/20.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "mesgeModel.h"

@implementation mesgeModel
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
