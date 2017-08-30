//
//  AddbranController.h
//  Administration
//
//  Created by zhang on 2017/4/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void  (^OtherStr)(NSString *str);
typedef void  (^BLOCKBarndStr)();
@interface AddbranController : UIViewController
@property (nonatomic,strong)OtherStr String;
@property (nonatomic,strong)BLOCKBarndStr Str;

@end




