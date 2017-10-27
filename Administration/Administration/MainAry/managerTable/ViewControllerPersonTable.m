//
//  ViewControllerPersonTable.m
//  Administration
//
//  Created by zhang on 2017/8/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewControllerPersonTable.h"
#import "ViewControllerPersonTableDetail.h"
#import "VCInsideWeekTable.h"
#import "VCArtMonthTable.h"
#import "VCInsideMonthTable.h"
#import "VCBusinessWeekTable.h"
#import "VCWeekTable.h"
#import "CellTbale.h"
@interface ViewControllerPersonTable ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,strong) NSDictionary *remark;
@property (nonatomic,assign)NSUInteger _page;//接口page
//是不是第一次执行请求

@property (nonatomic)BOOL _isFirstLoadData ;

//是不是上拉加载数据（脚视图刷新）

@property (nonatomic)BOOL _isFooterFresh ;
@end

@implementation ViewControllerPersonTable
#pragma -mark custem

- (void)removeHUD:(id)hud

{
    
    //结束刷新
    
    [self.tableView.mj_header endRefreshing];
    
    [self.tableView.mj_footer endRefreshing];
    
    [hud removeFromSuperview];
    
}

-(void)getData
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryUserReport",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":self.roleId,
                           @"DepartmentID":self.departmentId,
                           @"Num":self.num,
                           @"Sort":[ShareModel shareModel].sort,
                           @"page":[NSString stringWithFormat:@"%ld",self._page],
                           @"id":self.userid,
                           @"rid":self.rid};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *stringCode = [responseObject valueForKey:@"status"];
        [self performSelector:@selector(removeHUD:) withObject:hud afterDelay:0.5];
        
        if ([stringCode isEqualToString:@"0000"]) {
            //[self.array removeAllObjects];
            for (NSDictionary *dict in [responseObject valueForKey:@"list"]) {
                [self.array addObject:dict];
            }
            [self.tableView reloadData];
            return ;
        }
        if ([stringCode isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
            return;
        }
        if ([stringCode isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return;
        }
        if ([stringCode isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无更多数据" andInterval:1];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
   // return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellTbale *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellTbale alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = self.array[indexPath.row];
    
    
    [self.remark enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:[NSString stringWithFormat:@"%@",dict[@"remark"]]]) {
            NSString *string = [NSString stringWithFormat:@"%@",obj];
            cell.labelMold.text = [string substringWithRange:NSMakeRange(2, 3)];
            *stop = YES;
        }
    }];
    
    cell.lableName.text = dict[@"name"];
    cell.lableAccount.text = dict[@"phone"];
    if (dict[@"dates"]) {
        cell.labelTime.text = [dict[@"dates"] substringToIndex:16];
    }else
    {
        cell.labelTime.text = @"";
    }
    
    NSString *state = [NSString stringWithFormat:@"%@",dict[@"state"]];
    if ([state isEqualToString:@"0"]) {
        cell.labelStatus.text = @"待审核";
        cell.labelStatus.textColor = GetColor(192, 192, 192, 1);
    }else if ([state isEqualToString:@"1"])
    {
        cell.labelStatus.text = [NSString stringWithFormat:@"通过:%@",dict[@"updateTime"]];
       cell.labelStatus.textColor = GetColor(206, 157, 86, 1);
    }else
    {
        cell.labelStatus.text = [NSString stringWithFormat:@"驳回:%@",dict[@"updateTime"]];
        cell.labelStatus.textColor = GetColor(246, 0, 49, 1);
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"所有报表";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.array[indexPath.row];
    NSString *state = [NSString stringWithFormat:@"%@",dict[@"state"]];
    if ([[ShareModel shareModel].sort isEqualToString:@"1"]) {
        ViewControllerPersonTableDetail *vc = [[ViewControllerPersonTableDetail alloc]init];
        vc.stringTitle = dict[@"name"];
        vc.roleId = self.rid;
        vc.departmentId = self.departmentId;
        vc.postionName = self.positionName;
        vc.remark = dict[@"remark"];
        vc.tableId = dict[@"id"];
        vc.num = self.num;
        vc.state = state;
        //  VCInsideWeekTable *vc = [[VCInsideWeekTable alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([[ShareModel shareModel].sort isEqualToString:@"2"])
    {
        if ([self.positionName containsString:@"美导"]||[self.positionName containsString:@"市场"]) {
            VCWeekTable *vc = [[VCWeekTable alloc]init];
            vc.stringTitle = dict[@"name"];
            vc.roleId = self.rid;
            vc.departmentId = self.departmentId;
            vc.postionName = self.positionName;
            vc.remark = dict[@"remark"];
            vc.state = state;
            vc.num = self.num;
            vc.codeS = [NSString stringWithFormat:@"%@",dict[@"code"]];
            if ([dict[@"code"] intValue]==1) {
                vc.isSelect = YES;
                vc.tableId = dict[@"id"];
            }else
            {
                vc.isSelect = NO;
                vc.summaryId = dict[@"id"];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }else if([self.positionName containsString:@"业务"])
        {
            VCBusinessWeekTable *vc = [[VCBusinessWeekTable alloc]init];
            vc.stringTitle = dict[@"name"];
            vc.roleId = self.rid;
            vc.departmentId = self.departmentId;
            vc.postionName = self.positionName;
            vc.remark = dict[@"remark"];
            vc.tableId = dict[@"id"];
            vc.num = self.num;
            vc.state = state;
            vc.codeS = [NSString stringWithFormat:@"%@",dict[@"code"]];
            if ([dict[@"code"] intValue]==1) {
                vc.isSelect = YES;
                vc.tableId = dict[@"id"];
            }else
            {
                vc.isSelect = NO;
                vc.summaryId = dict[@"id"];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            VCInsideWeekTable *vc = [[VCInsideWeekTable alloc]init];
            vc.stringTitle = dict[@"name"];
            vc.roleId = self.rid;
            vc.departmentId = self.departmentId;
            vc.postionName = self.positionName;
            vc.remark = dict[@"remark"];
            vc.tableId = dict[@"id"];
            vc.num = self.num;
            vc.state = state;
            vc.codeS = [NSString stringWithFormat:@"%@",dict[@"code"]];
            if ([dict[@"code"] intValue]==1) {
                vc.isSelect = YES;
                vc.tableId = dict[@"id"];
            }else
            {
                vc.isSelect = NO;
                vc.summaryId = dict[@"id"];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else
    {
        if ([self.positionName containsString:@"美导"]||[self.positionName containsString:@"市场"])
        {
            VCArtMonthTable *vc = [[VCArtMonthTable alloc]init];
            vc.stringTitle = dict[@"name"];
            vc.roleId = self.rid;
            vc.departmentId = self.departmentId;
            vc.postionName = self.positionName;
            vc.remark = dict[@"remark"];
            vc.tableId = dict[@"id"];
            vc.num = self.num;
            vc.state = state;
            vc.codeS = [NSString stringWithFormat:@"%@",dict[@"code"]];
            if ([dict[@"code"] intValue]==1) {
                vc.isSelect = YES;
                vc.tableId = dict[@"id"];
            }else
            {
                vc.isSelect = NO;
                vc.summaryId = dict[@"id"];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            VCInsideMonthTable *vc = [[VCInsideMonthTable alloc]init];
            vc.stringTitle = dict[@"name"];
            vc.roleId = self.rid;
            vc.departmentId = self.departmentId;
            vc.postionName = self.positionName;
            vc.remark = dict[@"remark"];
            vc.tableId = dict[@"id"];
            vc.num = self.num;
            vc.state = state;
            vc.codeS = [NSString stringWithFormat:@"%@",dict[@"code"]];
            if ([dict[@"code"] intValue]==1) {
                vc.isSelect = YES;
                vc.tableId = dict[@"id"];
            }else
            {
                vc.isSelect = NO;
                vc.summaryId = dict[@"id"];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

#pragma -mark system
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.array removeAllObjects];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    self.array = [NSMutableArray array];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[CellTbale class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //添加下拉刷新
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self._page = 1;
        
        self._isFooterFresh = NO;
        
        [self getData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    
    
    //上拉加载
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self._page++;
        
        self._isFooterFresh = YES;
        
        [self getData];
        
        
        
    }];
    
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    
    
    self._isFirstLoadData = YES;
    
    //不是上拉加载数据
    
    self._isFooterFresh = NO;
    
    //页码赋初值
    
    self._page=1;
    
    self.remark = @{@"1":@"业务日报表",
                           @"2":@"业务周计划",
                           @"3":@"业务周总结",
                           @"4":@"市场店报表",
                           @"5":@"市场周计划",
                           @"6":@"市场周总结",
                           @"7":@"市场月计划",
                           @"8":@"市场月总结",
                           @"9":@"内勤日报表",
                           @"10":@"内勤周计划",
                           @"11":@"内勤周总结",
                           @"12":@"内勤月计划",
                           @"13":@"内勤月总结"};
    
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
