 //
//  VCDepartDetailMobai.m
//  Administration
//
//  Created by zhang on 2017/11/9.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCDepartDetailMobai.h"
#import "VCPersonMobai.h"
#import "VCMobaiNotCheck.h"
#import "VCMobaiAllCheck.h"
@interface VCDepartDetailMobai ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arrayDate;
@property (nonatomic,strong)NSString *stringCount;
@end

@implementation VCDepartDetailMobai

#pragma -mark custem

-(void)getHttpDate
{
    NSString *urlStr;
    if ([[ShareModel shareModel].state isEqualToString:@"1"]) {
        urlStr = [NSString stringWithFormat:@"%@shop/selectWorshipRecordcount.action",KURLHeader];
    }else if ([[ShareModel shareModel].state isEqualToString:@"2"])
    {
        urlStr = [NSString stringWithFormat:@"%@shop/selectIntendedcount.action",KURLHeader];
    }else
    {
        urlStr = [NSString stringWithFormat:@"%@shop/selectTargetVisitcount.action",KURLHeader];
    }
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"RoleIds":[ShareModel shareModel].roleID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            if ([responseObject[@"count"] intValue]!=0) {
                self.stringCount = [NSString stringWithFormat:@"%@",responseObject[@"count"]];
                [self.arrayDate replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"未查看（%@）",self.stringCount]];
                [self.tableView reloadData];
                return ;
            }
            if ([code isEqualToString:@"4444"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
                return;
            }
            if ([code isEqualToString:@"1001 "]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
                return;
            }
            if ([code isEqualToString:@"0001"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
                return;
            }
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView  = tableView;
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayDate.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.arrayDate[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        VCPersonMobai *vc = [[VCPersonMobai alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==1)
    {
        VCMobaiNotCheck *vc = [[VCMobaiNotCheck alloc]init];
        vc.stringCount = self.stringCount;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        VCMobaiAllCheck *vc = [[VCMobaiAllCheck alloc]init];
        vc.stringTitle = self.arrayDate[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getHttpDate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.stringTitle;
    [self setUI];
    
    self.arrayDate = [NSMutableArray arrayWithObjects:@"指定搜索",@"未查看",@"已查看", nil];
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
