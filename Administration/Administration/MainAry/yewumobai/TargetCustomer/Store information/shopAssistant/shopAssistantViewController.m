//
//  shopAssistantViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/28.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "shopAssistantViewController.h"

@interface shopAssistantViewController ()

@end

@implementation shopAssistantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店员信息";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIButton *rightitem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightitem.frame =CGRectMake(self.view.frame.size.width-30, 0, 28,28);
    [rightitem setBackgroundImage:[UIImage imageNamed:@"fj_ico"] forState:UIControlStateNormal];
    [rightitem addTarget: self action: @selector(rightItemAction) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *rbuttonItem=[[UIBarButtonItem alloc]initWithCustomView:rightitem];
    self.navigationItem.rightBarButtonItem = rbuttonItem;
}
-(void)rightItemAction{


}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
