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
#import "VCWeekTable.h"
#import "CellTbale.h"
@interface ViewControllerPersonTable ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,strong) NSDictionary *remark;
@end

@implementation ViewControllerPersonTable
#pragma -mark custem
-(void)getData
{
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
                           @"page":@"1",
                           @"id":self.userid,
                           @"rid":self.rid};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *stringCode = [responseObject valueForKey:@"status"];
        if ([stringCode isEqualToString:@"0000"]) {
            self.array = [responseObject valueForKey:@"list"];
            [self.tableView reloadData];
            return ;
        }
        if ([stringCode isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"token请求超时" andInterval:1];
            return;
        }
        if ([stringCode isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return;
        }
        if ([stringCode isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据为空" andInterval:1];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self.remark enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:[NSString stringWithFormat:@"%@",dict[@"remark"]]]) {
            NSString *string = [NSString stringWithFormat:@"%@",obj];
            cell.labelMold.text = [string substringWithRange:NSMakeRange(2, 3)];
            *stop = YES;
        }
    }];
    
    cell.lableName.text = dict[@"name"];
    cell.lableAccount.text = @"13100000000";
    cell.labelTime.text = dict[@"dates"];
    cell.labelStatus.text = @"驳回：06-03 12:30";
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"所有报表";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.array[indexPath.row];
    ViewControllerPersonTableDetail *vc = [[ViewControllerPersonTableDetail alloc]init];
    vc.stringTitle = dict[@"name"];
    vc.roleId = self.rid;
    vc.departmentId = self.departmentId;
    vc.postionName = self.positionName;
    vc.remark = dict[@"remark"];
    vc.tableId = dict[@"id"];
  //  VCInsideWeekTable *vc = [[VCInsideWeekTable alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
