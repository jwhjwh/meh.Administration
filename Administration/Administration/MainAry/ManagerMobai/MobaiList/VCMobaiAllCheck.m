//
//  VCMobaiAllCheck.m
//  Administration
//
//  Created by zhang on 2017/11/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCMobaiAllCheck.h"
#import "CellMobai.h"
#import "VCMobaiDetail.h"
#import "VCSearchMobai.h"
@interface VCMobaiAllCheck ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UITableView *tableView;

@property (nonatomic,assign)NSInteger page;
@property (nonatomic)BOOL isRefreshFooter;
@property (nonatomic)BOOL isFirstLoad;
@end

@implementation VCMobaiAllCheck

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/selectWorshipRecords.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"type":@"2",
                           @"RoleIds":[ShareModel shareModel].roleID,
                           @"nu":[NSString stringWithFormat:@"%ld",(long)self.page],
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
    UIView *viewButton = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight, Scree_width, 54)];
    viewButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewButton];
    
    UIButton *buttonSearch = [[UIButton alloc]initWithFrame:CGRectMake(15, 8, Scree_width-30, 40)];
    buttonSearch.adjustsImageWhenHighlighted = NO;
    buttonSearch.layer.cornerRadius = 5;
    buttonSearch.layer.masksToBounds = YES;
    [buttonSearch setImage:[UIImage imageNamed:@"ss_ico01"] forState:UIControlStateNormal];
    [buttonSearch addTarget:self action:@selector(gotoSearch) forControlEvents:UIControlEventTouchUpInside];
    [viewButton addSubview:buttonSearch];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight+55, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        self.page=1;
        self.isRefreshFooter = NO;
        [self getHttpData];
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        self.page++;
        self.isRefreshFooter = YES;
        [self getHttpData];
    }];
    tableView.mj_footer.automaticallyChangeAlpha = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)gotoSearch
{
    VCSearchMobai *vc = [[VCSearchMobai alloc]init];
    vc.isAllCheck = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayData[indexPath.row];
    VCMobaiDetail *vc = [[VCMobaiDetail alloc]init];
    vc.mobaiID = [NSString stringWithFormat:@"%@",dict[@"id"]];
    vc.stringTitle = dict[@"storeName"];
    [self.navigationController pushViewController:vc animated:YES];
    
}



#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
    [self.arrayData removeAllObjects];
    [self getHttpData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    [self setUI];
    self.arrayData = [NSMutableArray array];
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
