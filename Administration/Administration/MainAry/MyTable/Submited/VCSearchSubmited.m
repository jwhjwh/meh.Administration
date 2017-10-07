//
//  VCSearchSubmited.m
//  Administration
//
//  Created by zhang on 2017/10/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCSearchSubmited.h"

@interface VCSearchSubmited ()

@end

@implementation VCSearchSubmited

#pragma -mark custem
-(void)setUI
{
    UIView *viewT = [[UIView alloc]init];
    viewT.layer.borderWidth = 1.0f;
    viewT.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:viewT];
    [viewT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(-1);
        make.right.mas_equalTo(self.view.mas_right).offset(1);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(50);
    }];
    
    
    
    
}
#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索";
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
