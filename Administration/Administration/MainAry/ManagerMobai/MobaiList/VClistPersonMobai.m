//
//  VClistPersonMobai.m
//  Administration
//
//  Created by zhang on 2017/11/10.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VClistPersonMobai.h"
#import "VCSearchMobai.h"
#import "CellMobai.h"
#import "VCMobaiDetail.h"
#import "VCTargetMobaiDetail.h"
@interface VClistPersonMobai ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UILabel *labelLine;
@property (nonatomic,weak)UIButton *button1;
@property (nonatomic,weak)UIButton *button2;

@property (nonatomic,assign)NSInteger page;
@property (nonatomic) BOOL isRefreshFooter;
@property (nonatomic) BOOL isFirstLoad;
@end

@implementation VClistPersonMobai

-(void)getHttpData:(NSString *)state
{
    NSString *urlStr ;
    
    if ([[ShareModel shareModel].state isEqualToString:@"1"]) {
        urlStr =[NSString stringWithFormat:@"%@shop/selectWorshipRecords.action",KURLHeader];
    }else if ([[ShareModel shareModel].state isEqualToString:@"2"])
    {
        urlStr =[NSString stringWithFormat:@"%@shop/selectIntendeds.action",KURLHeader];
    }else
    {
        urlStr =[NSString stringWithFormat:@"%@shop/selectTargetVisits.action",KURLHeader];
    }
    
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"userid":self.userID,
                           @"CompanyInfoId":compid,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"type":@"3",
                           @"types":state,
                           @"RoleIds":[ShareModel shareModel].roleID,
                           @"nu":[NSString stringWithFormat:@"%ld",(long)self.page],
                           @"RoleId":self.roleID
                           };
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.isRefreshFooter==NO) {
            [self.arrayData removeAllObjects];
        }
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            for (NSDictionary *dict in [responseObject valueForKey:@"recordInfo"]) {
                [self.arrayData addObject:dict];
            }
            [self.tableView reloadData];
            return ;
        }
        
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return;
        }
        
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight, Scree_width, 100)];
    viewTop.backgroundColor = GetColor(192, 192, 192, 1);
    [self.view addSubview:viewTop];
    
    UIView *viewButton = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 54)];
    viewButton.backgroundColor = [UIColor whiteColor];
    [viewTop addSubview:viewButton];
    
    UIButton *buttonSearch = [[UIButton alloc]initWithFrame:CGRectMake(15, 8, Scree_width-30, 40)];
    buttonSearch.adjustsImageWhenHighlighted = NO;
    buttonSearch.layer.cornerRadius = 5;
    buttonSearch.layer.masksToBounds = YES;
    [buttonSearch setImage:[UIImage imageNamed:@"ss_ico01"] forState:UIControlStateNormal];
    [buttonSearch addTarget:self action:@selector(gotoSearch) forControlEvents:UIControlEventTouchUpInside];
    [viewButton addSubview:buttonSearch];
    
    UIView *viewBotttom = [[UIView alloc]initWithFrame:CGRectMake(0, 55, Scree_width, 44)];
    viewBotttom.backgroundColor = [UIColor whiteColor];
    [viewTop addSubview:viewBotttom];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Scree_width/2, 44)];
    button1.tag = 100;
    if ([[ShareModel shareModel].state isEqualToString:@"3"]) {
        [button1 setTitle:@"意向记录" forState:UIControlStateNormal];
    }else
    {
        [button1 setTitle:@"陌拜记录" forState:UIControlStateNormal];
    }
    
    [button1 setTitleColor:GetColor(141, 57, 165, 1) forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(getList:) forControlEvents:UIControlEventTouchUpInside];
    [viewBotttom addSubview:button1];
    self.button1 = button1;
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width/2, 0, Scree_width/2, 44)];
    button2.tag = 200;
    if ([[ShareModel shareModel].state isEqualToString:@"3"]) {
        [button2 setTitle:@"目标记录" forState:UIControlStateNormal];
    }else
    {
        [button2 setTitle:@"陌拜记录" forState:UIControlStateNormal];
    }
    [button2 setTitleColor:GetColor(192 , 192, 192, 1) forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(getList:) forControlEvents:UIControlEventTouchUpInside];
    [viewBotttom addSubview:button2];
    self.button2 = button2;
    
    UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, Scree_width/2, 1)];
    labelLine.backgroundColor = GetColor(141, 57, 165, 1);
    [viewBotttom addSubview:labelLine];
    self.labelLine = labelLine;
    
    self.page = 1;
    self.isFirstLoad = NO;
    self.isRefreshFooter = NO;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kTopHeight+100, Scree_width, Scree_height-kTopHeight-100) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [tableView registerClass:[CellMobai class] forCellReuseIdentifier:@"cell"];
    
    //添加下拉刷新
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        
        self.isRefreshFooter = NO;
        
        [self getHttpData:@"1"];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    
    
    //上拉加载
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.page++;
        
        self.isRefreshFooter = YES;
        
        [self getHttpData:@"1"];
        
        
        
    }];
    
    tableView.mj_footer.automaticallyChangeAlpha = YES;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)gotoSearch
{
    VCSearchMobai *vc = [[VCSearchMobai alloc]init];
    vc.stringTitle = self.stringTitle;
    vc.userID = self.userID;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getList:(UIButton *)button
{
    [self.arrayData removeAllObjects];
    if ([button isEqual:self.button1]) {
        [self.button1 setTitleColor:GetColor(141, 57, 165, 1) forState:UIControlStateNormal];
        [self.button2 setTitleColor:GetColor(192,192,192,1) forState:UIControlStateNormal];
        self.labelLine.frame = CGRectMake(0, 44, Scree_width/2, 1);
        [self getHttpData:@"1"];
    }else
    {
        [self.button2 setTitleColor:GetColor(141, 57, 165, 1) forState:UIControlStateNormal];
        [self.button1 setTitleColor:GetColor(192,192,192,1) forState:UIControlStateNormal];
        self.labelLine.frame = CGRectMake(Scree_width/2, 44, Scree_width/2, 1);
        [self getHttpData:@"2"];
    }
    [self.tableView reloadData];
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellMobai *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellMobai alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.dict = self.arrayData[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSDictionary *dict = self.arrayData[indexPath.row];
    if (![[ShareModel shareModel].state isEqualToString:@"3"]) {
        VCMobaiDetail *vc = [[VCMobaiDetail alloc]init];
        vc.mobaiID = [NSString stringWithFormat:@"%@",dict[@"id"]];
        vc.stringTitle = dict[@"storeName"];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        VCTargetMobaiDetail *vc = [[VCTargetMobaiDetail alloc]init];
        vc.stringTitle = @"目标客户";
        vc.isofyou = NO;
        vc.oneStore = @"2";
        vc.cellend = NO;
        vc.OldTargetVisitId = [NSString stringWithFormat:@"%@",dict[@"id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.arrayData removeAllObjects];
    [self getHttpData:@"1"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    
    self.arrayData = [NSMutableArray array];
    
    [self setUI];
    
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
