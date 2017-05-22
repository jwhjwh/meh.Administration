//
//  ManageViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/5/20.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ManageViewController.h"
#import "MainTableViewCell.h"
@interface ManageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UIButton *sousuoBtn;//搜索框
@property (nonatomic,retain)UITableView *infonTableview;
@property (nonatomic,strong) NSArray*LabelAry;
@end

@implementation ManageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"员工管理";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)Touchsearch{
    //SearchViewController
    SearchViewController *SearchVC = [[SearchViewController alloc]init];
    [self.navigationController showViewController:SearchVC sender:nil];
    
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
