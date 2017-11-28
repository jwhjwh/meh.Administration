//
//  ViewControllerPosition.m
//  Administration
//
//  Created by zhang on 2017/9/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewControllerPosition.h"
#import "ViewControllerAllTable.h"
@interface ViewControllerPosition ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView  *tableView;
@property (nonatomic,strong)NSArray *arrayl;
@property (nonatomic,strong)NSMutableString *power;
@end

@implementation ViewControllerPosition
#pragma -mark custem

-(void)getData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryUserDepartmentPosition",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr ,@"usersid":[USER_DEFAULTS valueForKey:@"userid"],@"CompanyInfoId":compid,@"RoleId":[USER_DEFAULTS valueForKey:@"roleId"],@"Num":self.num};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.arrayl = [responseObject valueForKey:@"list"];
            self.power = [[NSMutableString alloc]init];
            for (NSDictionary *dictinfo in self.arrayl) {
                [self.power appendString:[NSString stringWithFormat:@"%@,",dictinfo[@"num"]]];
            }
            
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
            return;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}
#pragma -mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayl.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dict = self.arrayl[indexPath.row];
    cell.textLabel.text = dict[@"newName"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayl[indexPath.row];
    ViewControllerAllTable *vc = [[ViewControllerAllTable alloc]init];
    vc.num = self.num;
    vc.rid = [NSString stringWithFormat:@"%@",dict[@"num"]];
    vc.departmentID = self.departmentID;
    vc.power = self.power;
    vc.positionName = dict[@"newName"];
    vc.choseRoleid = [NSString stringWithFormat:@"%@",dict[@"num"]];
    [ShareModel shareModel].postionName = dict[@"newName"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma -mark systrm

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"按职位查看";
    
    self.power = [[NSMutableString alloc]init];
    
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
