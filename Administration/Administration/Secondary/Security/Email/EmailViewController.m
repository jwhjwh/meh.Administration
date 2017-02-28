//
//  EmailViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/27.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "EmailViewController.h"

@interface EmailViewController ()

@end

@implementation EmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self EmailUI];
    self.view.backgroundColor  = GetColor(246, 246, 246, 1);
    // Do any additional setup after loading the view.
}
-(void)EmailUI{
    
    UIView *view1 =[[UIView alloc]init];
    view1.backgroundColor = GetColor(211, 210, 211, 1);
    [self.view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(78);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(2);
    }];
    UILabel *emailLabel = [[UILabel alloc]init];
    emailLabel.text = _emailStr;
    //emailLabel.backgroundColor = [UIColor redColor];
    emailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:emailLabel];
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo (view1.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(50);
    }];
    UIView *view2 =[[UIView alloc]init];
    view2.backgroundColor = GetColor(190, 184, 193, 1);
    [self.view addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(emailLabel.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(2);
    }];
    UILabel *TiShiLabel = [[UILabel alloc]init];
    TiShiLabel.text = @"如果你更改了邮箱地址，你需要对邮箱地址重新验证。";
    //TiShiLabel.backgroundColor = [UIColor redColor];
    TiShiLabel.font = [UIFont systemFontOfSize:11];
    TiShiLabel.textColor = GetColor(152, 152, 152, 1);
    TiShiLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:TiShiLabel];
    [TiShiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo (view2.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(50);
    }];
    UIButton *JCBDBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [JCBDBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    JCBDBtn.backgroundColor = GetColor(255, 255, 255, 1);
    
    JCBDBtn.layer.cornerRadius = 5.0;
    
    JCBDBtn.layer.borderWidth = 1.0f;
    
    [JCBDBtn setTitleColor:GetColor(77, 140, 199, 1)forState:UIControlStateNormal];
    [JCBDBtn addTarget:self action:@selector(JCBDBtn)forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:JCBDBtn];
    [JCBDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(80);
        make.top.equalTo(TiShiLabel.mas_bottom).offset(100);
        make.right.equalTo(self.view.mas_right).offset(-80);
        make.height.mas_equalTo(50);
    }];
}
-(void)JCBDBtn{
    NSString *uStr =[NSString stringWithFormat:@"%@user/removeemail.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"]};
    
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"解除成功" andInterval:1.0];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"操作失败" andInterval:1.0];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
        }else
        {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时，请重新发送" andInterval:1.0];
        }

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
