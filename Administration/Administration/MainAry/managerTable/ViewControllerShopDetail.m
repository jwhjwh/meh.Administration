//
//  ViewControllerShopDetail.m
//  Administration
//
//  Created by zhang on 2017/8/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewControllerShopDetail.h"
#import "ViewControllerPerson.h"
#import "ViewControllerStayCheck.h"
#import "ViewControllerAllTable.h"
@interface ViewControllerShopDetail ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSArray *array;
@property (nonatomic,strong)NSMutableArray *arrayData;
@end

@implementation ViewControllerShopDetail

#pragma -mark custem
-(void)getData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/selectDayDayReportState",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS valueForKey:@"userid"],@"CompanyInfoId":compid,@"Num":self.num,@"Sort":@"1",@"RoleId":self.roleId,@"DepartmentID":self.departmanetID};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *stringCode = [responseObject valueForKey:@"status"];
        if ([stringCode isEqualToString:@"0000"]) {
            
            return ;
        }
        if ([stringCode isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"token请求超时" andInterval:1];
            return ;
        }
        if ([stringCode isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return ;
        }
        if ([stringCode isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常" andInterval:1];
            return ;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}

#pragma -mark tableVew
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.array[indexPath.row];
    if (indexPath.row==1) {
        if (self.arrayData.count!=0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%ld)",self.array[1],self.arrayData.count];
        }
        cell.textLabel.text = self.array[1];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        ViewControllerPerson *vc = [[ViewControllerPerson alloc]init];
        vc.num = self.num;
        vc.departmentID = self.departmanetID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==1)
    {
        ViewControllerStayCheck *vc = [[ViewControllerStayCheck alloc]init];
        vc.arrayData = self.arrayData;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        ViewControllerAllTable *vc = [[ViewControllerAllTable alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
    self.array = @[@"按员工查看",@"待审核",@"所有报表"];
    self.arrayData = [NSMutableArray array];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
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
