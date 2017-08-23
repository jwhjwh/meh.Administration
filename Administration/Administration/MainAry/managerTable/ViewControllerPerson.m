//
//  ViewControllerPerson.m
//  Administration
//
//  Created by zhang on 2017/8/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewControllerPerson.h"
#import "ViewControllerPersonTable.h"
@interface ViewControllerPerson ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSArray *array;
@end

@implementation ViewControllerPerson
#pragma -mark custem
-(void)getData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/selectUsersid.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info = [[NSDictionary alloc]init];
    
        info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Num":self.num,@"RoleId":[USER_DEFAULTS valueForKey:@"roleId"],@"DepartmentId":self.departmentID};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            self.array = [responseObject valueForKey:@"list"];
            [_tableView reloadData];
        }
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登陆,请重新登录" andInterval:1];
            return ;
            
        }if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"登录超时,请重新登录" andInterval:1];
            return;
            
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];

}
#pragma -mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"xingming";
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  NSDictionary *dict = self.array[indexPath.row];
    ViewControllerPersonTable *vc = [[ViewControllerPersonTable alloc]init];
    vc.stringTitle = @"mingzi";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"按员工查看";
    self.array = [NSArray array];
    
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