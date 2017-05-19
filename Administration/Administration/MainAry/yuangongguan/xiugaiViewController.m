//
//  xiugaiViewController.m
//  Administration
//
//  Created by zhang on 2017/3/4.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "xiugaiViewController.h"

@interface xiugaiViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)NSString *passtStr;
@end

@implementation xiugaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"重置密码";
    self.view.backgroundColor =GetColor(230, 230, 230, 1);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"提交"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(tijiaoClick)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(Scree_width/2-50, 74,100, 30)];
    label.text=@"重置新密码";
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
    UITextField *textFleid=[[UITextField alloc]initWithFrame:CGRectMake(0, label.bottom, Scree_width,45)];
    textFleid.borderStyle=UITextBorderStyleLine;
    textFleid.delegate = self;
     [textFleid addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    textFleid.keyboardType = UIKeyboardTypeNumberPad;//键盘格式
    textFleid.backgroundColor = [UIColor whiteColor];
    textFleid.layer.borderColor= [UIColor whiteColor].CGColor;
    textFleid.layer.borderWidth = 2.0;
    textFleid.secureTextEntry = YES;
    [self.view addSubview:textFleid];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tijiaoClick{
    if (_passtStr==nil) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"密码不能为空" andInterval:1.0f];
    }else{
        NSString *uStr =[NSString stringWithFormat:@"%@user/updatepass.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"user":_passtStr,@"userid":_uresID,@"mobile":_callNum};
        [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
            
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改成功" andInterval:1.0];
             
            } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改失败" andInterval:1.0];
            } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]||[[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
                PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
                
                alertView.resultIndex = ^(NSInteger index){
                    ViewController *loginVC = [[ViewController alloc] init];
                    UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                    [self presentViewController:loginNavC animated:YES completion:nil];
                };
                [alertView showMKPAlertView];
                
            }
            
        }failure:^(NSError *error) {
            
        }view:self.view MBPro:YES];
    }
}
-(void)textFieldChange :(UITextField *)textField{
    _passtStr = textField.text;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
