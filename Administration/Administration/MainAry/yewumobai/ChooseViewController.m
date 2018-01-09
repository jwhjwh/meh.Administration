//
//  ChooseViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/12/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ChooseViewController.h"
#import "FillinfoViewController.h"
@interface ChooseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *infonTableview;
    
}
@property (strong,nonatomic) NSMutableArray *InterNameAry;
@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择部门";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    //shop/selectDepartmentname
    /*
     选择职位 多个部门---->>shop/selectDepartmentname(CompanyInfoId,DepartmentID,RoleId)------>>> shop/selectRegion（CompanyInfoId,DepartmentID,RoleId,userid） 一个部门------>>>shop/selectRegion（CompanyInfoId,DepartmentID,RoleId,userid）
     */
    [self nfnetworking];
    [self UI];
}
-(void)UI{
    NSString* phoneModel = [UIDevice devicePlatForm];
    infonTableview =[[UITableView alloc]init];
    infonTableview.delegate = self;
    infonTableview.dataSource = self;
    [self.view addSubview: infonTableview];
    [ZXDNetworking setExtraCellLineHidden:infonTableview];
    
    [infonTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
            make.top.mas_equalTo(self.view.mas_top).offset(90);
        }else{
            make.top.mas_equalTo(self.view.mas_top).offset(70);
        }
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [[NSMutableDictionary alloc]init];
    dic = _InterNameAry[indexPath.row];
    cell.textLabel.text = dic[@"departmentName"];
    return cell;
}
-(void)nfnetworking{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/selectDepartmentname.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    //CompanyInfoId,DepartmentID,RoleId
    dic = @{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"CompanyInfoId":compid,@"DepartmentID":self.DepartmentID,@"RoleId":self.strId};
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) { 
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            _InterNameAry =[[NSMutableArray alloc]init];
             NSArray *array=[responseObject valueForKey:@"list"];
            for (NSDictionary *dic in array) {
                [_InterNameAry addObject:dic];
            }
            [infonTableview reloadData];
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
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有部门" andInterval:1.0];
           
            
            return;
            
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [[NSMutableDictionary alloc]init];
    dic = _InterNameAry[indexPath.row];
      FillinfoViewController *fillVC=[[FillinfoViewController alloc]init];
      fillVC.points = self.strId;
    fillVC.depant = dic[@"departmentID"];
     [self.navigationController pushViewController:fillVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _InterNameAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    
    return 1;
}

@end
