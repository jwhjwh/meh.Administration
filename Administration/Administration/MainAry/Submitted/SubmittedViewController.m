//
//  SubmittedViewController.m
//  Administration
//   图片报岗
//  Created by 九尾狐 on 2017/3/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "SubmittedViewController.h"
#import "MySubmittedViewController.h"
#import "SubmittedModel.h"
#import "SubmittedTableViewCell.h"
#import "DateSubmittedViewController.h"
@interface SubmittedViewController ()<UITableViewDataSource,UITableViewDelegate>

//列表
@property (nonatomic,strong)UITableView *tableView;
//服务器获取数据源
@property (nonatomic,strong)NSMutableArray *dataArray;
//页数
@property (nonatomic,assign)int pagenum;
@end

@implementation SubmittedViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"图片报岗";
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"我的"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(masgegeClick)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    self.pagenum = 1;
    NSString* phoneModel = [UIDevice devicePlatForm];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
       self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 88,kScreenWidth,kScreenHeight-88)];
    }else{
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight)];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SubmittedTableViewCell" bundle:nil] forCellReuseIdentifier:@"BASE"];
    
    [self getNetworkData:YES];
    __weak typeof(self) weakSelf = self;
    //默认【下拉刷新】
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         _dataArray = [NSMutableArray array];
        [weakSelf getNetworkData:YES];
        [self.tableView reloadData];
    }];

    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [weakSelf getNetworkData:NO];
        //[self.tableView reloadData];
    }];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;

}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)masgegeClick{
    MySubmittedViewController *mySubmittedVC= [[MySubmittedViewController alloc]init];
    
    [self.navigationController pushViewController:mySubmittedVC animated:YES];
}

-(void)endRefresh{
    if (_pagenum == 1) {
    [self.tableView.mj_header endRefreshing];
    }else{
     [self.tableView.mj_footer endRefreshing];
    }
    
}
-(void)getNetworkData:(BOOL)isRefresh{
    if (isRefresh) {
        _pagenum = 1;
    }else{
        _pagenum++;
    }
    NSString *pageStr=[NSString stringWithFormat:@"%d",_pagenum];
    NSString *urlStr =[NSString stringWithFormat:@"%@picreport/queryAllPic.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *comp = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    //CompanyInfoId
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"pageNo":pageStr,@"CompanyInfoId":comp};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        //plist
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"plist"];
              //[self endRefresh];
            for (NSDictionary *dic in array) {
                SubmittedModel *model=[[SubmittedModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                model.dateTimes = [model.dateTimes substringToIndex:16];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            //[self.tableView.footer endRefreshing];
    
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
            
            if (self.dataArray.count>0) {
                 [ELNAlerTool showAlertMassgeWithController:self andMessage:@"这已经是全部的报岗了" andInterval:1.0];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                [_tableView addEmptyViewWithImageName:@"" title:@"暂无报岗" Size:20.0];
                _tableView.emptyView.hidden = NO;
            }
           
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"这已经是全部的报岗了" andInterval:1.0];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        [self endRefresh];

    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubmittedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BASE" forIndexPath:indexPath];
    if (self.dataArray.count <=0) {

        return cell;
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SubmittedModel *model = _dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    [cell loadDataFromModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DateSubmittedViewController *detail = [[DateSubmittedViewController alloc]init];
    SubmittedModel *model =self.dataArray[indexPath.section];
    detail.contentid = model.pid;
    detail.datesubString=^(NSString *content){
        if ([content isEqualToString:@"1"]) {
           [self getNetworkData:YES];
            
        }
    };
    [self.navigationController pushViewController:detail animated:YES];
    
    
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
