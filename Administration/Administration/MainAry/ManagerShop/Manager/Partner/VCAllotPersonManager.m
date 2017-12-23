//
//  VCAllotPersonManager.m
//  Administration
//
//  Created by zhang on 2017/12/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCAllotPersonManager.h"
#import "CellChargeManager.h"
#import "VCPeopleShopManager.h"
@interface VCAllotPersonManager ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UIButton *buttonReady;
@property (nonatomic,weak)UIButton *buttonYet;
@property (nonatomic,weak)UILabel *labelLine;
@property (nonatomic,strong)NSString *code;
@end

@implementation VCAllotPersonManager

-(void)setUI
{
    UIButton *buttonReady = [[UIButton alloc]initWithFrame:CGRectMake(0, kTopHeight, Scree_width/2, 44)];
    buttonReady.tag = 10;
    [buttonReady setTitle:@"未分配" forState:UIControlStateNormal];
    [buttonReady setTitleColor:GetColor(139, 4, 174, 1) forState:UIControlStateNormal];
    [buttonReady addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonReady];
    self.buttonReady = buttonReady;
    
    UIButton *buttonYet = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width/2, kTopHeight, Scree_width/2, 44)];
    buttonYet.tag = 20;
    [buttonYet setTitle:@"已分配" forState:UIControlStateNormal];
    [buttonYet setTitleColor:GetColor(155,155,155,1) forState:UIControlStateNormal];
    [buttonYet addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonYet];
    self.buttonYet = buttonYet;
    
    UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(0, kTopHeight+44, Scree_width/2, 1)];
    labelLine.backgroundColor = GetColor(139, 4, 174, 1);
    [self.view addSubview:labelLine];
    self.labelLine = labelLine;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight+45, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[CellChargeManager class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
-(void)getHttpData:(NSString *)type
{
    NSString *urlStr =[NSString stringWithFormat:@"%@stores/selectstoretype.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"type":@"1",
                           @"types":type
                           };
    [self.arrayData removeAllObjects];
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.arrayData = [[responseObject valueForKey:@"lists"]mutableCopy];
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)changeState:(UIButton *)button
{
    if (button.tag == 10) {
        [self.buttonReady setTitleColor:GetColor(139, 4, 174, 1) forState:UIControlStateNormal];
        [self.buttonYet setTitleColor:GetColor(155,155,155,1) forState:UIControlStateNormal];
        self.labelLine.frame = CGRectMake(0, kTopHeight+44, Scree_width/2, 1);
        [self getHttpData:@"1"];
    }else
    {
        [self.buttonYet setTitleColor:GetColor(139, 4, 174, 1) forState:UIControlStateNormal];
        [self.buttonReady setTitleColor:GetColor(155,155,155,1) forState:UIControlStateNormal];
        self.labelLine.frame = CGRectMake(Scree_width/2, kTopHeight+44, Scree_width/2, 1);
        [self getHttpData:@"2"];
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
    CellChargeManager *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CellChargeManager alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.dict = self.arrayData[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayData[indexPath.row];
    VCPeopleShopManager *vc = [[VCPeopleShopManager alloc]init];
    vc.roleID = [NSString stringWithFormat:@"%@",dict[@"roleId"]];
    vc.userID = [NSString stringWithFormat:@"%@",dict[@"usersid"]];
    vc.stringTitle = dict[@"name"];
    vc.stringCode = self.code;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.buttonReady setTitleColor:GetColor(139, 4, 174, 1) forState:UIControlStateNormal];
    [self.buttonYet setTitleColor:GetColor(155,155,155,1) forState:UIControlStateNormal];
    self.labelLine.frame = CGRectMake(0, kTopHeight+44, Scree_width/2, 1);
    [self getHttpData:@"1"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"待分配人员";
    [self setUI];
    self.arrayData = [NSMutableArray array];
    self.code = @"2";
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
