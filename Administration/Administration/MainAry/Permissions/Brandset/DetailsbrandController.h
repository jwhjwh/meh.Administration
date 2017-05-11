//
//  DetailsbrandController.h
//  Administration
//
//  Created by zhang on 2017/4/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^BLOCKBarndStr)();
@interface DetailsbrandController : UIViewController
@property (nonatomic,strong)NSArray *branarr;
@property (nonatomic,strong)NSString *nameStr;
@property (nonatomic,strong)NSString *BarandID;
@property (nonatomic,strong)BLOCKBarndStr blockStr;
@end
