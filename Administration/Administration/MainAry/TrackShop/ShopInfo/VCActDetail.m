//
//  VCActDetail.m
//  Administration
//
//  Created by zhang on 2017/12/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCActDetail.h"

@interface VCActDetail ()

@end

@implementation VCActDetail

#pragma -mark custem

-(void)setUI
{
    self.view.backgroundColor = GetColor(234, 235, 236, 1);
    
    NSString *string = @"公司近年来举办的大型活动简介，取得的成效及影响等简要说明概括方便于对该店个年经营状况的对比、分析、总结";
    CGSize size = [string boundingRectWithSize:CGSizeMake(Scree_width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, kTopHeight, Scree_width-20, 30)];
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    label.text = string;
    [self.view addSubview:label];
    label.frame = CGRectMake(10, kTopHeight, Scree_width-20, size.height);
    
    CGSize size1 = [self.content boundingRectWithSize:CGSizeMake(Scree_width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, label.frame.size.height+kTopHeight, Scree_width-20, size1.height)];
    textView.font = [UIFont systemFontOfSize:17];
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    textView.backgroundColor = [UIColor whiteColor];
    textView.text = self.content;
    [self.view addSubview:textView];
    
    
}
#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动概要";
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
