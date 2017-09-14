//
//  VCDepartmentDayPlan.m
//  Administration
//
//  Created by zhang on 2017/9/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCDepartmentDayPlan.h"
#import "CellMyTable.h"
#import "VCTableDetail.h"
#import "VCMineTable.h"
@interface VCDepartmentDayPlan ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arrayDate;
@property (nonatomic,assign)NSUInteger _page;//接口page
//是不是第一次执行请求
@property (nonatomic)BOOL _isFirstLoadData ;
//是不是上拉加载数据（脚视图刷新）
@property (nonatomic)BOOL _isFooterFresh ;
@end

@implementation VCDepartmentDayPlan

#pragma -mark custem
-(void)createFresh
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 100;
    [tableView registerClass:[CellMyTable class] forCellReuseIdentifier:@"cell"];
    tableView.rowHeight = UITableViewAutomaticDimension;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self._page=1;
        self._isFooterFresh = NO;
        [self getData];
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self._page++;
        self._isFooterFresh = YES;
        [self getData];
    }];
    tableView.mj_footer.automaticallyChangeAlpha = YES;
    
    self.tableView = tableView;
}

-(void)getData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryDepartmentDayPlanList",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"DepartmentID":self.departmentID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"Num":[ShareModel shareModel].num,
                           @"code":@"2",
                           @"page":[NSString stringWithFormat:@"%ld",self._page]
                           };
    [self.arrayDate removeAllObjects];
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            for (NSDictionary *dict in [responseObject valueForKey:@"list"]) {
                [self.arrayDate addObject:dict];
            }
            
            [self.tableView reloadData];
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"token请求超时" andInterval:1];
            return ;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常" andInterval:1];
            return ;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)gotoMyTable
{
    VCMineTable *vc = [[VCMineTable alloc]init];
    vc.departmentID = self.departmentID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayDate.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellMyTable *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellMyTable alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.dict = self.arrayDate[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayDate[indexPath.row];
    VCTableDetail *vc = [[VCTableDetail alloc]init];
    vc.dayPlabID = [NSString stringWithFormat:@"%@",dict[@"id"]];
    vc.stringTitle = dict[@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    self.arrayDate = [NSMutableArray array];
    [self createFresh];
    self._page = 1;
    self._isFirstLoadData = NO;
    self._isFooterFresh = NO;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"我的" style:(UIBarButtonItemStyleDone) target:self action:@selector(gotoMyTable)];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
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
