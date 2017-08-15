//
//  JoblistController.m
//  Administration
//
//  Created by zhang on 2017/5/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "JoblistController.h"
#import "DepmentController.h"
#import "ChoosePostionViewController.h"
#import "SetModel.h"
@interface JoblistController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    NSInteger indexID;
}
@property (nonatomic,retain)NSMutableArray *arr;
@property (nonatomic,strong)NSMutableArray *indexArray;
@end

@implementation JoblistController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.titleStr = @"按职位查看";
    
    self.title=self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    [self InterTableUI];
    [self getNetworkData];
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)InterTableUI
{
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,Scree_width,Scree_height+49) style:UITableViewStylePlain];
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
    [ZXDNetworking setExtraCellLineHidden:infonTableview];
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = GetColor(230,230,230,1);
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor grayColor];
    header.textLabel.font = [UIFont systemFontOfSize:14.0f];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * str = [NSString stringWithFormat:@"  %@",_indexArray[section]];
    return str;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_arr.count>0) {
        return 30;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arr.count;
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
    SetModel *modld = _arr[indexPath.row];
    cell.textLabel.text =modld.NewName;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.isAddPerson)
//    {
//        SetModel *modld = _arr[indexPath.row];
//        ChoosePostionViewController *controller = [[ChoosePostionViewController alloc]init];
//        controller.str=modld.NewName;
//        controller.Numstr=modld.num;
//        controller.dataShow=self.Num;
//        controller.imageGroup = self.imageGroup;
//        controller.stringGroup = self.stringGroup;
//        controller.isAddMenber = self.isAddMenber;
//        controller.groupID = self.groupID;
//        controller.groupinformationId = self.groupinformationId;
//        [self.navigationController pushViewController:controller animated:YES];
//        
//    }else
//    {
     SetModel *modld = _arr[indexPath.row];
    DepmentController * DepmentCV=[[DepmentController alloc]init];
    DepmentCV.str=modld.NewName;
    DepmentCV.Numstr=modld.num;
    DepmentCV.dataShow=self.Num;
    DepmentCV.isManager = self.isManager;
    DepmentCV.DepartmentID = modld.DepartmentID;
    
    [self.navigationController pushViewController:DepmentCV animated:YES];
   // }

}
-(void)getNetworkData{
    
    NSString *uStr;
    if (self.isManager) {
       uStr=[NSString stringWithFormat:@"%@manager/checkPositionDiff.action",KURLHeader];
    }else
    {
        uStr=[NSString stringWithFormat:@"%@manager/checkPosition.action",KURLHeader];
    }
    
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *arr;
            if (self.isManager) {
                arr = [responseObject valueForKey:@"list"];
            }else
            {
               arr = [responseObject valueForKey:@"list2"];
            }
            
            _arr=[NSMutableArray array];
            for (NSDictionary *dic in arr) {
                SetModel *modld=[[SetModel alloc]init];
                [modld setValuesForKeysWithDictionary:dic];
                [_arr addObject:modld];
            }
            if (_arr.count>0) {
                _indexArray=[NSMutableArray arrayWithObjects:@"职位列表", nil];
                infonTableview.emptyView.hidden = YES;
            }
            [infonTableview reloadData];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到职位信息" andInterval:1.0];
            [infonTableview addEmptyViewWithImageName:@"" title:@"没有设定职位" Size:20.0];
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
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
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
