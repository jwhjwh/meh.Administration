//
//  VCMobaiRemark.m
//  Administration
//
//  Created by zhang on 2017/11/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCMobaiRemark.h"

@interface VCMobaiRemark ()

@end

@implementation VCMobaiRemark

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, kTopHeight, Scree_width-16, 21)];
    label.numberOfLines = 0;
    label.text = self.string;
    CGSize size = [self.string boundingRectWithSize:CGSizeMake(Scree_width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    label.frame = CGRectMake(8, kTopHeight, Scree_width-16, size.height+20);
    [self.view addSubview:label];
    
    self.title = self.stringTitle;
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
