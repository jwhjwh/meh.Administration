//
//  VCPositil.m
//  Administration
//
//  Created by zhang on 2017/10/9.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCPositil.h"
#import "CellPostil.h"
@interface VCPositil ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSArray *arrayTitle;
@end

@implementation VCPositil

#pragma -mark custem
-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@manager/queryReportPostilInfo",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"DepartmentID":[ShareModel shareModel].departmentID,
                           @"field":self.field,
                           @"reportId":self.reportID,
                           @"remark":self.remark,
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            NSArray *arrayL = [responseObject valueForKey:@"list"];
            NSMutableArray *arrD1 = [NSMutableArray array];
            NSMutableArray *arrD2 = [NSMutableArray array];
            NSMutableArray *arrD3 = [NSMutableArray array];
            NSMutableArray *arrD4 = [NSMutableArray array];
            for (NSDictionary *dictionary in arrayL) {
                NSString *roleID = [NSString stringWithFormat:@"%@",dictionary[@"roleId"]];
                
                if ([roleID isEqualToString:@"10"]||[roleID isEqualToString:@"9"]||[roleID isEqualToString:@"11"]) {
                    [arrD1 addObject:dictionary];
                }else if([roleID isEqualToString:@"8"]||[roleID isEqualToString:@"6"]||[roleID isEqualToString:@"12"]||[roleID isEqualToString:@"13"]||[roleID isEqualToString:@"15"])
                {
                    [arrD2 addObject:dictionary];
                }else if ([roleID isEqualToString:@"7"])
                {
                    [arrD3 addObject:dictionary];
                }else
                {
                    [arrD4 addObject:dictionary];
                }
            }
           self.arrayData = [NSMutableArray arrayWithObjects:arrD1,arrD2,arrD3,arrD4, nil];
            NSLog(@"---------%@",self.arrayData);
            [self.tableView reloadData];
        }
        
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"0003"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有权限" andInterval:1.0];
            return ;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}

-(void)setUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 120;
    [tableView registerClass:[CellPostil class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma -mark tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayTitle.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.arrayData[section];
    return arr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 50)];
    label.text = [NSString stringWithFormat:@"  %@",self.arrayTitle[section]];
    label.backgroundColor = [UIColor whiteColor];
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellPostil *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellPostil alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.arrayData[indexPath.section][indexPath.row];
    cell.textView1.text = dict[@"location"];
    cell.textView1.userInteractionEnabled = NO;
    cell.textView2.text = dict[@"comment"];
    cell.textView2.userInteractionEnabled = NO;
    cell.buttonComp.hidden = YES;
    cell.labelTime.hidden = YES;
    return cell;
}

#pragma -mark system
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getHttpData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"批注";
    
    self.arrayTitle = @[@"总监批注",@"经理批注",@"行政批注",@"老板批注"];
    
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
