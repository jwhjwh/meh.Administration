//
//  EditbrandController.h
//  Administration
//
//  Created by zhang on 2017/5/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BLOCKBarndStr)();
@interface EditbrandController : UIViewController
@property (nonatomic,strong)NSString *nameStr;
@property (nonatomic,strong)NSString *BarandID;
@property (nonatomic,strong)BLOCKBarndStr Str;
@end
