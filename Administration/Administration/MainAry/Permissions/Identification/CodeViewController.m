//
//  CodeViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CodeViewController.h"

@interface CodeViewController ()
@property (nonatomic,strong)UIAlertController *alertController;;
@property (nonatomic,strong) UIView *oldPassword;
@property (nonatomic,strong) UIView *onePassword;
@property (nonatomic,strong) UIView *twoPassword;

@property (nonatomic,strong) UITextField *oldField;
@property (nonatomic,strong) UITextField *oneField;
@property (nonatomic,strong) UITextField *twoField;

@property (nonatomic,strong) UIButton *loginButton;

@property (nonatomic,strong) NSString *oldString;
@property (nonatomic,strong) NSString *oneString;
@property (nonatomic,strong) NSString *twoString;

@property (nonatomic,assign) BOOL hide;
@property (nonatomic,strong) UIButton *hideButton;
@property (nonatomic,strong) UILabel *promptLabel;
@property (nonatomic,assign) BOOL Open;
@end

@implementation CodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _hide = NO;
    _Open = NO;
    
    self.view.backgroundColor =GetColor(230, 230, 230, 1);
    self.title = @"修改识别码";
    [self initWithGoin];
    // Do any additional setup after loading the view.
}
- (void)initWithGoin{
    [self.view addSubview:self.oldPassword];
    [self.view addSubview:self.onePassword];
    [self.view addSubview:self.twoPassword];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.hideButton];
    [self.view addSubview:self.promptLabel];
    
    
    [self.oldPassword addSubview:self.oldField];
    [self.onePassword addSubview:self.oneField];
    [self.twoPassword addSubview:self.twoField];
    
    [self initWithLable];
    
}
- (UIView *)oldPassword{
    if (!_oldPassword) {
        _oldPassword = [[UIView alloc]initWithFrame:CGRectMake(0, ADAPTATION_HEIGHT(120),ADAPTATION_WIDTH(414), ADAPTATION_HEIGHT(50))];
        _oldPassword.backgroundColor = [UIColor whiteColor];
    }
    return _oldPassword;
}
- (UIView *)onePassword{
    if (!_onePassword) {
        _onePassword = [[UIView alloc]initWithFrame:CGRectMake(0, ADAPTATION_HEIGHT(210), ADAPTATION_WIDTH(414), ADAPTATION_HEIGHT(50))];
        _onePassword.backgroundColor = [UIColor whiteColor];
    }
    return _onePassword;
}
- (UIView *)twoPassword{
    if (!_twoPassword) {
        _twoPassword = [[UIView alloc]initWithFrame:CGRectMake(0, ADAPTATION_HEIGHT(300), ADAPTATION_WIDTH(414), ADAPTATION_HEIGHT(50))];
        _twoPassword.backgroundColor = [UIColor whiteColor];
    }
    return _twoPassword;
}

- (void)initWithLable{
    NSArray *array = @[@"请输入旧识别码：",@"请输入新识别码：",@"请确认新识别码："];
    for (int i = 0; i < array.count; i ++) {
        UILabel *labelse = [[UILabel alloc]initWithFrame:CGRectMake(ADAPTATION_WIDTH(15), ADAPTATION_HEIGHT(90 + i*90), ADAPTATION_WIDTH(200), ADAPTATION_HEIGHT(30))];
        labelse.font = FONT(14);
        labelse.text = array[i];
        labelse.textColor = GetColor(128, 128, 128, 1);
        labelse.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:labelse];
    }
}
- (UITextField *)oldField{
    if (!_oldField) {
        _oldField = [[UITextField alloc]initWithFrame:CGRectMake(ADAPTATION_WIDTH(60), ADAPTATION_HEIGHT(7.5), ADAPTATION_WIDTH(355), ADAPTATION_HEIGHT(40))];
        _oldField.placeholder = @"6-16个字符，区分大小写";
        _oldField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _oldField.autocapitalizationType = UITextAutocapitalizationTypeNone; //首字母是否大写
        _oldField.secureTextEntry = YES; //安全输入
        _oldField.font = FONT(14);
        [_oldField addTarget:self action:@selector(action_text) forControlEvents:UIControlEventEditingChanged];
    }
    return _oldField;
}

