//
//  NoticeView.h
//  Administration
//
//  Created by zhang on 2017/2/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZYJHeadLineView.h"
#define kMidViewWidth   250
#define kMidViewHeight  50
@interface NoticeView : UIView
@property (nonatomic,retain)NSArray *array;
//公告数组
@property (nonatomic,retain)UILabel *label;
// 喇叭
@property (nonatomic,retain)UIImageView *hornImage;
//原点
@property (nonatomic,retain)UIImageView *fullImage;

@property (nonatomic,strong) ZYJHeadLineView *TopLineView;

@property(nonatomic,strong)NSMutableArray *dataArr;
@end
