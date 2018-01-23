//
//  VCMineTable.m
//  Administration
//
//  Created by zhang on 2017/9/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCMineTable.h"
#import "CellMineTable.h"
#import "VCTableDetail.h"
#import "VCEditTable.h"
#import "VCAddPlan.h"
@interface VCMineTable ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arrayDate;
@property (nonatomic,assign)NSUInteger _page;//接口page
@property (nonatomic,strong)NSIndexPath *indexPath;
//是不是第一次执行请求
@property (nonatomic)BOOL _isFirstLoadData ;
//是不是上拉加载数据（脚视图刷新）
@property (nonatomic)BOOL _isFooterFresh ;
@end

@implementation VCMineTable

-(void)createFresh
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[CellMineTable class] forCellReuseIdentifier:@"cell"];
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
                           @"DepartmentID":[ShareModel shareModel].departmentID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"Num":[ShareModel shareModel].num,
                           @"code":@"1",
                           @"page":[NSString stringWithFormat:@"%ld",self._page]
                           };
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self._isFooterFresh==NO) {
            [self.arrayDate removeAllObjects];
        }
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
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
            return ;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1];
            return ;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}



-(void)deletPlan:(NSIndexPath *)indexPath
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/delDayPlan",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSDictionary *dictinfo = self.arrayDate[indexPath.row];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"id":dictinfo[@"id"],
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"did":@""};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.arrayDate removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
            return;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常" andInterval:1];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)gotoEdit:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayDate[indexPath.row];
    VCEditTable *vc = [[VCEditTable alloc]init];
    vc.dayPlabID = dict[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addPlan
{
    VCAddPlan *vc = [[VCAddPlan alloc]init];
    vc.num = [ShareModel shareModel].num;
    vc.departmentID = self.departmentID;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self deletPlan:self.indexPath];
    }
    
}

#pragma -mark tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayDate.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellMineTable *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellMineTable alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
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

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        self.indexPath = indexPath;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要删除此项内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    //删除按钮颜色
    deleteAction.backgroundColor = GetColor(137,52,167,1);
    
    //添加一个编辑按钮
    UITableViewRowAction *topRowAction =[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self gotoEdit:indexPath];
    }];
    //置顶按钮颜色
    topRowAction.backgroundColor = GetColor(0, 124, 248, 1);
   
    //将设置好的按钮方到数组中返回
    return @[deleteAction,topRowAction];
    // return @[deleteAction,topRowAction,collectRowAction];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    self.title = @"我的";
    self.arrayDate = [NSMutableArray array];
    [self createFresh];
    self._page = 1;
    self._isFirstLoadData = NO;
    self._isFooterFresh = NO;
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:30],NSFontAttributeName ,nil];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"+" style:(UIBarButtonItemStyleDone) target:self action:@selector(addPlan)];
    [rightitem setTitleTextAttributes:dictionary forState:UIControlStateNormal];
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
