//
//  NoticeView.m
//  Administration
//
//  Created by zhang on 2017/2/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "NoticeView.h"
#import "ZYJHeadLineModel.h"
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
    _dataArr=[[NSMutableArray alloc]init];
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:12.5];
    self.layer.borderWidth = 1.0;
    self.layer.borderColor =[UIColor RGBNav].CGColor;
    
    _hornImage=[[UIImageView alloc]initWithFrame:CGRectMake(5,self.frame.size.height/2-22, 28, 28)];
    
    _hornImage.image=[UIImage imageNamed:@"laba"];
    [self addSubview:_hornImage];
    
    _fullImage=[[UIImageView alloc]initWithFrame:CGRectMake(_hornImage.right+3,1, 16,16)];
    
    _fullImage.image=[UIImage imageNamed:@"xulie"];
    [self addSubview:_fullImage];
    _label=[[UILabel alloc]initWithFrame:CGRectMake(_fullImage.right, 0, 80,20)];
    _label.text=@"全体员工";
    _label.font = [UIFont systemFontOfSize:10];
    [self addSubview:_label];
    _TopLineView = [[ZYJHeadLineView alloc]initWithFrame:CGRectMake(_hornImage.right+5, _hornImage.top-1,kMidViewWidth, kMidViewHeight)];
    __weak __typeof(self)weakSelf = self;
    _TopLineView.clickBlock = ^(NSInteger index){
        ZYJHeadLineModel *model = weakSelf.dataArr[index];
        NSLog(@"%@,%@",model.type,model.title);
    };
    [self addSubview:_TopLineView];
  
  
   
    NSArray *arr1 = @[@"推荐",@"最热",@"最新",@"关注",@"反馈"];
    NSArray *arr2 = @[@"大降价了啊",@"iPhone7分期",@"这个苹果蛮脆的",@"来尝个香蕉吧",@"越来越香了啊你的秀发"];
    for (int i=0; i<arr2.count; i++) {
        ZYJHeadLineModel *model = [[ZYJHeadLineModel alloc]init];
        model.type = arr1[i];
        model.title = arr2[i];
        [_dataArr addObject:model];
    }
       NSLog(@"dataArr:%@",_dataArr);
    [_TopLineView setVerticalShowDataArr:_dataArr];
}

@end
