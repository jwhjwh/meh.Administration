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
#import "ReportModel.h"
#import "someModel.h"
@interface ReportPermissionsVC ()<UIScrollViewDelegate>
@property (strong,nonatomic)  GuiiiiiDView *guiiiiidView;


@property (strong,nonatomic)  NSMutableArray *ywAry;
@property (strong,nonatomic)  NSMutableArray *mdAry;
@property (strong,nonatomic)  NSMutableArray *wlAry;
@property (strong,nonatomic)  NSMutableArray *nqAry;

@end

@implementation ReportPermissionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"报表权限设置";
    [self subLabelUI];
    [self reoirtNetWork];
    _guiiiiidView = [[GuiiiiiDView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //[self.view addSubview:_guiiiiidView];
   
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)subLabelUI{
    _ywAry = [NSMutableArray arrayWithObjects:@"行政管理",@"总经理",@"业务经理",@"业务总监", nil];
    _mdAry = [NSMutableArray arrayWithObjects:@"行政管理",@"总经理",@"业务经理",@"业务总监", nil];
    _wlAry = [NSMutableArray arrayWithObjects:@"总经理",@"行政管理", nil];
    _nqAry = [NSMutableArray arrayWithObjects:@"总经理",@"市场经理", nil];
    
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
   
    UIScrollView *backScroll = [[UIScrollView alloc]init];
    backScroll.directionalLockEnabled = YES;
    backScroll.backgroundColor = GetColor(235, 235, 235, 1);
    backScroll.delegate = self;
    backScroll.bounces = NO;
    backScroll.contentSize = CGSizeMake(self.view.frame.size.width, (180*4)+(20*4)+30);
    [self.view addSubview:backScroll];
    [backScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(gouxuanLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
    
    //业务
    ZHTBtnView *zhtbtnview = [[ZHTBtnView alloc]initWithFrame:CGRectZero arr:_ywAry coode:1];
    NSLog(@"%@",zhtbtnview.ywAry);
    [backScroll addSubview:zhtbtnview];
    [zhtbtnview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backScroll.mas_top).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_offset(180);
    }];
    //美导
    ZHTBtnView *zhtbtnview1 = [[ZHTBtnView alloc]initWithFrame:CGRectZero arr:_mdAry coode:2];
    [backScroll addSubview:zhtbtnview1];
    [zhtbtnview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(zhtbtnview.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_offset(180);
    }];
    //物流
    ZHTBtnView *zhtbtnview2 = [[ZHTBtnView alloc]initWithFrame:CGRectZero arr:_wlAry coode:3];
    [backScroll addSubview:zhtbtnview2];
    [zhtbtnview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(zhtbtnview1.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_offset(180);
    }];
    //内勤
    ZHTBtnView *zhtbtnview3 = [[ZHTBtnView alloc]initWithFrame:CGRectZero arr:_nqAry coode:4];
    [backScroll addSubview:zhtbtnview3];
    [zhtbtnview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(zhtbtnview2.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_offset(180);
    }];
    
}
-(void)reoirtNetWork{
    //manager/queryPosition.action
    NSString *urlStr = [NSString stringWithFormat:@"%@manager/queryReportPosition", KURLHeader];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid};
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
       //if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *ywray=[NSDictionary changeType:[ responseObject valueForKey:@"yw"]];
        NSArray *mdary = [responseObject valueForKey:@"md"];
        NSArray *wlary = [responseObject valueForKey:@"wl"];
        NSArray *nqary = [responseObject valueForKey:@"nq"];
        for (NSDictionary *dic in ywray) {
            //NSString *num = dic[@"num"];
            NSString *newname = dic[@"newName"];
        }
        
            //
       // NSLog(@"ywray：%@\nmdary：%@\nwlary：%@\nnqary：%@",ywray,mdary,wlary,nqary);
            
        //}
        
    } failure:^(NSError *error) {
        
        
    } view:self.view MBPro:YES];
    
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
