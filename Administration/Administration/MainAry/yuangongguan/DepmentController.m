//
//  DepmentController.m
//  Administration
//
//  Created by zhang on 2017/5/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "DepmentController.h"
#import "inftionxqController.h"
#import "GuanglixqVController.h"
#import "ZJLXRTableViewCell.h"
#import "DirtmsnaModel.h"
@interface DepmentController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation DepmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_str;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    if (_Num==1) {
        [self datalade];
    }else{
        [self checkPositionUsers];
    }

}
-(void)datalade{
    NSString *urlStr =[NSString stringWithFormat:@"%@manager/queryDepartments.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Num":_Numstr,@"DepartmentID":_DepartmentID};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            self.dataArray = [NSMutableArray array];
            NSArray *array=[responseObject valueForKey:@"list"];
            
            for (NSDictionary *dic in array) {
                DirtmsnaModel *model=[[DirtmsnaModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                model.isdeles=@"";
                [self.dataArray addObject:model];
            }
         
            if (self.dataArray.count==0) {
                [_tableView addEmptyViewWithImageName:@"" title:@"暂无员工～～"  Size:20.0];
                _tableView.emptyView.hidden = NO;
            }
            [_tableView reloadData];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }
        if (self.dataArray.count==0) {
            [_tableView addEmptyViewWithImageName:@"" title:@"暂无员工" Size:20.0];
            _tableView.emptyView.hidden = NO;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
    
}
-(void)checkPositionUsers{
    NSString *urlStr =[NSString stringWithFormat:@"%@manager/checkPositionUsers.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Num":_Numstr};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            self.dataArray = [NSMutableArray array];
            NSArray *array=[responseObject valueForKey:@"list"];
            
            for (NSDictionary *dic in array) {
                DirtmsnaModel *model=[[DirtmsnaModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                model.isdeles=@"";
                [self.dataArray addObject:model];
            }
            
            if (self.dataArray.count==0) {
                [_tableView addEmptyViewWithImageName:@"" title:@"暂无员工～～"  Size:20.0];
                _tableView.emptyView.hidden = NO;
            }
            [_tableView reloadData];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }
        if (self.dataArray.count==0) {
            [_tableView addEmptyViewWithImageName:@"" title:@"暂无员工" Size:20.0];
            _tableView.emptyView.hidden = NO;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJLXRTableViewCell *cell = [[ZJLXRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[ZJLXRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DirtmsnaModel *model = _dataArray[indexPath.row];
    if (self.dataShow==1) {
        inftionxqController *imftionVC=[[inftionxqController alloc]init];
        imftionVC.IDStr=model.usersid;
        [self.navigationController pushViewController:imftionVC animated:YES];
    }else{
        GuanglixqVController *guangVC=[[GuanglixqVController alloc]init];
        guangVC.uresID =model.usersid;
        guangVC.name =_str;
        guangVC.Cellblock=^(){
            if (_Num==1) {
                [self datalade];
            }else{
                [self checkPositionUsers];
            }
        };
        [self.navigationController pushViewController:guangVC animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
