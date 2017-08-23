//
//  ViewControllerShopTable.m
//  Administration
//
//  Created by zhang on 2017/8/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewControllerShopTable.h"
#import "ViewControllerChildShop.h"
@interface ViewControllerShopTable ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSArray *array;
@end

@implementation ViewControllerShopTable
#pragma custom
-(void)getAllShop
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryUserDepartment.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS valueForKey:@"userid"],@"CompanyInfoId":compid,@"RoleId":self.roleId};
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *string = [responseObject valueForKey:@"status"];
        if ([string isEqualToString:@"0000"]) {
            self.array = [responseObject valueForKey:@"list"];
            [self.tableView reloadData];
            return ;
        }
        if ([string isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"token请求超时" andInterval:1];
            return;
        }
        if ([string isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return;
        }
        if ([string isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据空" andInterval:1];
            return;
        }
        
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dict = self.array[indexPath.row];
    cell.textLabel.text = dict[@"Name"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.array[indexPath.row];
    ViewControllerChildShop *vc = [[ViewControllerChildShop alloc]init];
    vc.num =[NSString stringWithFormat:@"%d",[dict[@"Num"]intValue]];
    vc.roleId = self.roleId;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma -mark system
-(void)viewWillAppear:(BOOL)animated
{
    [self getAllShop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.array = [NSArray array];
    
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
