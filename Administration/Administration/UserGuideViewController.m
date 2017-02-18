//
//  UserGuideViewController.m
//  Administration
//  引导页
//  Created by 九尾狐 on 2017/2/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "UserGuideViewController.h"
#import "ViewController.h"
@interface UserGuideViewController ()

@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self initGuide];   //加载新用户指导页面
    // Do any additional setup after loading the view.
}
- (void)initGuide
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width*4, 0)];
    
    
    [scrollView setShowsHorizontalScrollIndicator:NO];//隐藏scrollview的滚动条

    [scrollView setPagingEnabled:YES];  //视图整页显示
     [scrollView setBounces:NO]; //避免弹跳效果,避免把根视图露出来
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview setImage:[UIImage imageNamed:@"01.png"]];
    [scrollView addSubview:imageview];
    [imageview release];
    
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview1 setImage:[UIImage imageNamed:@"02.png"]];
    [scrollView addSubview:imageview1];
    [imageview1 release];
    
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width *2, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview2 setImage:[UIImage imageNamed:@"03.png"]];
    [scrollView addSubview:imageview2];
    [imageview2 release];
    
    
    UIImageView *imageview3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width *3, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview3 setImage:[UIImage imageNamed:@"04.png"]];
    imageview3.userInteractionEnabled = YES;    //打开imageview3的用户交互;否则下面的button无法响应
    [scrollView addSubview:imageview3];
    [imageview3 release];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//在imageview3上加载一个透明的button
    [button setTitle:@"登陆" forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
    [button.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    
    [button.layer setCornerRadius:10];
    
    [button.layer setBorderWidth:2];//设置边界的宽度
    
    
    
    //设置按钮的边界颜色
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){255,255,255,1});
    
    [button.layer setBorderColor:color];
    
    
    [button setFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height-150, 100, 50)];
    [button addTarget:self action:@selector(firstpressed) forControlEvents:UIControlEventTouchUpInside];
    [imageview3 addSubview:button];
    
    [self.view addSubview:scrollView];
    
}
- (void)firstpressed
{
    ViewController *VC= [[ViewController alloc]init];
    [self presentViewController:VC animated:YES completion:nil]; //点击button跳转到根视图
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
