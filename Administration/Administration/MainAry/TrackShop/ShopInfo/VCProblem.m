//
//  VCProblem.m
//  Administration
//
//  Created by zhang on 2017/12/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCProblem.h"

@interface VCProblem ()

@end

@implementation VCProblem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"存在的优势及问题";
    
    CGSize size = [self.Content boundingRectWithSize:CGSizeMake(Scree_width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, Scree_width-30, 50)];
    textView.text = self.Content;
    textView.userInteractionEnabled = NO;
    textView.scrollEnabled = NO;
    [self.view addSubview:textView];
    
    textView.frame = CGRectMake(15, 10, Scree_width-30, size.height);
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
