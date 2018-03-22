//
//  GonggaoxqController.m
//  Administration
//
//  Created by zhang on 2017/2/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "GonggaoxqController.h"
#import "AmentxqController.h"
#import "GongTableViewCell.h"
#import "GongModel.h"
#import "VCAddGonggao.h"
@interface GonggaoxqController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property (nonnull,strong)NSMutableArray *arrayData;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,assign)NSUInteger _page;//接口page
//是不是第一次执行请求
@property (nonatomic)BOOL _isFirstLoadData ;
//是不是上拉加载数据（脚视图刷新）
@property (nonatomic)BOOL _isFooterFresh ;

@end

@implementation GonggaoxqController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.arrayData removeAllObjects];
    [self getNetworkData];
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"最新公告";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30,30)];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setTitle:@"+" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoAdd) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = nil;
    NSString *roleID = [USER_DEFAULTS valueForKey:@"roleIds"];
    NSArray  *array = [roleID componentsSeparatedByString:@","];
    
    
     BOOL isbool = [array containsObject: @"1"];
    if (isbool==0) {
        //有
        self.navigationItem.rightBarButtonItem = rightItem;
    }else{
        //没有
        BOOL twobool =[array containsObject: @"7"];
        if (twobool==0) {
            //有
             self.navigationItem.rightBarButtonItem = rightItem;
        }
    }
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.tableView .delegate = self;
    self.tableView .dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview: self.tableView ];
    
    self.dataArray = [NSMutableArray array];
    self.arrayData = [NSMutableArray array];
    
    self._page = 1;
    self._isFirstLoadData = NO;
    self._isFooterFresh = NO;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self._page=1;
        self._isFooterFresh = NO;
        [self getNetworkData];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self._page++;
        self._isFooterFresh = YES;
        [self getNetworkData];
    }];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}

-(void)gotoAdd
{
    VCAddGonggao *vc = [[VCAddGonggao alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)getNetworkData{
    
    NSString *pageStr=[NSString stringWithFormat:@"%ld",self._page];
    NSString *urlStr =[NSString stringWithFormat:@"%@adminNotice/queryNotice.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,
                         @"usersid":[USER_DEFAULTS  objectForKey:@"userid"],
                         @"pageNo":pageStr,
                         @"comId":[USER_DEFAULTS objectForKey:@"companyinfoid"]
                         };
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self._isFooterFresh==NO) {
            [self.arrayData removeAllObjects];
        }
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"nlist"];
            for (NSDictionary *dic in array) {
                
//                GongModel *model=[[GongModel alloc]init];
//                
//                [model setValuesForKeysWithDictionary:dic];
//                [self.dataArray addObject:model];
                [self.arrayData addObject:dic];
            }
            [self.tableView reloadData];
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
        return;
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
        }else if ([[responseObject valueForKey:@"status"] isEqualToString:@"50000"])
        {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GongTableViewCell *cell = [[GongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[GongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    if (self.arrayData.count > 0) {
        cell = [[GongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
            cell.dict = self.arrayData[indexPath.row];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayData[indexPath.row];
    AmentxqController *amentVC=[[AmentxqController alloc]init];
    
    amentVC.dict = dict;
    amentVC.noticeID = [NSString stringWithFormat:@"%@",dict[@"id"]];
    [self.navigationController pushViewController:amentVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