- (UITextField *)oneField{
    if (!_oneField) {
        
        _oneField = [[UITextField alloc]initWithFrame:CGRectMake(ADAPTATION_WIDTH(60), ADAPTATION_HEIGHT(7.5), ADAPTATION_WIDTH(355), ADAPTATION_HEIGHT(40))];
        _oneField.placeholder = @"6-16个字符，区分大小写";
        _oneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _oneField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _oneField.secureTextEntry = YES;
        _oneField.font = FONT(14);
        [_oneField addTarget:self action:@selector(action_text) forControlEvents:UIControlEventEditingChanged];
    }
    return _oneField;
}

- (UITextField *)twoField{
    if (!_twoField) {
        _twoField = [[UITextField alloc]initWithFrame:CGRectMake(ADAPTATION_WIDTH(60), ADAPTATION_HEIGHT(7.5), ADAPTATION_WIDTH(355), ADAPTATION_HEIGHT(40))];
        _twoField.placeholder = @"6-16个字符，区分大小写";
        _twoField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时出现 ×
        _twoField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _twoField.secureTextEntry = YES;
        _twoField.font = FONT(14);
        [_twoField addTarget:self action:@selector(action_text) forControlEvents:UIControlEventEditingChanged];
    }
    return _twoField;
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
- (void)action_text{
    if (_oldField.text.length > 0 && _oneField.text.length > 0 && _twoField.text.length >0) {
        _loginButton.backgroundColor = GetColor(92, 178, 135, 1);
        _loginButton.enabled = YES;
        _Open = YES;
    }else{
        _loginButton.backgroundColor = [UIColor lightGrayColor];
        _loginButton.enabled = YES;
        _Open = NO;
    }
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
- (UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(ADAPTATION_WIDTH(60), ADAPTATION_HEIGHT(435), ADAPTATION_WIDTH(100), ADAPTATION_HEIGHT(20))];
        _promptLabel.font = FONT(13);
        _promptLabel.text = @"显示识别码";
        _promptLabel.textAlignment = NSTextAlignmentLeft;
        _promptLabel.textColor = GetColor(128, 128, 128, 1);
    }
    return _promptLabel;
}

#pragma mark --action
- (void)action_button:(UIButton *)sender{
    if (_Open == YES) {
        _oldString = _oldField.text;
        _oneString = _oneField.text;
        _twoString = _twoField.text;
        BOOL dog = [_oneString isEqual:_twoString];
        if (dog == YES) {
            [self loadDataFromServer];
        }else{
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"两次识别码输入不相同" andInterval:1.0];
        }
    }
}

- (void)action_hideBUtton:(UIButton *)sender{
    _hide = !_hide;
    if (_hide == YES) {
        [_hideButton setBackgroundImage:[UIImage imageNamed:@"对-选中"] forState:UIControlStateNormal];
        _oldField.secureTextEntry = NO;
        _oneField.secureTextEntry = NO;
        _twoField.secureTextEntry = NO;
    }else{
        [_hideButton setBackgroundImage:[UIImage imageNamed:@"对-未选"] forState:UIControlStateNormal];
        _oldField.secureTextEntry = YES;
        _oneField.secureTextEntry = YES;
        _twoField.secureTextEntry = YES;
    }
}

-(void)loadDataFromServer{
    NSString *udidstr = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"udid"]];
    if ([_oldField.text isEqualToString:udidstr]) {
        
        //companyinfoid
        NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
        NSString *uStr =[NSString stringWithFormat:@"%@user/updateudid.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        
        NSString *newPassMD = [ZXDNetworking encryptStringWithMD5:_oneString];
        NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"companyinfoid":companyinfoid,@"udid":newPassMD};
        
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
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"旧识别码错误" andInterval:1.0];
            }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"登陆超时，请重新登录" andInterval:1.0];
            }else{
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            }
            
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
    }else{
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"旧识别码不正确" andInterval:1.0];
    }
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
