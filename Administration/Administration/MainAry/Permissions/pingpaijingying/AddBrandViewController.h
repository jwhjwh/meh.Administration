//
//  AddBrandViewController.h
//  Administration
//
//  Created by zhang on 2017/3/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BAELOCKStr)(UIImage *goodPicture,NSString*String,NSString*Strid);
@interface AddBrandViewController : UIViewController
@property (nonatomic,copy)BAELOCKStr blcokStr;
@end
