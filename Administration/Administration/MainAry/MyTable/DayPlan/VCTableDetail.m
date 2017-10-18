//
//  VCTableDetail.m
//  Administration
//
//  Created by zhang on 2017/9/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCTableDetail.h"
#import "CellDetail.h"
@interface VCTableDetail ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *arrayDate;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSString *stringDate;
@property (nonatomic,strong)NSString *stringDescribe;
@property (nonatomic,strong)NSDictionary *dict;
@end

@implementation VCTableDetail
#pragma -mark custem
-(void)getData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryDayPlanInfo",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSDictionary *dict = @{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS valueForKey:@"userid"],@"CompanyInfoId":compid,@"id":self.dayPlabID,@"RoleId":[ShareModel shareModel].roleID};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.stringDate = [[responseObject valueForKey:@"date"] substringToIndex:10];
            self.stringDescribe = [responseObject valueForKey:@"describe"];
            self.arrayDate = [responseObject valueForKey:@"lists"];
            if (self.arrayDate.count!=0) {
                [self.tableView reloadData];
            }
           // [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:[CellDetail class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma -mark tableviw
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayDate.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }else
    {
        return 4;
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellDetail *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        cell = [[CellDetail alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.labelTitle.text = @"日期";
            cell.labelContent.text = self.stringDate;
        }
        if (indexPath.row==1) {
            cell.labelTitle.text = @"概要描述";
            cell.labelContent.text = self.stringDescribe;
        }
    }else
    {
        NSDictionary *dict = self.arrayDate[indexPath.section-1];
        
        cell.labelTitle.text = self.arrayTitle[indexPath.row];
        if (indexPath.row==0) {
            if (![dict[@"others"]isKindOfClass:[NSNull class]]) {
                cell.labelContent.text = dict[@"others"];
            }
            
        }
        if (indexPath.row==1) {
            if (![dict[@"jobAim"]isKindOfClass:[NSNull class]]) {
                cell.labelContent.text = dict[@"jobAim"];
            }
            
        }
        if (indexPath.row==2) {
            if (![dict[@"detailMethod"]isKindOfClass:[NSNull class]]) {
                cell.labelContent.text = dict[@"detailMethod"];
            }
            
        }
        if (indexPath.row==3) {
            if (![dict[@"helped"]isKindOfClass:[NSNull class]]) {
                cell.labelContent.text = dict[@"helped"];
            }
        }
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"";
    }else
    {
        return @"详细事项";
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.1;
    }else
    {
        return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    
    self.arrayTitle = @[@"事项",@"工作目标",@"具体方法思路",@"需要协调与帮助"];
    self.arrayDate = [NSArray array];
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
