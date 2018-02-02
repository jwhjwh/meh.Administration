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
@property (nonatomic,weak)UIPickerView *pickView;
@property (nonatomic,strong)NSMutableArray *arrayP;
@property (nonatomic,strong)NSMutableArray *arrayC;
@property (nonatomic,strong)NSMutableArray *arrayT;

@property (nonatomic,strong)NSString *prostr;
@property (nonatomic,strong)NSString *citystr;
@property (nonatomic,strong)NSString *countstr;


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
    
    _prostr =[[NSString alloc]init];
    _citystr =[[NSString alloc]init];
    _countstr =[[NSString alloc]init];
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
        
            
            for (NSDictionary *dic in array) {
                NSData *jsonData = [dic[@"province"] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary* dictt= [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                [provinceName addObject:dictt];
            }
//
            [_dict setValue:provinceName forKey:@"province"];
            
            self.arrayP = self.dict[@"province"];
            if ([self.arrayP[0][@"cityList"][0][@"cityName"] isEqualToString:@"全部"]) {
                self.arrayC = [[self getList:self.arrayP[0][@"provinceName"]]mutableCopy];
            }
            
            self.arrayC = self.arrayP[0][@"cityList"];
            if (self.arrayC.count==0||[self.arrayC[0][@"cityName"] isEqualToString:@"全部"]) {
                self.arrayC = [[self getList:self.arrayP[0][@"provinceName"]]mutableCopy];
                
            }
            self.arrayT = self.arrayC[0][@"countyList"];
           if (![self.arrayT[0]isKindOfClass:[NSDictionary class]]) {
               if (self.arrayT.count==0||[self.arrayC[0][@"countyList"][0] isEqualToString:@"全部"]) {
                   self.arrayT = [[self getList:self.arrayC[0][@"cityName"]]mutableCopy];
                   _countstr = self.arrayT[0][@"name"];
               }else{
                   _countstr = self.arrayT[0];
               }
           }else{
               if (self.arrayT.count==0||[self.arrayC[0][@"countyList"][0][@"cityName"] isEqualToString:@"全部"]) {
                   self.arrayT = [[self getList:self.arrayC[0][@"cityName"]]mutableCopy];
                   _countstr = self.arrayT[0][@"name"];
               }else{
                   _countstr = self.arrayT[0];
               }
           }
            
            _prostr = self.arrayP[0][@"provinceName"];
            _citystr = self.arrayC[0][@"cityName"];
            
            
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
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"没有分配负责区域" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [self nssUI];
                [self initDataFromJson];
            };
            [alertView showMKPAlertView];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(NSArray *)getList:(NSString *)name{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Respon_date" ofType:@"json"];
    NSData *cityData = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *dictdata = [NSJSONSerialization JSONObjectWithData:cityData options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *arrayProvince = dictdata[@"province"];
    NSArray *array = [NSArray array];
    for (NSDictionary *dict in arrayProvince) {
        
        if ([dict[@"provinceName"]isEqualToString:name]) {
            array = dict[@"cityList"];
        }else{
            NSArray *array1 = dict[@"cityList"];
            for (NSDictionary *dict1 in array1) {
                if ([dict1[@"cityName"]isEqualToString:name]) {
                    array =  dict1[@"countyList"];
                }
                
            }
        }
    }
    return array;

}

-(void)initDataFromJson
{

    NSString *dataString = [[NSBundle mainBundle]pathForResource:@"Respon_date" ofType:@"json"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:dataString];
    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.arrayP = dict[@"province"];
    self.arrayC = self.arrayP[0][@"cityList"];
    self.arrayT = self.arrayP[0][@"cityList"][0][@"countyList"];
    _prostr = self.arrayP[0][@"provinceName"];
    _citystr = self.arrayC[0][@"provinceName"];
    _countstr = self.arrayT[0][@"name"];
    [self.pickView reloadAllComponents];
    [self.pickView selectRow:0 inComponent:0 animated:YES];
    [self.pickView selectRow:0 inComponent:1 animated:YES];
    [self.pickView selectRow:0 inComponent:2 animated:YES];
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
    self.pickView = pickView;
    
    
    
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
    [self initDataFromJson];
}
-(void)rightItemAction:(UIBarButtonItem*)sender{
    NSMutableString  *CityStr = [NSMutableString stringWithFormat:@"%@%@%@",_prostr,_citystr,_countstr];
     self.returnTextBlock(CityStr);
    [self.navigationController popViewControllerAnimated:YES];
    
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
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *lbl = (UILabel *)view;
    if (lbl == nil) {
        lbl = [[UILabel alloc]init];
        lbl.font = [UIFont systemFontOfSize:15];
        lbl.textAlignment = NSTextAlignmentCenter;
        [lbl setTextAlignment:0];
    }
        [lbl setBackgroundColor:[UIColor clearColor]];
        lbl.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        
        return lbl;
    
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
        if ([self.arrayT[row]isKindOfClass:[NSDictionary class]]) {
            return self.arrayT[row][@"name"];
        }else
        {
            return self.arrayT[row];
        }
        
        
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (component==0) {
        self.arrayC = self.arrayP[row][@"cityList"];
        self.arrayT = self.arrayC[0][@"countyList"];
        _prostr = self.arrayP[row][@"provinceName"];
        
        if (self.arrayC.count==0||[self.arrayC[0][@"cityName"]isEqualToString:@"全部"]) {
            self.arrayC = [[self getList:self.arrayP[row][@"provinceName"]]mutableCopy];
            self.arrayT = self.arrayC[0][@"countyList"];
           _countstr = self.arrayT[0][@"name"];
            _citystr = self.arrayC[0][@"cityName"];
        }else{
            if ([self.arrayT[0]isKindOfClass:[NSDictionary class]]) {
                _countstr = self.arrayT[0][@"name"];//
            }else{
                _countstr = self.arrayT[0];
            }
            
            _citystr = self.arrayC[0][@"cityName"];
        }
        
        if (![self.arrayT[0]isKindOfClass:[NSDictionary class]]) {
            if (self.arrayT.count==0||[self.arrayT[0]isEqualToString:@"全部"]) {
                self.arrayT = [[self getList:self.arrayC[0][@"cityName"]]mutableCopy];
            }
        }
        
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else if (component==1){
        self.arrayT = self.arrayC[row][@"countyList"];
        _citystr = self.arrayC[row][@"cityName"];
        if ([self.arrayT[0]isKindOfClass:[NSDictionary class]]) {
            self.arrayT = self.arrayC[row][@"countyList"];
            _countstr = self.arrayT[0][@"name"];
        }else
        {
            if (self.arrayT.count==0||[self.arrayT[0]isEqualToString:@"全部"]) {
                self.arrayT = [[self getList: self.arrayC[row][@"cityName"]]mutableCopy];
                _countstr = self.arrayT[0][@"name"];
            }else{
                _countstr = self.arrayT[0];
            }
        }
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else if (component == 2){
        
        [pickerView selectRow:row inComponent:2 animated:YES];
        
        if ([self.arrayT[0]isKindOfClass:[NSDictionary class]]) {
            _countstr = self.arrayT[row][@"name"];
        }else{
            _countstr = self.arrayT[row];
        }
    }
    
    NSLog(@"%@--%@--%@",_prostr,_citystr,_countstr);
}

@end
