//
//  OtherDeparController.m
//  Administration
//
//  Created by zhang on 2017/5/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "OtherDeparController.h"
#import "AddotherController.h"
#import "EditotherController.h"
#import "DetaotherController.h"
#import "branModel.h"
@interface OtherDeparController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    NSInteger indexID;
}
@property(nonatomic,strong)NSMutableArray *daArr;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *indexArray;
@property (nonatomic,strong)NSArray *natureArr;
@property (nonatomic,strong)NSString *str;
@property(nonatomic,strong)NSMutableArray *ArrID;

@end

@implementation OtherDeparController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.str isEqualToString:@"1"]) {
        infonTableview.emptyView.hidden = YES;
        [self getNetworkData];
        self.str=@"0";
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_sting;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:(UIBarButtonItemStyleDone) target:self action:@selector(AddItem)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;

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
    if(_daArr.count>0){
        return 1;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor =  GetColor(201, 201, 201, 1);
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _daArr.count;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    view.backgroundColor =GetColor(201, 201, 201, 1);
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{   if(_daArr.count>0){
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
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _daArr[indexPath.row];
    return cell;
}
//编辑
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction * action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        [self delDepartStr:_ArrID[indexPath.row] IndexPath:indexPath];
    }];
    
    action1.backgroundColor = GetColor(206, 175,219 ,1);
    UITableViewRowAction * action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //Action 2
        EditotherController * EditVC=[[EditotherController alloc]init];
        EditVC.nameStr = _daArr[indexPath.row];
        EditVC.BarandID=[NSString stringWithFormat:@"%@",_ArrID[indexPath.row]];
        EditVC.String=^(NSString *str){
            self.str=@"1";
        };
        EditVC.departNum=self.numstr;
        [self.navigationController pushViewController:EditVC animated:YES];
        
        
    }];
    action2.backgroundColor = GetColor(220,220,220,1);
    return @[action1,action2];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetaotherController *detailVC=[[DetaotherController alloc]init];
    detailVC.blockStr=^(){
        self.str=@"1";
    };
    detailVC.nameStr = _daArr[indexPath.row];
    detailVC.BarandID=[NSString stringWithFormat:@"%@",_ArrID[indexPath.row]];
    detailVC.departmentNum = self.numstr;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)getNetworkData{
    NSString *urlStr =[NSString stringWithFormat:@"%@user/queryBrandDepartment",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Num":_numstr};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            self.dataArray = [NSMutableArray array];
            _daArr = [NSMutableArray array];
            _ArrID = [NSMutableArray array];
            NSArray *array=[responseObject valueForKey:@"yList"];
            for (NSDictionary *dic in array) {
                
                NSArray *barndArr = [dic valueForKey:@"brandList"];
                [_daArr addObject:[dic valueForKey:@"departmentName"]];
                [_ArrID addObject:[dic valueForKey:@"id"]];
                NSMutableArray *logoArr=[NSMutableArray array];
                
                for (NSDictionary *dict in barndArr) {
                    branModel *model=[[branModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [logoArr addObject:model];
                }
                [self.dataArray addObject:logoArr];
            }
            
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
        if (self.dataArray.count==0) {
            [infonTableview addEmptyViewWithImageName:@"" title:@"暂无部门" Size:20.0];
            infonTableview.emptyView.hidden = NO;
        }
        [infonTableview reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
    
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
-(void)AddItem{
    AddotherController *addOtherVC =[[AddotherController alloc]init];
    addOtherVC.Str=^(){
        self.str=@"1";
    };
    addOtherVC.departmentNum=self.numstr;
    addOtherVC.depatrtname =self.sting;
    [self.navigationController pushViewController:addOtherVC animated:YES];
}
-(void)delDepartStr:(NSString*)string IndexPath:( NSIndexPath *)IndexPath{
    
    NSString *urlStr =[NSString stringWithFormat:@"%@user/delDepartment.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Num":_numstr,@"id":string};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除成功" andInterval:1.0];
            [_dataArray removeObjectAtIndex:IndexPath.row];
            [_daArr removeObjectAtIndex:IndexPath.row];
            [_ArrID removeObjectAtIndex:IndexPath.row];
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
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            
        }
        if (self.dataArray.count==0) {
            [infonTableview addEmptyViewWithImageName:@"" title:@"暂无消息" Size:20.0];
            infonTableview.emptyView.hidden = NO;
        }
        [infonTableview reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
@end
