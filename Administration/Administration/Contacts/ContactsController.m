//
//  ContactsController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ContactsController.h"
#import "CrowdViewController.h"
#import "BuildViewController.h"
#import "FIrstController.h"
#import "SecondController.h"
#import "SectionChooseView.h"


@interface ContactsController ()<SectionChooseVCDelegate>
{
    
    FIrstController *_oneVC;
    SecondController *_twoVC;
}
@property(nonatomic,strong)SectionChooseView *sectionChooseView;

@end

@implementation ContactsController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //设置导航栏
    [self setUpNav];
    //创建控制器的对象
    _oneVC = [[FIrstController alloc] init];
    //    _oneVC.view.backgroundColor = [UIColor redColor];
    _twoVC = [[SecondController alloc] init];
    //    _twoVC.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_oneVC.view];
    [self addChildViewController:_oneVC];
    [self addChildViewController:_twoVC];
}
/**
 *  设置导航栏（学生/老师）
 */
- (void)setUpNav {
    UIBarButtonItem *lifttitem = [[UIBarButtonItem alloc] initWithTitle:@"群" style:(UIBarButtonItemStyleDone) target:self action:@selector(liftItemAction)];
    //    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    NSDictionary * dict = @{
                            NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:16],
                            NSForegroundColorAttributeName : [UIColor whiteColor]
                            };
    [lifttitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = lifttitem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"创建群" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemA)];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    self.sectionChooseView = [[SectionChooseView alloc] initWithFrame:CGRectMake((Scree_width - self.view.bounds.size.width*0.5)/2, 25, self.view.bounds.size.width * 0.5, 30) titleArray:@[@"消息", @"通讯录"]];
    self.sectionChooseView.selectIndex = 0;
    self.sectionChooseView.delegate = self;
    self.sectionChooseView.normalBackgroundColor = [UIColor clearColor];
    self.sectionChooseView.selectBackgroundColor = GetColor(205, 176, 218, 1);
    self.sectionChooseView.titleNormalColor = [UIColor whiteColor];
    self.sectionChooseView.titleSelectColor = [UIColor whiteColor];
    self.sectionChooseView.normalTitleFont = 16;
    self.sectionChooseView.selectTitleFont = 16;
    self.navigationItem.titleView = self.sectionChooseView;
}

-(void)rightItemA{
    BuildViewController *creatVC=[[BuildViewController alloc]init];
    [self.navigationController pushViewController:creatVC animated:YES];
}
-(void)liftItemAction{
    CrowdViewController *CrowdVC=[[CrowdViewController alloc]init];
    [self.navigationController pushViewController:CrowdVC animated:YES];
}
#pragma mark -SMCustomSegmentDelegate

- (void)SectionSelectIndex:(NSInteger)selectIndex {
    
    switch (selectIndex) {
        case 0:{
            //第一个界面
            [self.view addSubview:_oneVC.view];
            [_twoVC.view removeFromSuperview];
        }
            break;
        case 1:{
            [self.view addSubview:_twoVC.view];
            [_oneVC.view removeFromSuperview];
        }
            break;
        default:
            break;
    }
    
}
@end
