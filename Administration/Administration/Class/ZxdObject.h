//
//  ZxdObject.h
//  Administration
//
//  Created by zhang on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZxdObject : NSObject

+(void)rootController;
//将文字添加到图片上

+ (UIImage*)text:(NSString*)text city:(NSString*)city addToView:(UIImage*)image;

@end
