//
//  OpinionViewController.m
//  Administration
//  意见反馈
//  Created by 九尾狐 on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "OpinionViewController.h"
#import "WJTextView.h"
@interface OpinionViewController ()
@property (nonatomic,weak) WJTextView *textView;

@end

@implementation OpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"意见反馈";
    self.view.backgroundColor = [UIColor colorWithRed:(237/255.0) green:(237/255.0) blue:(237/255.0) alpha:1];
    [self createTextView];
    // Do any additional setup after loading the view.
}
- (void)createTextView{
    
    UILabel *YJLabel = [[UILabel alloc]init];
    YJLabel.text = @"您的意见";
    YJLabel.textColor = [UIColor colorWithRed:(130/255.0) green:(130/255.0) blue:(130/255.0) alpha:1];
    [self.view addSubview:YJLabel];
    
    [YJLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (self.view.mas_left).offset(20);
        make.top.mas_equalTo(self.view.mas_top).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    
    // 创建textView
    WJTextView *textView = [[WJTextView alloc]init];
    // 设置颜色
    textView.backgroundColor = [UIColor whiteColor];
    // 设置提示文字
    textView.placehoder = @"我们希望听到您的声音，\n感谢你的支持与帮助，\n今后也请务必继续关注我们的成长哦～";
    // 设置提示文字颜色
    textView.placehoderColor = [UIColor colorWithRed:(188/255.0) green:(176/255.0) blue:(195/255.0) alpha:1];
    // 设置textView的字体
    textView.font = [UIFont systemFontOfSize:15];
    // 设置内容是否有弹簧效果
    textView.alwaysBounceVertical = YES;
    // 设置textView的高度根据文字自动适应变宽
    textView.isAutoHeight = YES;
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 20.0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 添加到视图上
    [self.view addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(YJLabel.mas_bottom).offset(50);
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(@180);
    }];
    
    self.textView = textView;
    
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
