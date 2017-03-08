//
//  AddBrandViewController.h
//  Administration
//
//  Created by zhang on 2017/3/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BAELOCK)(UIImage *goodPicture,NSString*String);
@interface AddBrandViewController : UIViewController
@property (nonatomic,copy)BAELOCK blcokStr;
@end
