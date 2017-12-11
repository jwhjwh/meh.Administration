//
//  VCSpeciality.m
//  Administration
//
//  Created by zhang on 2017/12/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCSpeciality.h"

@interface VCSpeciality ()

@end

@implementation VCSpeciality

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    
    self.view.backgroundColor = GetColor(234, 235, 236, 1);
    
    CGSize size = [self.content boundingRectWithSize:CGSizeMake(Scree_width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, kTopHeight+10, Scree_width-20, size.height+20)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.text = self.content;
    textView.font = [UIFont systemFontOfSize:17];
    textView.scrollEnabled = NO;
    textView.userInteractionEnabled = NO;
    [self.view addSubview:textView];
    
   // textView.frame = CGRectMake(10, kTopHeight+10, Scree_width-20, size.height+20);
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
