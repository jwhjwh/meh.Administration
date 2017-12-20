//
//  ShopNameViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/12/19.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ShopNameViewController.h"
#import "StoreinforViewController.h"
@interface ShopNameViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *infonTableview;
}
@property (strong,nonatomic) NSMutableArray *InterNameAry;
@property (nonatomic,assign)int pagenum;
@property (strong,nonatomic) NSMutableArray *DepartmentId;
@property (strong,nonatomic) NSMutableArray *Storeid;
@end

@implementation ShopNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索结果";
    self.pagenum = 1;
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    _InterNameAry = [[NSMutableArray alloc]init];
    _DepartmentId = [[NSMutableArray alloc]init];
    _Storeid = [[NSMutableArray alloc]init];
    [self InterestedUI];
    [self getNetworkData:YES];
    __weak typeof(self) weakSelf = self;
    //默认【下拉刷新】
    infonTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _InterNameAry = [NSMutableArray array];
        [weakSelf getNetworkData:YES];
        [infonTableview reloadData];
    }];
    
    //默认【上拉加载】
    infonTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [weakSelf getNetworkData:NO];
        //[self.tableView reloadData];
    }];
    
}
-(void)endRefresh{
    if (_pagenum == 1) {
        [infonTableview.mj_header endRefreshing];
    }else{
        [infonTableview.mj_footer endRefreshing];
    }
    
}

-(void)getNetworkData:(BOOL)isRefresh{
    if (isRefresh) {
        _pagenum = 1;
    }else{
        _pagenum++;
    }
    if (self.StoreName ==nil) {
        self.StoreName = @"";
    }
    if (self.Province ==nil) {
        self.Province = @"";
    }
    if (self.City ==nil) {
        self.City = @"";
    }
    if (self.County ==nil) {
        self.County = @"";
    }
    
    NSString *pageStr=[NSString stringWithFormat:@"%d",_pagenum];
    NSString *uStr =[NSString stringWithFormat:@"%@stores/selectCompanyInfoStore.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"CompanyInfoId":compid,@"StoreName":self.StoreName,@"Province":self.Province,@"City":self.City,@"County":self.County,@"nu":pageStr,@"RoleId":self.strId};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"list"];
            
            for (NSDictionary *dic in array) {
                 [_InterNameAry addObject:[dic valueForKey:@"storeName"]];
                 [_Storeid addObject:[dic valueForKey:@"id"]];
                 [_DepartmentId addObject:[dic valueForKey:@"departmentId"]];
            }
            [infonTableview reloadData];
           [self endRefresh];
            
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
            
            if (self.InterNameAry.count>0) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"这已经是全部的店家了" andInterval:1.0];
                [infonTableview.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                [infonTableview addEmptyViewWithImageName:@"" title:@"暂无报岗" Size:20.0];
                infonTableview.emptyView.hidden = NO;
            }
            [self endRefresh];
            
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"该地区没有店家" andInterval:1.0];
            [infonTableview.mj_footer endRefreshingWithNoMoreData];
            [self endRefresh];
            return;
            
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)InterestedUI{
    NSString* phoneModel = [UIDevice devicePlatForm];
    UILabel *zuijinlabel = [[UILabel alloc]init];
    zuijinlabel.text = @"店家列表";
    zuijinlabel.font = [UIFont systemFontOfSize:14];
    zuijinlabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:zuijinlabel];
    [zuijinlabel mas_makeConstraints:^(MASConstraintMaker *make) {
         if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
             make.top.mas_equalTo(self.view.mas_top).offset(94);
         }else{
             make.top.mas_equalTo(self.view.mas_top).offset(70);
         }
       
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    infonTableview =[[UITableView alloc]init];
    infonTableview.delegate = self;
    infonTableview.dataSource = self;
    [self.view addSubview: infonTableview];
    [ZXDNetworking setExtraCellLineHidden:infonTableview];
    
    [infonTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(zuijinlabel.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *uStr =[NSString stringWithFormat:@"%@stores/selectStoreUsercode.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"DepartmentId":_DepartmentId[indexPath.row],@"RoleId":self.strId,@"Storeid":_Storeid[indexPath.row]};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            
            StoreinforViewController *storeVC = [[StoreinforViewController alloc]init];
            storeVC.shopId =_Storeid[indexPath.row];
            storeVC.strId = self.strId;
            storeVC.isend = NO;
            storeVC.shopname = @"1";
            storeVC.titleName = _InterNameAry[indexPath.row];
            [self.navigationController pushViewController:storeVC animated:YES];
            
            
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0003"]){
             [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有权限查看该店家信息!" andInterval:1.0];
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
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
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
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _InterNameAry[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _InterNameAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    
    return 1;
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
