//
//  DongImage.h
//  Administration
//
//  Created by zhang on 2017/2/28.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>  
@interface DongImage : NSObject
+(void)showImage:(UIImageView *)avatarImageView;
+(void)hideImage:(UITapGestureRecognizer*)tap;
@end
