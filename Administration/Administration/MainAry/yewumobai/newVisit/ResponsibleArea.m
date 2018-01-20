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
    NSMutableArray *provinceName;
}
@property (nonatomic,strong)NSMutableDictionary *dict;

@property (nonatomic,strong)NSMutableArray *arrayP;
@property (nonatomic,strong)NSMutableArray *arrayC;
@property (nonatomic,strong)NSMutableArray *arrayT;
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
            
            provinceName = [[NSMutableArray alloc]init];//
             _dict = [[NSMutableDictionary alloc]init];
            
            NSMutableArray *cityName = [[NSMutableArray alloc]init];//
           NSMutableArray *proary =[[NSMutableArray alloc]init];
            for (NSDictionary *dic in array) {
                NSData *jsonData = [dic[@"province"] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary* dictt= [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                [provinceName addObject:dictt];
                
               [proary addObject:dictt[@"provinceName"]];
                
                [cityName addObject:dictt[@"cityList"]];
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
               
                
                
                NSString *propath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"plist"];
                NSArray *proarray1 = [[NSArray alloc] initWithContentsOfURL:[NSURL fileURLWithPath:propath]];
                NSMutableArray *proviceMutableArray = [NSMutableArray array];
                NSMutableArray *proviceid = [NSMutableArray array];
                for (NSDictionary *prodic in proarray1) {
                    [proviceMutableArray addObject:prodic[@"name"]];
                    [proviceid addObject:prodic[@"proID"]];
                }
                NSString *citypath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
                NSArray *cityarray1 = [[NSArray alloc] initWithContentsOfURL:[NSURL fileURLWithPath:citypath]];
                NSMutableArray *cityMutableArray = [NSMutableArray array];
                NSMutableArray *cityid = [NSMutableArray array];
                NSMutableArray *cityproid = [NSMutableArray array];
                for (NSDictionary *citydic in cityarray1) {
                    [cityMutableArray addObject:citydic[@"name"]];
                    [cityid addObject:citydic[@"cityID"]];
                    [cityproid addObject:citydic[@"proID"]];
                }
                
                
                NSString *areapath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
                 NSArray *areaarray1 = [[NSArray alloc] initWithContentsOfURL:[NSURL fileURLWithPath:areapath]];
                NSMutableArray *areaMutableArray = [NSMutableArray array];
                NSMutableArray *areaid = [NSMutableArray array];
                for (NSDictionary *areadic in areaarray1) {
                    [areaMutableArray addObject:areadic[@"name"]];
                    [areaid addObject:areadic[@"cityID"]];
                }
                 NSLog(@"%@--%@--%@",provinceName,cityNameary,countyList);
                
                
                /*
                 proviceMutableArray----省名
                 proviceid--------------省id
                 cityMutableArray-------市名
                 cityid-----------------市id
                 cityproid--------------市--省id
                 areaMutableArray-------区名
                 areaid-----------------区---市id
                 provinceName-----------请求的省名
                 cityNameary-----------------市名
                 countyList------------------区名
                 */
                
                
                for (int a = 0; a<cityNameary.count; a++) {
                    NSArray *cityary = cityNameary[a];
                    
                    for (int b =0; b<cityary.count; b++) {
                        if ([cityary[b] isEqualToString:@"全部"]) {
                            NSString *prostr =proary[a];
                            //找省的id
                            for (int c = 0; c<proviceMutableArray.count; c++) {
                                if ([prostr isEqualToString:proviceMutableArray[c]]) {
                                    //拿省id
                                    NSString *proidstr = proviceid[c];
                                    //根据省id 找全部的市
                                    for (int d=0; d<cityid.count; d++) {
                                        NSMutableArray *newcityary = [NSMutableArray array];
                                        if ([proidstr isEqualToString:cityid[d]]) {
                                            [newcityary addObject:cityMutableArray[d]];
                                            
                                        }
                                        
                                    }
                                }
                            }
                        }else{
                            
                        }
                    }
                }

        
                
            }
            [_dict setValue:provinceName forKey:@"province"];
            
            self.arrayP = self.dict[@"province"];
            self.arrayC = self.arrayP[0][@"cityList"];
            self.arrayT = self.arrayP[0][@"cityList"][0][@"countyList"];
            
             [self nssUI];
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
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
           
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
    
    UIPickerView *pickView = [[UIPickerView alloc] init];
    pickView.backgroundColor = GetColor(215, 215, 215, 1);
    pickView.frame = CGRectMake(0, 0, self.view.frame.size.width, 180);
    pickView.delegate = self;
    pickView.dataSource = self;
    [ba_ckView addSubview:pickView];
    
    
    
    
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
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return self.arrayP.count;
    }else if (component==1)
    {
        return self.arrayC.count;
    }else
    {
        return self.arrayT.count;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        NSDictionary *dict = self.arrayP[row];
        return dict[@"provinceName"];
    }else if(component==1)
    {
        NSDictionary *dict = self.arrayC[row];
        return dict[@"cityName"];
    }else
    {
        
        return self.arrayT[row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
        
        self.arrayC = self.arrayP[row][@"cityList"];
        self.arrayT = self.arrayC[0][@"countyList"];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }else if (component==1)
    {
        self.arrayT = self.arrayC[row][@"countyList"];
        [pickerView reloadComponent:2];
    }
}

@end
