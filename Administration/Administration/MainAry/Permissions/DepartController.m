//
//  DepartController.m
//  Administration
//
//  Created by zhang on 2017/4/26.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "DepartController.h"
#import "BrandsetController.h"
#import "OtherDeparController.h"
#import "branModel.h"
@interface DepartController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    NSInteger indexID;
}
@property (nonatomic,retain)NSMutableArray *arr;
@end

@implementation DepartController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"部门设置";
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
      branModel *modld = _arr[indexPath.row];
    cell.textLabel.text =modld.Name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        branModel *modld = _arr[indexPath.row];
        indexID = modld.Num.integerValue;
    if(indexID==1){
        //品牌部设置---市场
        BrandsetController *brandVC=[[BrandsetController alloc]init];
        brandVC.strNum=[NSString stringWithFormat:@"%ld",(long)indexID];
        [self.navigationController pushViewController:brandVC animated:YES];
    }else{
        OtherDeparController *brandVC=[[OtherDeparController alloc]init];
        brandVC.numstr=[NSString stringWithFormat:@"%ld",(long)indexID];
        brandVC.sting =[modld.Name substringToIndex:3];;
        [self.navigationController pushViewController:brandVC animated:YES];
    }
}
-(void)getNetworkData{
    NSString *uStr =[NSString stringWithFormat:@"%@manager/queryPositionSet.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
    
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *arr = [responseObject valueForKey:@"list"];
            _arr=[NSMutableArray array];
            for (NSDictionary *dic in arr) {
                branModel *modld=[[branModel alloc]init];
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
        
    }failure:^(NSError *error) {
        
    }view:self.view MBPro:YES];
    
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([infonTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [infonTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([infonTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [infonTableview setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
@end
