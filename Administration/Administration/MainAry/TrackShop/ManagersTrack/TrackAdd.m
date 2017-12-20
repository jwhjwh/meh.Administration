//
//  TrackAdd.m
//  Administration
//
//  Created by zhang on 2017/12/11.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TrackAdd.h"
#import "TrackAddTrack.h"
#import "CellTrackShop.h"
#import "TrackAddMajordomo.h"
#import "TrackManagerDetail.h"
#import "TrackMajordomoDetail.h"
@interface TrackAdd ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UITableView *tableView;
@end

@implementation TrackAdd

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@tracking/selectStoreTracking.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.arrayData = [[responseObject valueForKey:@"list"]mutableCopy];
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
    
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setTitle:@"+" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addTrack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, kTopHeight , Scree_width, 30)];
    label.text = @"店家跟踪列表";
    [self.view addSubview:label];
    
    UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(0, kTopHeight+30, Scree_width, 3)];
    labelLine.backgroundColor = GetColor(192, 192, 192, 1);
    [self.view addSubview:labelLine];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,  33+kTopHeight, Scree_width, Scree_height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [tableView registerClass:[CellTrackShop class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(void)addTrack
{
    if ([[ShareModel shareModel].roleID isEqualToString:@"9"]||
        [[ShareModel shareModel].roleID isEqualToString:@"10"]||
        [[ShareModel shareModel].roleID isEqualToString:@"11"]||
        [[ShareModel shareModel].roleID isEqualToString:@"7"]) {
        TrackAddMajordomo *vc = [[TrackAddMajordomo alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
    TrackAddTrack *vc = [[TrackAddTrack alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    CellTrackShop *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CellTrackShop alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dict = self.arrayData[indexPath.row];
    cell.dict = dict;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayData[indexPath.row];
    if ([[ShareModel shareModel].roleID isEqualToString:@"9"]||
        [[ShareModel shareModel].roleID isEqualToString:@"10"]||
        [[ShareModel shareModel].roleID isEqualToString:@"11"]||
        [[ShareModel shareModel].roleID isEqualToString:@"7"]) {
        TrackMajordomoDetail *vc = [[TrackMajordomoDetail alloc]init];
        vc.TrackID = [NSString stringWithFormat:@"%@",dict[@"id"]];
        vc.stringTitle = dict[@"usersName"];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        TrackManagerDetail *vc = [[TrackManagerDetail alloc]init];
        vc.TrackID = [NSString stringWithFormat:@"%@",dict[@"id"]];
        vc.stringTitle = dict[@"usersName"];
        [self.navigationController pushViewController:vc animated:YES];
    }}

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
