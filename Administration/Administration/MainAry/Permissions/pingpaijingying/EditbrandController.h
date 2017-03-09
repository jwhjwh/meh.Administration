//
//  EditbrandController.h
//  Administration
//
//  Created by zhang on 2017/3/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BAELOCK)(UIImage *goodPicture,NSString*String);
@interface EditbrandController : UIViewController
@property (nonatomic,strong) NSString *tittle;
@property (nonatomic,strong) NSString *imageStr;
@property (nonatomic,retain) NSString *strId;
@property (nonatomic,copy)BAELOCK blcokStr;
@end
