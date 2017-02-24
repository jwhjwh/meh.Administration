//
//  ModifyViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/24.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ModifyViewController.h"

@interface ModifyViewController ()
@property (nonatomic,strong)UIAlertController *alertController;;
@property (strong,nonatomic) UITextField *AnimationTextField;

@property (nonatomic,assign) BOOL hide;

@property (nonatomic,assign) BOOL Open;

@property (nonatomic,strong) UILabel *promptLabel; //显示密码

@property (nonatomic,strong) UIButton *hideButton;//显示密码按钮

@property (nonatomic,strong) UIButton *loginButton;//确定

@property (nonatomic,strong) NSString *lodPass;

@property (nonatomic,strong) NSString *NewPass;

@property (nonatomic,strong) NSString *QDPass;

@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _hide = NO;
    self.view.backgroundColor = GetColor(255, 255, 255, 1);
    [self.view addSubview:self.hideButton];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.loginButton];
    [self textFieldUI];
    [self initWithLable];
    // Do any additional setup after loading the view.
}
- (void)initWithLable{
    NSArray *array = @[@"旧密码：",@"新密码：",@"确认密码："];
    for (int i = 0; i < array.count; i ++) {
        UILabel *labelse = [[UILabel alloc]initWithFrame:CGRectMake(ADAPTATION_WIDTH(15), ADAPTATION_HEIGHT(90 + i*90), ADAPTATION_WIDTH(200), ADAPTATION_HEIGHT(30))];
        labelse.font = FONT(18);
        labelse.text = array[i];
        labelse.textColor = GetColor(0,0, 0, 1);
        labelse.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:labelse];
    }
}
-(void)textFieldUI
{
    NSArray *placeHolderArr = @[@"6-16个字符，区分大小写",@"6-16个字符，区分大小写",@"6-16个字符，区分大小写"];
    for (int i = 0; i < 3; i++) {
        _AnimationTextField  = [[UITextField alloc]initWithFrame:CGRectMake(ADAPTATION_WIDTH(-2), ADAPTATION_HEIGHT(90 + i*90+40), ADAPTATION_WIDTH(419), ADAPTATION_HEIGHT(50))];
        _AnimationTextField.backgroundColor = GetColor(255, 255, 255, 1);
        _AnimationTextField.placeholder = placeHolderArr[i];
        _AnimationTextField.tag = i + 10;
        _AnimationTextField.secureTextEntry = YES; //安全输入
        
        _AnimationTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 0)];
         _AnimationTextField.leftViewMode = UITextFieldViewModeAlways;
        
        _AnimationTextField.layer.borderWidth = 2.0f;
        _AnimationTextField.layer.borderColor = GetColor(200, 200, 205, 1).CGColor;
        [_AnimationTextField addTarget:self action:@selector(action_text:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_AnimationTextField];
    }

}
- (UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]initWithFrame:CGRectMake(ADAPTATION_WIDTH(33), ADAPTATION_HEIGHT(380), ADAPTATION_WIDTH(350), ADAPTATION_HEIGHT(40))];
        [_loginButton setTitle:@"确定" forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius = 6;
        _loginButton.layer.masksToBounds = YES;
        _loginButton.enabled = NO;
        _loginButton.tintColor = [UIColor whiteColor];
        _loginButton.backgroundColor = [UIColor lightGrayColor];
        [_loginButton addTarget:self action:@selector(action_button:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginButton;
}
- (void)action_button:(UIButton *)sender{
    if (_Open == YES) {
        BOOL dog = [_NewPass isEqual:_QDPass];
        if (dog == YES) {
            [self loadDataFromServer];
        }else{
                 [ELNAlerTool showAlertMassgeWithController:self andMessage:@"两次密码不一致" andInterval:1.0];
            }
    }
}

- (void)action_text:(UITextField *)theTextField{
   NSLog( @"text changed: %@", theTextField.text);
    if (theTextField.tag == 10) {
        _lodPass = theTextField.text;
    }else if (theTextField.tag == 11){
        _NewPass = theTextField.text;
    }else{
        _QDPass = theTextField.text;
    }
    NSLog(@"lod:%@ new:%@ QD:%@",_lodPass,_NewPass,_QDPass);
    if (_lodPass.length > 0  && _NewPass.length > 0 && _QDPass.length >0) {
        _loginButton.backgroundColor = GetColor(92, 178, 135, 1);
        _loginButton.enabled = YES;
        _Open = YES;
    }else{
        _loginButton.backgroundColor = [UIColor lightGrayColor];
        _loginButton.enabled = YES;
        _Open = NO;
    }

}
- (UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(ADAPTATION_WIDTH(60), ADAPTATION_HEIGHT(435), ADAPTATION_WIDTH(100), ADAPTATION_HEIGHT(20))];
        _promptLabel.font = FONT(13);
        _promptLabel.text = @"显示密码";
        _promptLabel.textAlignment = NSTextAlignmentLeft;
        _promptLabel.textColor = GetColor(128, 128, 128, 1);
    }
    return _promptLabel;
}
- (UIButton *)hideButton{
    if (!_hideButton) {
        _hideButton = [[UIButton alloc]initWithFrame:CGRectMake(ADAPTATION_WIDTH(38), ADAPTATION_HEIGHT(435), ADAPTATION_WIDTH(20), ADAPTATION_HEIGHT(20))];
        _hideButton.layer.cornerRadius =ADAPTATION_WIDTH(20/2);
        _hideButton.layer.masksToBounds = YES;
        [_hideButton setBackgroundImage:[UIImage imageNamed:@"对-未选"] forState:UIControlStateNormal];
        [_hideButton addTarget:self action:@selector(action_hideBUtton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hideButton;
}
- (void)action_hideBUtton:(UIButton *)sender{
    _hide = !_hide;
    if (_hide == YES) {
        [_hideButton setBackgroundImage:[UIImage imageNamed:@"对-选中"] forState:UIControlStateNormal];
       
        _AnimationTextField.secureTextEntry = NO;
        
    }else{
        [_hideButton setBackgroundImage:[UIImage imageNamed:@"对-未选"] forState:UIControlStateNormal];
        _AnimationTextField.secureTextEntry = YES;
        
    }
}
-(void)loadDataFromServer{
    NSString *uStr =[NSString stringWithFormat:@"%@user/updatepass.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSString *lodpassMD = [ZXDNetworking encryptStringWithMD5:_lodPass];
    NSString *newPassMD = [ZXDNetworking encryptStringWithMD5:_NewPass];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"mobile":[USER_DEFAULTS  objectForKey:@"phone"],@"usedPass":lodpassMD,@"password":newPassMD};
    NSLog(@"%@",dic);
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            
            _alertController = [UIAlertController alertControllerWithTitle:@"修改成功,请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            //添加确定按钮
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *VC= [[ViewController alloc]init];
                [self presentViewController:VC animated:YES completion:nil];

                
            }];
            [_alertController addAction:yesAction];
            
            [self presentViewController:_alertController animated:YES completion:nil];
            
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0005"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"旧密码错误" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"登陆超时，请重新登录" andInterval:1.0];
        }else{
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
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
