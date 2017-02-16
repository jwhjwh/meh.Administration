//
//  NoticeView.h
//  Administration
//
//  Created by zhang on 2017/2/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYJHeadLineModel.h"
#import "ZYJHeadLineView.h"
#define kMidViewWidth   250
#define kMidViewHeight  50
@interface NoticeView : UIView
@property (nonatomic,retain)UILabel *label;
@property (nonatomic,retain)UIImageView *image;
@property(nonatomic,strong)NSMutableArray*dataArr;
@property (nonatomic,strong) ZYJHeadLineView *TopLineView;
@end
