//
//  VCMobaiNotCheck.m
//  Administration
//
//  Created by zhang on 2017/11/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCMobaiNotCheck.h"
#import "CellMobai.h"
#import "VCMobaiDetail.h"
#import "VCTargetMobaiDetail.h"
@interface VCMobaiNotCheck ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UITableView *tableView;

@property (nonatomic,assign)NSInteger page;
@property (nonatomic)BOOL isRefreshFooter;
@property (nonatomic,weak)UILabel *label;
@property (nonatomic)BOOL isFirstLoad;
@end

@implementation VCMobaiNotCheck

#pragma -mark custem

-(void)getHttpData
{
    NSString *urlStr;
    if ([[ShareModel shareModel].state isEqualToString:@"1"]) {
        urlStr = [NSString stringWithFormat:@"%@shop/selectWorshipRecords.action",KURLHeader];
    }else if ([[ShareModel shareModel].state isEqualToString:@"2"])
    {
        urlStr = [NSString stringWithFormat:@"%@shop/selectIntendeds.action",KURLHeader];
    }else
    {
        urlStr = [NSString stringWithFormat:@"%@shop/selectTargetVisits.action",KURLHeader];
    }
    
    
    
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"type":@"1",
                           @"RoleIds":[ShareModel shareModel].roleID,
                           @"nu":[NSString stringWithFormat:@"%ld",(long)self.page],
                           };
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            for (NSDictionary *dict in [responseObject valueForKey:@"recordInfo"]) {
                [self.arrayData addObject:dict];
            }
            
            if (self.arrayData.count==0) {
                self.label.text = [NSString stringWithFormat:@"未查看"];
            }else
            {
                self.label.text = [NSString stringWithFormat:@"未查看（%lu）",(unsigned long)self.arrayData.count];
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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8 , kTopHeight, Scree_width, 21)];
    label.text = @"未查看";
    
    [self.view addSubview:label];
    self.label = label;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight+21, Scree_width, Scree_height-21-kTopHeight)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [tableView registerClass:[CellMobai class] forCellReuseIdentifier:@"cell"];
    
    self.page = 1;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isRefreshFooter = NO;
        self.page = 1;
        [self.arrayData removeAllObjects];
        [self getHttpData];
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.isRefreshFooter = YES;
        self.page++;
        [self getHttpData];
    }];
    tableView.mj_footer.automaticallyChangeAlpha = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

#pragma -makr tableView

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
    return 90;
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
    [self getHttpData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"未查看";
    
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
