//
//  ReportPermissionsVC.m
//  Administration
//
//  Created by 九尾狐 on 2017/4/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ReportPermissionsVC.h"
#import "GuiiiiiDView.h"
#import "ZHTBtnView.h"
@interface ReportPermissionsVC ()
@property (strong,nonatomic)  GuiiiiiDView *guiiiiidView;


@property (strong,nonatomic)  NSMutableArray *ywAry;

@end

@implementation ReportPermissionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"报表权限设置";
    [self subLabelUI];
    
    self.view.backgroundColor = GetColor(235, 235, 235, 1);
    _guiiiiidView = [[GuiiiiiDView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_guiiiiidView];
   
    
    
    // Do any additional setup after loading the view.
}
-(void)subLabelUI{
    UILabel *gouxuanLabel = [[UILabel alloc]init];
    gouxuanLabel.text = @"   请勾选报表批注权限职位";
    gouxuanLabel.textColor = GetColor(112, 112, 112, 1);
    gouxuanLabel.font = [UIFont systemFontOfSize:15.0f];
    gouxuanLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:gouxuanLabel];
    [gouxuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_offset(30);
    }];
    _ywAry = [NSMutableArray arrayWithObjects:@"行政管理",@"总经理",@"业务经理",@"业务总监", nil];
    ZHTBtnView *zhtbtnview = [[ZHTBtnView alloc]initWithFrame:CGRectZero arr:_ywAry coode:1];
    NSLog(@"%@",zhtbtnview.ywAry);
    [self.view addSubview:zhtbtnview];
    [zhtbtnview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(gouxuanLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_offset(180);
    }];
    ZHTBtnView *zhtbtnview1 = [[ZHTBtnView alloc]initWithFrame:CGRectZero arr:_ywAry coode:2];
    [self.view addSubview:zhtbtnview1];
    [zhtbtnview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(zhtbtnview.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_offset(180);
    }];
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
