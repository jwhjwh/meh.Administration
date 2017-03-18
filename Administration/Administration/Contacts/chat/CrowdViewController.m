//
//  CrowdViewController.m
//  Administration
//
//  Created by zhang on 2017/3/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CrowdViewController.h"

@interface CrowdViewController ()

@end

@implementation CrowdViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"我的群";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
