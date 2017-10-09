//
//  VCUnPassed.m
//  Administration
//
//  Created by zhang on 2017/10/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCUnPassed.h"
#import "VCArtMonthUnPassed.h"
#import "VCArtWeekUnPassed.h"
#import "VCArtShopUnPassed.h"
#import "VCArtWeekSummaryUnPassed.h"
#import "VCArtMonthSummaryUnPassed.h"
#import "VCBuessShopUnPassed.h"
#import "VCBuessWeekUnPassed.h"
#import "VCBuessWeekSummaryUnPassed.h"
#import "VCInsideShopUnPassed.h"
#import "VCInsideWeekUnPassed.h"
#import "VCInsideWeekSummaryUnPassed.h"
#import "VCInsideMonthUnPassed.h"
#import "VCInsideMonthSummaryUnPassed.h"
#import "CellSummaryList.h"
@interface VCUnPassed ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UILabel *label;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,assign)NSUInteger page;
@property (nonatomic,assign)BOOL isFirstLoadData;
@property (nonatomic,assign)BOOL isRefreshFooter;
@property (nonatomic,strong)NSDictionary *remark;
@end

@implementation VCUnPassed

#pragma -mark custem

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryUserOwnReport",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"Sort":[ShareModel shareModel].sort,
                           @"page":[NSString stringWithFormat:@"%lu",(unsigned long)self.page],
                           @"DepartmentID":[ShareModel shareModel].departmentID,
                           @"flag":@"2",
                           @"Num":[ShareModel shareModel].num
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            for (NSDictionary *dictL in [responseObject valueForKey:@"lists"]) {
                [self.arrayData addObject:dictL];
            }
            if (self.arrayData.count!=0) {
                self.label.text = [NSString stringWithFormat:@"    未通过报表（%ld）",self.arrayData.count];
            }
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
            return;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    self.page = 1;
    self.isFirstLoadData = NO;
    self.isRefreshFooter = NO;
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"    未通过报表";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = GetColor(192, 192, 192, 1);
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 1.0f;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(-1);
        make.right.mas_equalTo(self.view.mas_right).offset(1);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.mas_equalTo(21);
    }];
    self.label = label;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [tableView registerClass:[CellSummaryList class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(label.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    //添加下拉刷新
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        
        self.isRefreshFooter = NO;
        [self.arrayData removeAllObjects];
        [self getHttpData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    
    
    //上拉加载
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.page++;
        
        self.isRefreshFooter = YES;
        
        [self getHttpData];
        
    }];
    
    tableView.mj_footer.automaticallyChangeAlpha = YES;
    self.tableView = tableView;
    
    self.tableView = tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellSummaryList *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellSummaryList alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = self.arrayData[indexPath.row];
    [self.remark enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:[NSString stringWithFormat:@"%@",dict[@"remark"]]]) {
            NSString *string = [NSString stringWithFormat:@"%@",obj];
            cell.labelMode.text = [string substringWithRange:NSMakeRange(2, 3)];
            *stop = YES;
        }
    }];
    
    
        NSString *string = [dict[@"updateTime"]substringWithRange:NSMakeRange(5, 11)];
        cell.labelState.text = [NSString stringWithFormat:@"未通过%@",string];
        cell.labelState.textColor = GetColor(240, 53, 68, 1);
    
    if ([[ShareModel shareModel].sort isEqualToString:@"1"]) {
        if (dict[@"dateLine"]) {
            cell.labelTime.text = [dict[@"dateLine"] substringToIndex:10];
        }
        
        if (dict[@"dates"]) {
            cell.labelUpTime.text = [dict[@"dates"] substringWithRange:NSMakeRange(5, 11)];
        }
    }else if([[ShareModel shareModel].sort isEqualToString:@"2"])
    {
        NSString *startDate;
        NSString *endDate;
        if (![dict[@"startDate"] isKindOfClass:[NSNull class]]) {
            startDate = [dict[@"startDate"] substringToIndex:10];
        }
        if (![dict[@"endDate"] isKindOfClass:[NSNull class]]) {
            endDate = [dict[@"endDate"] substringToIndex:10];
        }
        cell.labelTime.text = [NSString stringWithFormat:@"%@至%@",startDate,endDate];
        cell.labelUpTime.text = [dict[@"dates"] substringWithRange:NSMakeRange(5, 11)];
    }else
    {
        cell.labelTime.text = [dict[@"months"]substringToIndex:7];
        cell.labelUpTime.text = [dict[@"dates"] substringWithRange:NSMakeRange(5, 11)];
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayData[indexPath.row];
    NSString *remark = dict[@"remark"];
    NSString *tableID = dict[@"id"];
    NSString *roleID = [ShareModel shareModel].roleID;
    NSString *sort = [ShareModel shareModel].sort;
    NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
    
    if ([sort isEqualToString:@"1"]) {
        if ([roleID isEqualToString:@"2"]||[roleID isEqualToString:@"6"]||[roleID isEqualToString:@"10"]) {
            VCArtShopUnPassed  *vc = [[VCArtShopUnPassed alloc]init];
            vc.remark = remark;
            vc.tableID = tableID;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([roleID isEqualToString:@"5"]||[roleID isEqualToString:@"8"]||[roleID isEqualToString:@"9"]) {
            //跳转业务界面
            VCBuessShopUnPassed *vc = [[VCBuessShopUnPassed alloc]init];
            vc.remark = remark;
            vc.tableID = tableID;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            VCInsideShopUnPassed *vc = [[VCInsideShopUnPassed alloc]init];
            vc.remark = remark;
            vc.tableID = tableID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if ([sort isEqualToString:@"2"]) {
        if ([roleID isEqualToString:@"2"]||[roleID isEqualToString:@"6"]||[roleID isEqualToString:@"10"]) {
            if ([code isEqualToString:@"1"]) {
                VCArtWeekUnPassed *vc = [[VCArtWeekUnPassed alloc]init];
                vc.remark = remark;
                vc.isSelect = YES;
                vc.tableID = tableID;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCArtWeekSummaryUnPassed *vc = [[VCArtWeekSummaryUnPassed alloc]init];
                vc.isSelect = NO;
                vc.remark = remark;
                vc.tableID = tableID;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if ([roleID isEqualToString:@"5"]||[roleID isEqualToString:@"8"]||[roleID isEqualToString:@"9"]) {
            //跳转业务界面
            if ([code isEqualToString:@"1"]) {
                VCBuessWeekUnPassed *vc = [[VCBuessWeekUnPassed alloc]init];
                vc.isSelect= YES;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCBuessWeekSummaryUnPassed *vc = [[VCBuessWeekSummaryUnPassed alloc]init];
                vc.isSelect = NO;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else
        {
            if ([code isEqualToString:@"1"]) {
                VCInsideWeekUnPassed *vc = [[VCInsideWeekUnPassed alloc]init];
                vc.isSelect = YES;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCInsideWeekSummaryUnPassed *vc = [[VCInsideWeekSummaryUnPassed alloc]init];
                vc.isSelect = NO;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }
    if ([sort isEqualToString:@"3"]) {
        if ([roleID isEqualToString:@"2"]||[roleID isEqualToString:@"6"]||[roleID isEqualToString:@"10"]) {
            
            if ([code isEqualToString:@"1"]) {
                VCArtMonthUnPassed *vc = [[VCArtMonthUnPassed alloc]init];
                vc.isSelect = YES;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCArtMonthSummaryUnPassed *vc = [[VCArtMonthSummaryUnPassed alloc]init];
                vc.isSelect = YES;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else  {
            if ([code isEqualToString:@"1"]) {
                VCInsideMonthUnPassed *vc = [[VCInsideMonthUnPassed alloc]init];
                vc.isSelect = YES;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCInsideMonthSummaryUnPassed *vc = [[VCInsideMonthSummaryUnPassed alloc]init];
                vc.isSelect = NO;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }

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
    self.title = @"未通过";
    
    self.arrayData = [NSMutableArray array];
    
    [self setUI];
    
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
