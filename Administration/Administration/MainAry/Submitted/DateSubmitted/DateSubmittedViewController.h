//
//  DateSubmittedViewController.h
//  Administration
//
//  Created by 九尾狐 on 2017/3/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmittedModel.h"
@interface DateSubmittedViewController : UIViewController

@property (nonatomic,copy)NSString *contentid;
@property (weak, nonatomic) IBOutlet UIImageView *dateImage;//图片
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;//地点
@property (weak, nonatomic) IBOutlet UILabel *thingsLabel;//做的事情
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;//进展程度
@end
