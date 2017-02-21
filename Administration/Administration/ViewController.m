//
//  ViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<UITextFieldDelegate>
@property (strong,nonatomic) UITextField *NameText; // 用户名
@property (strong,nonatomic) UITextField *PassText;//密码
@property (strong,nonatomic) UITextField *valiText;//识别码
@property (strong,nonatomic) UIImageView *HeadView;//头像
@property (strong,nonatomic) UIImageView *rentouView;//人头图片
@property (strong,nonatomic) UIImageView *suoziView;//图片
@property (strong,nonatomic) UIImageView *shibieView;//识别码图片
@property (strong,nonatomic) UIView *view1;//第一条线
@property (strong,nonatomic) UIView *view2;//第二条线
@property (strong,nonatomic) UIView *view3;//第三条线
@property (strong,nonatomic) UIButton *logBtn;//登陆按钮
@property (strong,nonatomic) NSString *nameStr;//第二条线
@property (strong,nonatomic) NSString *passStr;//第三条线
@property (strong,nonatomic) NSString *shibieStr;//登陆按钮
@property (strong,nonatomic) MainViewController *Main;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *customBackgournd = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Scree_width,Scree_height)];
    customBackgournd.image=[UIImage imageNamed:@"bj01@1x"];
    [self.view addSubview:customBackgournd];
    
    [customBackgournd  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
  


   
    
    
    
    [self logIng];
}
-(void)logIng{
    //头像
    _HeadView = [[UIImageView alloc]init];
    [_HeadView setImage:[UIImage imageNamed:@"tx100.png"]];
    _HeadView.backgroundColor = [UIColor whiteColor];
    _HeadView.layer.masksToBounds = YES;
    _HeadView.layer.cornerRadius = 50.0;//设置圆角
    [self.view addSubview:_HeadView];
    [_HeadView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.left.equalTo(self.view.mas_centerX).offset(-50);
        make.right.equalTo(self.view.mas_centerX).offset(50);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    
    //人头图片
    _rentouView = [[UIImageView alloc]init];
    [_rentouView setImage:[UIImage imageNamed:@"yonghuming"]];
    [self.view addSubview:_rentouView];
    [_rentouView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(50);
        make.top.equalTo(_HeadView.mas_bottom).offset(50);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    //用户名输入框
    _NameText = [[UITextField alloc]init];
    _NameText.delegate = self;
    _NameText.keyboardType = UIKeyboardTypeNumberPad;//键盘格式
    _NameText.backgroundColor = [UIColor clearColor];
    _NameText.placeholder = @"用户名";
    [self.view addSubview:_NameText];
    [_NameText
     mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(_HeadView.mas_bottom).offset(50);
         make.left.equalTo(_rentouView.mas_right).offset(10);
         make.right.equalTo(self.view.mas_right).offset(-50);
         make.height.mas_equalTo(32);
     }];
    
    //第一条线 188  176 195
    _view1 = [[UIView alloc]init];
    _view1.backgroundColor = [UIColor RGBview];
    [self.view addSubview:_view1];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.top.equalTo(_NameText.mas_bottom).offset(3);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.mas_equalTo(2);
    }];
    //图片
    _suoziView = [[UIImageView alloc]init];
    [_suoziView setImage:[UIImage imageNamed:@"yonghumima"]];
    [self.view addSubview:_suoziView];
    [_suoziView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rentouView.mas_left).offset(0);
        make.top.equalTo(_view1.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    //密码
    _PassText = [[UITextField alloc]init];
    _PassText.delegate = self;
    _PassText.backgroundColor = [UIColor clearColor];
    _PassText.placeholder = @"用户密码";
    [self.view addSubview:_PassText];
    [_PassText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_suoziView.mas_top).offset(0);
        make.left.equalTo(_NameText.mas_left).offset(0);
        make.right.equalTo(_NameText.mas_right).offset(0);
        make.height.mas_equalTo(32);
    }];
    
    
    //第二条线
    _view2 = [[UIView alloc]init];
    _view2.backgroundColor = [UIColor RGBview];
    [self.view addSubview:_view2];
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view1.mas_left).offset(0);
        make.top.equalTo(_PassText.mas_bottom).offset(3);
        make.right.equalTo(_view1.mas_right).offset(0);
        make.height.mas_equalTo(2);
    }];
    //识别码图片
    _shibieView = [[UIImageView alloc]init];
    [_shibieView setImage:[UIImage imageNamed:@"shibiema"]];
    [self.view addSubview:_shibieView];
    [_shibieView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_suoziView.mas_left).offset(0);
        make.top.equalTo(_view2.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    //识别码
    _valiText = [[UITextField alloc]init];
    _valiText.delegate = self;
    _valiText.backgroundColor = [UIColor clearColor];
    _valiText.placeholder = @"识别码";
    [self.view addSubview:_valiText];
    [_valiText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shibieView.mas_top).offset(0);
        make.left.mas_equalTo(_PassText.mas_left).offset(0);
        make.right.mas_equalTo(_PassText.mas_right).offset(0);
        make.height.mas_equalTo(32);
    }];
    
    //第三条线
    _view3 = [[UIView alloc]init];
    _view3.backgroundColor = [UIColor RGBview];
    [self.view addSubview:_view3];
    [_view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view1.mas_left).offset(0);
        make.top.equalTo(_valiText.mas_bottom).offset(3);
        make.right.equalTo(_view1.mas_right).offset(0);
        make.height.mas_equalTo(2);
    }];
    //登陆按钮
    _logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_logBtn setBackgroundImage:[UIImage imageNamed:@"denglutioao"] forState:UIControlStateNormal];
    _logBtn.layer.masksToBounds = YES;
    _logBtn.layer.cornerRadius = 25.0;//设置圆角
    [_logBtn addTarget:self action:@selector(TouchLog:)forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:_logBtn];
    [_logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_view3.mas_bottom).offset(40);
        make.left.mas_equalTo(_view1.mas_left).offset(0);
        make.right.mas_equalTo(_view1.mas_right).offset(0);
        make.height.mas_equalTo(60);
    }];
  [_NameText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
  [_PassText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_valiText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)textFieldDidChange :(UITextField *)textField{
    if (textField==_NameText) {
        
        _nameStr= textField.text;
       
    }else if (textField ==_PassText){
        _passStr= textField.text;

    }else if (textField==_valiText){
        _shibieStr= textField.text;

    }
}






-(void)TouchLog:(UIButton*)sender{

    if (_nameStr==nil&& _shibieStr==nil&&_passStr==nil) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请将信息填写完整" andInterval:1.0];
        return;
    }else if (_passStr==nil){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请输入密码" andInterval:1.0];
        return;

      ;
    }else if (_nameStr==nil){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请输入电话号码" andInterval:1.0];
        return;
    }else if (_shibieStr==nil){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请输入识别码" andInterval:1.0];
        return;
    }else{
        

    NSString *urlStr =[NSString stringWithFormat:@"%@user/login.action",KURLHeader];
    NSString *pastr =[ZXDNetworking encryptStringWithMD5:_passStr];
    NSString *shiStr =[ZXDNetworking encryptStringWithMD5:_shibieStr];
     NSString *ltokenStr =[NSString stringWithFormat:@"%@%@%@%@",pastr,shiStr, [USER_DEFAULTS  objectForKey:@"Ltoken"],logokey];
    NSString *ltoken=[ZXDNetworking encryptStringWithMD5:ltokenStr];
    NSDictionary *info=@{@"mobile":_nameStr,@"ltoken":ltoken,@"password":pastr,@"udid":shiStr,@"appkey":logokey};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            //APPKey
            NSString *ApLtokenStr=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"token"]];
            //用户ID
            NSString *userStr=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"id"]];
            
         //  角色
            NSString * roleId=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"roleId"]];
            //公司ID
                NSString * companyinfoid=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"companyinfoid"]];
            //用户名字
            NSString * name=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"name"]];
            //用户手机号 phone
            [USER_DEFAULTS setObject:_nameStr forKey:@"phone"];
            [USER_DEFAULTS setObject:roleId forKey:@"roleId"];
            [USER_DEFAULTS setObject:companyinfoid forKey:@"companyinfoid"];
            [USER_DEFAULTS setObject:ApLtokenStr forKey:@"token"];
            [USER_DEFAULTS  setObject:userStr forKey:@"userid"];
            [USER_DEFAULTS setObject:name forKey:@"name"];
            
            [ZxdObject rootController];
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]){
             [ELNAlerTool showAlertMassgeWithController:self andMessage:@"密码或识别码错误" andInterval:1.0];
        }
      
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
  
    
  }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField==_NameText) {
        _view1.backgroundColor=[UIColor RGBNav];
        _view2.backgroundColor = [UIColor RGBview];
        _view3.backgroundColor = [UIColor RGBview];
    } else if (textField==_PassText) {
         _view2.backgroundColor=[UIColor RGBNav];
        _view1.backgroundColor = [UIColor RGBview];
        _view3.backgroundColor = [UIColor RGBview];
    } else {
         _view3.backgroundColor=[UIColor RGBNav];
        _view2.backgroundColor = [UIColor RGBview];
        _view1.backgroundColor = [UIColor RGBview];
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==_NameText){
        if (range.location==10) {
            _nameStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSString *urlStr =[NSString stringWithFormat:@"%@user/queryicon.action",KURLHeader];
            NSLog(@"%@",_nameStr);
            NSDictionary *info=@{@"mobile":_nameStr};
            [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
                if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                NSString *LtokenStr=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Ltoken"]];
                  NSString *logoImage=[NSString stringWithFormat:@"%@%@",KURLImageUrl,[responseObject valueForKey:@"images"]];
            
                [_HeadView sd_setImageWithURL:[NSURL URLWithString:logoImage] placeholderImage:[UIImage  imageNamed:@"tx100"]];
            [USER_DEFAULTS  setObject:logoImage forKey:@"logoImage"];
            [USER_DEFAULTS  setObject:LtokenStr forKey:@"Ltoken"];
                }
            } failure:^(NSError *error) {
                
            } view:self.view MBPro:NO];
        }else if (range.location >= 11){
        return NO;
        }
    
    
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
