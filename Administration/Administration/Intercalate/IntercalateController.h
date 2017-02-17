//
//  IntercalateController.h
//  Administration
//  设置
//  Created by 九尾狐 on 2017/2/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntercalateController : UIViewController



@property (nonatomic, assign) CGRect        tableViewFrame;

// 存放Cell上各行textLabel值
@property (nonatomic, copy)NSMutableArray * textLabel_MArray;

// 存放Cell上各行imageView上图片
@property (nonatomic, copy)NSMutableArray * images_MArray;

// 存放Cell上各行detailLabel值
@property (nonatomic, copy)NSMutableArray * subtitle_MArray;

@end
