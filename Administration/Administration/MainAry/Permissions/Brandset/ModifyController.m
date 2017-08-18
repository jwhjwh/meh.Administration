//
//  ModifyController.m
//  Administration
//
//  Created by zhang on 2017/5/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ModifyController.h"

@interface ModifyController ()
@property (nonatomic ,strong)UITextField *textField;
@property (nonatomic ,strong)NSString *str;
@end

@implementation ModifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"修改部门名称";
    self.view.backgroundColor= GetColor(230, 230, 230, 1);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:(UIBarButtonItemStyleDone) target:self action:@selector(submitClick)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightitem;
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 114, Scree_width-40, 30)];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.backgroundColor =[UIColor whiteColor];
    _textField.placeholder = @"请输入品牌部名称";
      placeholder(_textField);
    _textField.layer.cornerRadius=5;
    [_textField addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_textField];
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)FieldText:(UITextField*)sender{
    _str=sender.text;
}
-(void)submitClick{
    [self.view endEditing:YES];
    if (_textField.text.length == 0) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写品牌部名称" andInterval:1.0];
    }else{
        NSString *uStr =[NSString stringWithFormat:@"%@user/updateDepartmentName.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"DepartmentID":_BarandID,@"DepartmentName":_str,@"GroupNumber":_GroupNumber};
        [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改成功" andInterval:1.0];
                _blockStr(_str);
                dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
                dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改失败" andInterval:1.0];
                
            }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
                PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
                alertView.resultIndex = ^(NSInteger index){
                    [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                    ViewController *loginVC = [[ViewController alloc] init];
                    UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                    [self presentViewController:loginNavC animated:YES completion:nil];
                };
                [alertView showMKPAlertView];
            }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
                PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
                alertView.resultIndex = ^(NSInteger index){
                    [USER_DEFAULTS  setObject:@"" forKey:@"token"];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
