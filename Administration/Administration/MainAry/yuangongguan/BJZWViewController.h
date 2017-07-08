//
//  BJZWViewController.h
//  Administration
//
//  Created by 九尾狐 on 2017/6/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BJZWViewController : UIViewController

@property(strong,nonatomic) NSMutableArray*ZW;//职位
@property (strong,nonatomic) NSArray*Numm;//职位id
@property(strong,nonatomic) NSArray*ZWLB;//职位类别
@property (strong,nonatomic) NSArray*lbNum;//职位类别id
@property(strong,nonatomic) NSMutableArray*gxbmAry;//部门数组
@property(strong,nonatomic) NSMutableArray*gxbmidAry;//部门id数组

@property(strong,nonatomic)NSMutableArray *codeAry;


@end
