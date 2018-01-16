//
//  VCPostionPerson.m
//  Administration
//
//  Created by zhang on 2017/11/16.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCPostionPerson.h"
#import "CellMobaiPerson.h"
@interface VCPostionPerson ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UITableView *tablView;
@end

@implementation VCPostionPerson

#pragma -mark custem
-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/selelctDRusers.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":self.postionID,
                           @"departmentID":[ShareModel shareModel].departmentID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.arrayData = [[responseObject valueForKey:@"list"]mutableCopy];
            [self.tablView reloadData];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0f];
            return;
        }
        if ([code isEqualToString:@"1001 "]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0f];
            return;
        }
        if ([code isEqualToString:@"5002"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0f];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}

-(void)back
{
    UIViewController * viewControllerWithdraw = nil;
    for (UIViewController * viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:NSClassFromString(@"VCAddAreaPermision")])
        {
            viewControllerWithdraw = viewController;
            [self.navigationController popToViewController:viewControllerWithdraw animated:YES];
            break;
        }
    }
}

-(void)setUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [tableView registerClass:[CellMobaiPerson class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tablView = tableView;
}

#pragma -mark tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellMobaiPerson *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellMobaiPerson alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
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
    
    NSMutableArray *array = [[ShareModel shareModel].arrayData[[ShareModel shareModel].indexPath.section]mutableCopy];
    NSMutableDictionary *dictInfo = [array[[ShareModel shareModel].indexPath.row]mutableCopy];
    [dictInfo setValue:dict[@"name"] forKey:@"name"];
    [dictInfo setValue:[NSString stringWithFormat:@"%@",dict[@"departmentID"]] forKey:@"departmentId"];
    if ([dict[@"icon"]isKindOfClass:[NSNull class]]) {
        [dictInfo setValue:@"" forKey:@"icon"];
    }else
    {
         [dictInfo setValue:dict[@"icon"] forKey:@"icon"];
    }
    [dictInfo setValue:[NSString stringWithFormat:@"%@",dict[@"usersid"]] forKey:@"selectUserId"];
    [dictInfo setValue:[NSString stringWithFormat:@"%@",dict[@"roleId"]] forKey:@"roleId"];
    [array replaceObjectAtIndex:[ShareModel shareModel].indexPath.row withObject:dictInfo];
    [[ShareModel shareModel].arrayData replaceObjectAtIndex:[ShareModel shareModel].indexPath.section withObject:array];
    [self back];
    
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
    self.title = self.stringTitle;
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
