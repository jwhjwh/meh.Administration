//
//  UpdateIntendedViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/10/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "UpdateIntendedViewController.h"
#import "Brandmodle.h"
@interface UpdateIntendedViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
}
@property (nonatomic,retain)NSMutableArray *arr;
@end

@implementation UpdateIntendedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"品牌部";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    self.hidesBottomBarWhenPushed = YES;
    [self InterTableUI];
     [self getNetworkData];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)InterTableUI
{
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,20,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
    [ZXDNetworking setExtraCellLineHidden:infonTableview];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(_arr.count>0){
        return 1;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor =  GetColor(201, 201, 201, 1);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arr.count;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    view.backgroundColor =GetColor(201, 201, 201, 1);
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{   if(_arr.count>0){
    return 2;
}
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
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
    Brandmodle *modld = _arr[indexPath.row];
    cell.textLabel.text =modld.departmentName;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Brandmodle *modld = _arr[indexPath.row];
    //提交品牌部
    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"温馨提示" message:@"是否提交到该部门" sureBtn:@"确认" cancleBtn:@"取消"];
    alertView.resultIndex = ^(NSInteger index){
        NSLog(@"%ld",index);
        if(index == 2){
            //提交部门
            NSString *uStr =[NSString stringWithFormat:@"%@manager/updateIntended.action",KURLHeader];
            NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
            NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
            NSDictionary *dic = [[NSDictionary alloc]init];
            dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"intendedId":self.intendedId,@"DepartmentId":modld.departmentID,@"shopId":self.shopId};
            [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
                if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"提交成功" sureBtn:@"确认" cancleBtn:nil];
                    alertView.resultIndex = ^(NSInteger index){
                        [self.navigationController popViewControllerAnimated:YES];
                    };
                    [alertView showMKPAlertView];
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
                    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
                    alertView.resultIndex = ^(NSInteger index){
                        [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                        ViewController *loginVC = [[ViewController alloc] init];
                        UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                        [self presentViewController:loginNavC animated:YES completion:nil];
                    };
                    [alertView showMKPAlertView];
                }else if([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]){
                     [ELNAlerTool showAlertMassgeWithController:self andMessage:@"提交失败" andInterval:1.0];
                }else if([[responseObject valueForKey:@"status"]isEqualToString:@"0003"]){
                     [ELNAlerTool showAlertMassgeWithController:self andMessage:@"您没有权限" andInterval:1.0];
                }
            } failure:^(NSError *error) {
                
            } view:self.view MBPro:YES];
            
        }
    };
    [alertView showMKPAlertView];
}
-(void)getNetworkData{
    //查询品牌部
    NSString *uStr =[NSString stringWithFormat:@"%@manager/queryUserManagement.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
        dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"RoleId":_roid,@"Num":_number};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *arr = [responseObject valueForKey:@"list"];
            _arr=[NSMutableArray array];
            for (NSDictionary *dic in arr) {
                Brandmodle *modld=[[Brandmodle alloc]init];
                [modld setValuesForKeysWithDictionary:dic];
                [_arr addObject:modld];
            }
            
            [infonTableview reloadData];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到更多品牌信息" andInterval:1.0];
            [infonTableview addEmptyViewWithImageName:@"" title:@"没有设定部门" Size:20.0];
            infonTableview.emptyView.hidden = NO;
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
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时, " sureBtn:@"确认" cancleBtn:nil];
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
