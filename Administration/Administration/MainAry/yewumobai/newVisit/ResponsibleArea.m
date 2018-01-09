//
//  ResponsibleArea.m
//  Administration
//
//  Created by 九尾狐 on 2017/12/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ResponsibleArea.h"

@interface ResponsibleArea ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *_pickerView;
    NSDictionary *_areaDic;
    NSMutableArray *_provinceArr;
    
}

@end

@implementation ResponsibleArea

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地区";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    [self nssUI];
    [self afnetworking];
}
-(void)afnetworking{
    
    NSString *uwStr =[NSString stringWithFormat:@"%@shop/selectRegion.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *RoleId=[NSString stringWithFormat:@"%@",self.points];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
      NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSDictionary *dic=[[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"DepartmentId":self.DepartmentId,@"RoleId":RoleId,@"userid":[USER_DEFAULTS  objectForKey:@"userid"]};
    [ZXDNetworking GET:uwStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"list"];
            
            NSMutableArray *provinceName = [[NSMutableArray alloc]init];
            NSMutableArray *cityName = [[NSMutableArray alloc]init];
            
           
            for (NSDictionary *dic in array) {
               
                
                NSData *jsonData = [dic[@"province"] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary* dict= [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                [provinceName addObject:dict[@"provinceName"]];
                [cityName addObject:dict[@"cityList"]];
            }
            NSMutableArray *countyList = [[NSMutableArray alloc]init];
             NSMutableArray *cityNameary = [[NSMutableArray alloc]init];
            
            for (int i =0; i<cityName.count; i++) {
                NSMutableArray *citymuary = cityName[i];
                NSMutableArray *cityoldary = [[NSMutableArray alloc]init];
                NSMutableArray *countyary = [[NSMutableArray alloc]init];
                for (NSDictionary *dict2 in citymuary) {
                    [cityoldary addObject:dict2[@"cityName"]];
                    
                    [countyary addObject:dict2[@"countyList"]];
                    
                }
                    [countyList addObject:countyary];
                    [cityNameary addObject:cityoldary];
            }
            
            
            NSLog(@"%@--%@--%@",provinceName,cityNameary,countyList);
            
            
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
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
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}


-(void)nssUI{
    NSString* phoneModel = [UIDevice devicePlatForm];
    UILabel *ResLabel = [[UILabel alloc]init];
    ResLabel.text = @"请选择负责的省市区(县)";
    ResLabel.font = [UIFont systemFontOfSize:15];
    ResLabel.textColor = [UIColor lightGrayColor];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        ResLabel.frame = CGRectMake(10, 88, self.view.frame.size.width, 40);
    }else{
        ResLabel.frame = CGRectMake(10, 70, self.view.frame.size.width, 40);
    }
    [self.view addSubview:ResLabel];
    
    UIView *ba_ckView = [[UIView alloc]init];
    ba_ckView.backgroundColor = GetColor(215, 215, 215, 1);
    ba_ckView.frame = CGRectMake(0, ResLabel.bottom, self.view.frame.size.width, 180);
    [self.view addSubview:ba_ckView];
    
    UIButton *co_deBtn = [[UIButton alloc]init];
    [co_deBtn setTitle:@"其他的省市区(县)" forState:UIControlStateNormal];
    co_deBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    co_deBtn.frame = CGRectMake(20, ba_ckView.bottom, self.view.frame.size.width-30, 40);
    [co_deBtn addTarget: self action: @selector(co_deBtn) forControlEvents: UIControlEventTouchUpInside];
    [co_deBtn setTitleColor:GetColor(81, 151, 250, 1) forState:UIControlStateNormal];
    co_deBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:co_deBtn];
    
}
-(void)co_deBtn{
    
}
-(void)rightItemAction:(UIBarButtonItem*)sender{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
