//
//  NoticeView.m
//  Administration
//
//  Created by zhang on 2017/2/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "NoticeView.h"

@implementation NoticeView


#pragma mark 代码创建
- (instancetype)initWithFrame:(CGRect)frame  {
    if (self = [super initWithFrame:frame]) {
        
        [self initSubView];
        
    }
    return self;
}
#pragma mark 初始化控件
- (void)initSubView {
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:12.5];
    //        self.idLabel.backgroundColor = [UIColor colorWithRed:43/256.0 green:180/256.0 blue:183/256.0 alpha:1];
    self.layer.borderWidth = 1.0;
    self.layer.borderColor =[UIColor RGBNav].CGColor;
    _TopLineView = [[ZYJHeadLineView alloc]initWithFrame:CGRectMake(0, 0, kMidViewWidth, kMidViewHeight)];
    _TopLineView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    _TopLineView.backgroundColor = [UIColor whiteColor];
    __weak __typeof(self)weakSelf = self;
    _TopLineView.clickBlock = ^(NSInteger index){
        ZYJHeadLineModel *model = weakSelf.dataArr[index];
        NSLog(@"%@,%@",model.type,model.title);
    };
    [self addSubview:_TopLineView];
    
}

@end
