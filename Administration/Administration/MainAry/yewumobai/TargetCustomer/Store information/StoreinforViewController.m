//
//  StoreinforViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/10/31.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "StoreinforViewController.h"
#import "StoresViewController.h"
#import "BossViewController.h"
#import "shopAssistantViewController.h"
#import "storesDepartment.h"
@interface StoreinforViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *tableView;

@property (nonatomic ,retain)NSArray *nameArrs;


@end

@implementation StoreinforViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleName;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    _nameArrs = @[@"门店信息",@"老板信息",@"店员信息",@"顾客信息"];
    
    if ([_shopifot isEqualToString:@"1"]) {
        UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"合作" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightitem;
    }
    [self addViewremind];
}
-(void)rightItemAction:(UIBarButtonItem *)btn{
    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"是否确定为合作" sureBtn:@"确认" cancleBtn:@"取消"];
    alertView.resultIndex = ^(NSInteger index){
        if (index == 2) {
            NSString *uStr =[NSString stringWithFormat:@"%@stores/updateStoreStateid.action",KURLHeader];
            NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
            NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
            NSDictionary *dic = [[NSDictionary alloc]init];
            dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Storeid":self.shopId};
            [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
                if([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]){
                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"升级合作客户失败" andInterval:1.0];
                }else if([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]){
                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"升级合作客户成功" andInterval:1.0];
                    
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
            } failure:^(NSError *error) {
                
            } view:self.view MBPro:YES];
        }
    };
    [alertView showMKPAlertView];
    
}
-(void)addViewremind{
    self.tableView= [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    NSString* phoneModel = [UIDevice devicePlatForm];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        self.tableView.frame =CGRectMake(0,88,self.view.bounds.size.width,self.view.bounds.size.height-50);
    }else{
        self.tableView.frame =CGRectMake(0,65,self.view.bounds.size.width,self.view.bounds.size.height-50);
    }
    self.tableView.dataSource=self;
    self.tableView.delegate =self;
    self.tableView.scrollEnabled =NO; //设置tableview 不能滚动
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.tableView setTableFooterView:footView];
    UILabel *deparname = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width, 30)];
    
    
    
    deparname.font = [UIFont systemFontOfSize:14];
    [footView addSubview:deparname];
    
    UIButton *tijiaobm = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width-40, 40)];
    
    tijiaobm.layer.masksToBounds = YES;
    [tijiaobm.layer setBorderColor:[UIColor blueColor].CGColor];
    tijiaobm.layer.cornerRadius = 5.0;
    tijiaobm.layer.borderWidth = 1.0f;
      [tijiaobm setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [tijiaobm addTarget:self action:@selector(TouchLog:)forControlEvents: UIControlEventTouchUpInside];
    
    if ([self.shopname isEqualToString:@"1"]) {
        
    }else{
        [footView addSubview:tijiaobm];
        if (self.DepartmentName == nil) {
            deparname.text = [NSString stringWithFormat:@"当前状态:        未提交部门"];
            [tijiaobm setTitle:@"提交部门" forState:UIControlStateNormal];
        }else{
            deparname.text = [NSString stringWithFormat:@"当前状态:        已提交到%@",self.DepartmentName];
            [tijiaobm setTitle:@"修改部门" forState:UIControlStateNormal];
        }
    }
    
}
-(void)TouchLog:(UIButton *)btn{
    
    storesDepartment *storesVC = [[storesDepartment alloc]init];
    storesVC.shopId = self.shopId;
    storesVC.Storeid = self.Storeid;
    [self.navigationController pushViewController:storesVC animated:YES];
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameArrs.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"gameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }
    /**
     *  单元格的选中类型一定不能设置为 UITableViewCellSelectionStyleNone，如果加上这一句，全选勾选不出来
     */
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *tlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, cell.width, 30)];
    tlelabel.text = _nameArrs[indexPath.row];
    [cell addSubview:tlelabel];

    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
            switch (indexPath.row) {
                case 0:{
                    //门店信息
                   
                    StoresViewController *storesVC = [[StoresViewController alloc]init];
                    storesVC.isend = self.isend;
                    storesVC.StoreId = self.Storeid;
                    storesVC.strId = self.strId;
                    storesVC.isofyou = @"1";
                    storesVC.shopname = self.shopname;
                    [self.navigationController pushViewController:storesVC animated:YES];
                }
                    break;
                case 1:{
                    //老板信息
                    BossViewController *bossVC = [[BossViewController alloc]init];
                    bossVC.strId = self.strId;
                    bossVC.Storeid = self.shopId;
                    bossVC.shopname  = self.shopname;
                    [self.navigationController pushViewController:bossVC animated:YES];
                }
                    break;
                case 2:{
                    //店员信息
                    shopAssistantViewController *SAVC = [[shopAssistantViewController alloc]init];
                    SAVC.shopid = self.shopId;
                    SAVC.strId = self.strId;
                    SAVC.titleStr = @"店员信息";
                    SAVC.shopname = self.shopname;
                     [self.navigationController pushViewController:SAVC animated:YES];
                }break;
                case 3:
                {
                    //顾客信息
                    shopAssistantViewController *SAVC = [[shopAssistantViewController alloc]init];
                    SAVC.shopid = self.shopId;
                    SAVC.strId = self.strId;
                    SAVC.titleStr = @"顾客信息";
                    SAVC.shopname = self.shopname;
                    [self.navigationController pushViewController:SAVC animated:YES];
                }
                    
                    break;
                default:
                    break;
            }
        
    
}
-(void)notpushe{
    
//
//        storesVC.storeName = _StoreName;
//        storesVC.province = _Province;
//        storesVC.city =_City;
//        storesVC.county = _County;
//        storesVC.address = _Address;
//        storesVC.rideinfo = _RideInfo;
//        storesVC.area = _Area;
//        storesVC.brandbusiness = _BrandBusiness;
//        storesVC.intentionbrand = _IntentionBrand;
//        storesVC.berths = _Berths;
//        storesVC.valinumber = _ValidNumber;
//        storesVC.staffnumber = _StaffNumber;
//        storesVC.jobexpires = _JobExpires;
//        storesVC.problems = _Problems;
//
//        storesVC.strId = self.strId;
//
    
}

-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
