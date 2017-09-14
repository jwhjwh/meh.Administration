//
//  ViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewController.h"
#import<BaiduMapAPI_Location/BMKLocationService.h>

#import<BaiduMapAPI_Search/BMKGeocodeSearch.h>

#import<BaiduMapAPI_Map/BMKMapComponent.h>

#import<BaiduMapAPI_Search/BMKPoiSearchType.h>
#import "JinnLockViewController.h"
@interface ViewController ()<UITextFieldDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService *_locService;  //定位
    
    BMKGeoCodeSearch *_geocodesearch; //地理编码主类，用来查询、返回结果信息
}
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
@property (nonatomic, assign) CGFloat longitude;  // 经度

@property (nonatomic, assign) CGFloat latitude; // 纬度
@property (nonatomic,retain)NSString *ctiy; //城市信息
@property (nonatomic, assign) BOOL isGeoSearch;
@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

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
   [NSTimer scheduledTimerWithTimeInterval:900 target:self selector:@selector(getResults)userInfo:nil repeats:YES];
    [self logIng];
  
}
-(void)getResults{
 [self startLocation];
 
}
- (void)startLocation
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    //启动LocationService
    [_locService startUserLocationService];
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self;
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
   // NSLog(@"当前位置信息：didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //地理反编码
    _latitude=userLocation.location.coordinate.latitude;
    _longitude=userLocation.location.coordinate.longitude;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    
    if(flag){
        
        NSLog(@"反geo检索发送成功");
        
        [_locService stopUserLocationService];
        
    }else{
        
        NSLog(@"反geo检索发送失败");
    }
}
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error

{
    //NSLog(@"address:%@----%@",result.addressDetail,result.address);
    _ctiy=[NSString stringWithFormat:@"%@",result.address];
    //找到了当前位置城市后就关闭服务
    [_locService stopUserLocationService];
    //addressDetail:     层次化地址信息
    
    //address:    地址名称
    
    //businessCircle:  商圈名称
    
    // location:  地址坐标
    
    //  poiList:   地址周边POI信息，成员类型为BMKPoiInfo
    [self huoqudiliweizhi];
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
   placeholder(_NameText);

    [_NameText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
    _PassText.keyboardType = UIKeyboardTypeASCIICapable;
    _PassText.secureTextEntry = YES;
    placeholder(_PassText);

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
    placeholder(_valiText);
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
        if (_nameStr.length==11) {
            NSString *urlStr =[NSString stringWithFormat:@"%@user/queryicon.action",KURLHeader];
     
            NSDictionary *info=@{@"mobile":_nameStr};
            [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
                if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                    NSString *LtokenStr=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Ltoken"]];
                    NSString *logoImage=[NSString stringWithFormat:@"%@%@",KURLHeader,[responseObject valueForKey:@"images"]];
                 
                    [_HeadView sd_setImageWithURL:[NSURL URLWithString:logoImage] placeholderImage:[UIImage  imageNamed:@"tx100"]options:EMSDWebImageRefreshCached];
                    
                    [USER_DEFAULTS  setObject:logoImage forKey:@"logoImage"];
                    [USER_DEFAULTS  setObject:LtokenStr forKey:@"Ltoken"];
                    
                }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"输入用户名不存在" andInterval:1.0];
                }
            } failure:^(NSError *error) {
                
            } view:self.view MBPro:NO];
        }
      
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
            //uuid 环信账号
            NSString *uuid=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"uuid"]];
         //  角色
            NSString * roleId=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"roleId"]];
            //公司ID
                NSString * companyinfoid=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"companyinfoid"]];
            //用户名字
            NSString * name=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"name"]];
            
            //用户所有职位
            NSString *roleIds = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"roleIds"]];
            //用户手机号 phone
            [USER_DEFAULTS setObject:_nameStr forKey:@"phone"];
            [USER_DEFAULTS setObject:roleId forKey:@"roleId"];
            [USER_DEFAULTS setObject:companyinfoid forKey:@"companyinfoid"];
            [USER_DEFAULTS setObject:ApLtokenStr forKey:@"token"];
            [USER_DEFAULTS  setObject:userStr forKey:@"userid"];
            [USER_DEFAULTS setObject:name forKey:@"name"];
            [USER_DEFAULTS  setObject:_shibieStr forKey:@"udid"];
            [USER_DEFAULTS  setObject:@"1" forKey:@"guiiiii"];
            [USER_DEFAULTS  setObject:uuid forKey:@"uuid"];
            [USER_DEFAULTS  setObject:roleIds forKey:@"roleIds"];
            
            [USER_DEFAULTS setObject:[responseObject valueForKey:@"roleIds"] forKey:@"myRole"];
            [ShareModel shareModel].roleID = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"roleId"]];
            
//            EMError *error = [[EMClient sharedClient] registerWithUsername:@"8001" password:@"111111"];
//            if (error==nil) {
//                NSLog(@"注册成功");
//            }
    
            if ([JinnLockTool isGestureUnlockEnabled])
            {
                JinnLockViewController *lockViewController = [[JinnLockViewController alloc] initWithDelegate:nil
                                                                                                         type:JinnLockTypeVerify
                                                                                                   appearMode:JinnLockAppearModePresent];
                  UIWindow *window = [UIApplication sharedApplication].delegate.window;
              window.rootViewController =lockViewController;
            }else{
                
                [ZxdObject rootController];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [self startLocation];
                [[EMClient sharedClient] loginWithUsername:uuid
                                                  password:@"123456"
                                                completion:^(NSString *aUsername, EMError *aError) {
                                                    
                                                    if (!aError) {
//                            NSString *userOpenId = @"zhangchenchong";
//                            NSString *nickName =[USER_DEFAULTS objectForKey:@"name"];// 用户昵称
////                            NSString *avatarUrl =[USER_DEFAULTS objectForKey:@"logoImage"];// 用户头像（绝对路径）
//                            NSString *avatarUrl = @"http://avatar.csdn.net/E/8/5/2_duruiqi_fx.jpg";// 用户头像（绝对路径）
//                                // 登录成功后，如果后端云没有缓存用户信息，则新增一个用户
//                                [UserWebManager createUser:userOpenId nickName:nickName avatarUrl:avatarUrl];
                                //设置是否自动登录
                                                        NSLog(@"登录成功");
                                                        
                                [[EMClient sharedClient].options setIsAutoLogin:YES];
                                                    } else {
                                                        NSLog(@"登录失败");
                                                    }
                                                
                                                }];
            });
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"输入内容有误,请重新输入" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            
             [ELNAlerTool showAlertMassgeWithController:self andMessage:@"登录超时,请重新登录"
                                            andInterval:1.0];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0004"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"用户名或密码错误" andInterval:1.0];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0005"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"您的公司已冻结" andInterval:1.0];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0055"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"您的账号已冻结" andInterval:1.0];
        }
      
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
  
    
  }
}

-(void)huoqudiliweizhi{
    NSString *urlStr =[NSString stringWithFormat:@"%@location/addLoc.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *companyid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    if ([NSString stringWithFormat:@"%f",_latitude].length>0&&[NSString stringWithFormat:@"%f",_latitude].length>0&&_ctiy.length>0&&[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"token"]].length>0) {
        NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
        NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"log":[NSString stringWithFormat:@"%f",_longitude],@"lat":[NSString stringWithFormat:@"%f",_latitude],@"comid":companyid,@"address":_ctiy};
        [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:NO];
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
       if (range.location >= 11){
        return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
