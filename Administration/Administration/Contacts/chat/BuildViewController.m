//
//  BuildViewController.m
//  Administration
//
//  Created by zhang on 2017/3/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "BuildViewController.h"
#import "AddmemberController.h"
@interface BuildViewController ()<UITextFieldDelegate>

@property (strong,nonatomic) UIImageView *HeadView;//头像

@end

@implementation BuildViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"创建群";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItem)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    _HeadView = [[UIImageView alloc]init];
    [_HeadView setImage:[UIImage imageNamed:@"tx100.png"]];
    _HeadView.backgroundColor = [UIColor whiteColor];
    _HeadView.layer.masksToBounds = YES;
    _HeadView.layer.cornerRadius =80;//设置圆角
    [self.view addSubview:_HeadView];
    [_HeadView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.left.equalTo(self.view.mas_centerX).offset(-80);
        make.right.equalTo(self.view.mas_centerX).offset(80);
        make.size.mas_equalTo(CGSizeMake(160,160));
    }];
    UITextField *textFleid=[[UITextField alloc]init];
    textFleid.delegate = self;
    textFleid.textAlignment = NSTextAlignmentCenter;
    textFleid.placeholder=@"填写群名称";
    [self.view addSubview:textFleid];
    [textFleid  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_HeadView.mas_bottom).offset(60);
        make.left.equalTo(self.view.mas_centerX).offset(-80);
        make.right.equalTo(self.view.mas_centerX).offset(80);
        make.size.mas_equalTo(CGSizeMake(160,30));
    }];
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=GetColor(216, 216, 216, 1);
    [self.view addSubview:view];
    [view  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textFleid.mas_bottom);
        make.left.equalTo(self.view.mas_centerX).offset(-80);
        make.right.equalTo(self.view.mas_centerX).offset(80);
        make.size.mas_equalTo(CGSizeMake(160,1));
    }];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItem{
    AddmemberController *addmenVC=[[AddmemberController alloc]init];
    [self.navigationController pushViewController:addmenVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
