
//
//  ViewControllerStayCheck.m
//  Administration
//
//  Created by zhang on 2017/8/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewControllerStayCheck.h"
#import "CellTbale.h"
#import "ViewControllerPersonTableDetail.h"
#import "VCInsideWeekTable.h"
#import "VCArtMonthTable.h"
#import "VCInsideMonthTable.h"
#import "VCBusinessWeekTable.h"
#import "VCWeekTable.h"
#import "MBProgressHUD.h"
@interface ViewControllerStayCheck ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSUInteger _page;//接口page
@property (nonatomic,assign)BOOL _isFirstLoadData;
@property (nonatomic,assign)BOOL _isFooterFresh;
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,strong)NSDictionary *remark;
@end

@implementation ViewControllerStayCheck
#pragma -mark custem

#pragma mark - 添加刷新

-(void)getData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *urlStr =[NSString stringWithFormat:@"%@report/selectDayDayReportState.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"Sort":[ShareModel shareModel].sort,
                           @"DepartmentID":self.departmentID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"Num":self.num,
                          // @"code":@"1",
                           @"nu":[NSString stringWithFormat:@"%lu",(unsigned long)self._page]};
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *stringCode = [responseObject valueForKey:@"status"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([stringCode isEqualToString:@"0000"]) {
            [self.arrayData removeAllObjects];
            for (NSDictionary *dict in [responseObject valueForKey:@"list"]) {
                [self.arrayData addObject:dict];
            }
            if (self.arrayData.count!=0) {
                [self.tableView reloadData];
            }
            
            // label.text = [];
            return ;
        }
        
        if ([stringCode isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return;
        }
        if ([stringCode isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1.0f];
            return;
        }
        if ([stringCode isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0f];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:NO];
    
}
#pragma -mark tabelView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellTbale *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellTbale alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSDictionary *dict = self.arrayData[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lableName.text = dict[@"name"];
    cell.lableAccount.text = dict[@"phone"];
    cell.labelTime.text = [NSString stringWithFormat:@"%@",dict[@"dates"]];
    
    NSString * remark = [dict valueForKey:@"remark"] ;
    int code = [remark intValue];
    NSString *string =self.remark[[NSString stringWithFormat:@"%d",code]];
    cell.labelMold.text = [string substringWithRange:NSMakeRange(2, 3)];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayData[indexPath.row];
    if ([[ShareModel shareModel].sort isEqualToString:@"1"]) {
        ViewControllerPersonTableDetail *vc = [[ViewControllerPersonTableDetail alloc]init];
        vc.stringTitle = dict[@"name"];
       // vc.roleId = self.rid;
        vc.departmentId = self.departmentID;
        vc.postionName = dict[@"newName"];
        vc.remark = dict[@"remark"];
        vc.tableId = dict[@"id"];
        vc.num = self.num;
        //  VCInsideWeekTable *vc = [[VCInsideWeekTable alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([[ShareModel shareModel].sort isEqualToString:@"2"])
    {
        if ([dict[@"newName"] containsString:@"美导"]||[dict[@"newName"] containsString:@"市场"]||[dict[@"newName"] containsString:@"品牌"]) {
            VCWeekTable *vc = [[VCWeekTable alloc]init];
            vc.stringTitle = dict[@"name"];
         //   vc.roleId = self.rid;
            vc.departmentId = self.departmentID;
            vc.postionName = dict[@"newName"];
            vc.remark = dict[@"remark"];
            vc.tableId = dict[@"id"];
            vc.num = self.num;
            if ([dict[@"code"] intValue]==1) {
                vc.isSelect = YES;
                vc.tableId = dict[@"id"];
            }else
            {
                vc.isSelect = NO;
                vc.summaryId = dict[@"id"];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }else if([dict[@"newName"] containsString:@"业务"])
        {
            VCBusinessWeekTable *vc = [[VCBusinessWeekTable alloc]init];
            vc.stringTitle = dict[@"name"];
           // vc.roleId = self.rid;
            vc.departmentId = self.departmentID;
            vc.postionName = dict[@"newName"];
            vc.remark = dict[@"remark"];
            vc.tableId = dict[@"id"];
            vc.num = self.num;
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
           // vc.roleId = self.rid;
            vc.departmentId = self.departmentID;
            vc.postionName = dict[@"newName"];
            vc.remark = dict[@"remark"];
            vc.tableId = dict[@"id"];
            vc.num = self.num;
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
        if ([dict[@"newName"] containsString:@"美导"]||[dict[@"newName"] containsString:@"市场"])
        {
            VCArtMonthTable *vc = [[VCArtMonthTable alloc]init];
            vc.stringTitle = dict[@"name"];
          //  vc.roleId = self.rid;
            vc.departmentId = self.departmentID;
            vc.postionName = dict[@"newName"];
            vc.remark = dict[@"remark"];
            vc.tableId = dict[@"id"];
            vc.num = self.num;
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
          //  vc.roleId = self.rid;
            vc.departmentId = self.departmentID;
            vc.postionName = dict[@"newName"];
            vc.remark = dict[@"remark"];
            vc.tableId = dict[@"id"];
            vc.num = self.num;
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
    return 61;
}

#pragma -mark system
-(void)viewWillAppear:(BOOL)animated
{
    [self.arrayData removeAllObjects];
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"待审核";
    self.arrayData = [NSMutableArray array];
    self._isFirstLoadData = YES;
    
    //不是上拉加载数据
    
    self._isFooterFresh = NO;
    
    //页码赋初值
    
    self._page=1;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(-1, 64, Scree_width+1, 20)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"  最近报表";
    label.textColor = GetColor(192, 192, 192, 1);
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 1.0f;
    [self.view addSubview:label];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 84, Scree_width, Scree_height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CellTbale class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
      self._page = 1;
        
       self. _isFooterFresh = NO;
        
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
