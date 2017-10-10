//
//  VCSubmited.m
//  Administration
//
//  Created by zhang on 2017/9/30.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCSubmited.h"
#import "VCSearchSubmited.h"
#import "CellSummaryList.h"
#import "VCArtShopSubmited.h"
#import "VCArtWeekSubmited.h"
#import "VCArtWeekSummarySubmited.h"
#import "VCArtMonthSubmited.h"
#import "VCArtMonthSummarySubmited.h"
#import "VCInsideShopSubmited.h"
#import "VCInsideWeekSubmited.h"
#import "VCInsideWeekSummarySubmited.h"
#import "VCInsideMonthSubmited.h"
#import "VCInsideMonthSummarySubmited.h"
#import "VCBuessShopSubmit.h"
#import "VCBuessWeekSubmited.h"
#import "VCBuessWeekSummarySubmited.h"

@interface VCSubmited ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,assign)NSUInteger page;
@property (nonatomic,assign)BOOL isFirstLoadData;
@property (nonatomic,assign)BOOL isRefreshFooter;
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,strong)NSDictionary *remark;
@end

@implementation VCSubmited

#pragma -mark custem

-(void)getData
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
                           @"flag":@"1",
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
    
    UIView *viewT = [[UIView alloc]init];
    [self.view addSubview:viewT];
    [viewT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundImage:[UIImage imageNamed:@"ss_ico01"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoNext) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = NO;
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    [viewT addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewT.mas_left).offset(8);
        make.top.mas_equalTo(viewT.mas_top).offset(8);
        make.right.mas_equalTo(viewT.mas_right).offset(-8);
        make.bottom.mas_equalTo(viewT.mas_bottom).offset(-8);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"    最近报表";
    label.textColor = GetColor(192, 192, 192, 1);
    label.layer.borderWidth = 1.0f;
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(-1);
        make.top.mas_equalTo(viewT.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right).offset(1);
        make.height.mas_equalTo(21);
    }];
    
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
        make.top.mas_equalTo(label.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    //添加下拉刷新
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.arrayData removeAllObjects];
        self.page = 1;
        
        self.isRefreshFooter = NO;
        
        [self getData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    
    
    //上拉加载
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.page++;
        
        self.isRefreshFooter = YES;
        
        [self getData];
        
        
        
    }];
    
    tableView.mj_footer.automaticallyChangeAlpha = YES;
    self.tableView = tableView;
    
}

-(void)gotoNext
{
    VCSearchSubmited *vc = [[VCSearchSubmited alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma -mark tableView
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
    
    NSString *state = [NSString stringWithFormat:@"%@",dict[@"state"]];
    
    NSString *stringDate;
    if (![dict[@"updateTime"] isKindOfClass:[NSNull class]])
    {
        stringDate = [dict[@"updateTime"]substringWithRange:NSMakeRange(5, 11)];
    }
    
    if ([state isEqualToString:@"0"]) {
        cell.labelState.text = @"待审核";
    }else if([state isEqualToString:@"1"])
    {
        cell.labelState.text = [NSString stringWithFormat:@"已通过%@",stringDate];
    }else
    {
        cell.labelState.text = [NSString stringWithFormat:@"驳回%@",stringDate];
        cell.labelState.textColor = GetColor(240, 53, 68, 1);
    }
    
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
            VCArtShopSubmited  *vc = [[VCArtShopSubmited alloc]init];
            vc.remark = remark;
            vc.tableID = tableID;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([roleID isEqualToString:@"5"]||[roleID isEqualToString:@"8"]||[roleID isEqualToString:@"9"]) {
            //跳转业务界面
            VCBuessShopSubmit *vc = [[VCBuessShopSubmit alloc]init];
            vc.remark = remark;
            vc.tableID = tableID;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            VCInsideShopSubmited *vc = [[VCInsideShopSubmited alloc]init];
            vc.remark = remark;
            vc.tableID = tableID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if ([sort isEqualToString:@"2"]) {
        if ([roleID isEqualToString:@"2"]||[roleID isEqualToString:@"6"]||[roleID isEqualToString:@"10"]) {
            if ([code isEqualToString:@"1"]) {
                VCArtWeekSubmited *vc = [[VCArtWeekSubmited alloc]init];
                vc.remark = remark;
                vc.isSelect = YES;
                vc.tableID = tableID;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCArtWeekSummarySubmited *vc = [[VCArtWeekSummarySubmited alloc]init];
                vc.isSelect = NO;
                vc.remark = remark;
                vc.tableID = tableID;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if ([roleID isEqualToString:@"5"]||[roleID isEqualToString:@"8"]||[roleID isEqualToString:@"9"]) {
            //跳转业务界面
            if ([code isEqualToString:@"1"]) {
                VCBuessWeekSubmited *vc = [[VCBuessWeekSubmited alloc]init];
                vc.isSelect= YES;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCBuessWeekSummarySubmited *vc = [[VCBuessWeekSummarySubmited alloc]init];
                vc.isSelect = NO;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else
        {
            if ([code isEqualToString:@"1"]) {
                VCInsideWeekSubmited *vc = [[VCInsideWeekSubmited alloc]init];
                vc.isSelect = YES;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCInsideWeekSummarySubmited *vc = [[VCInsideWeekSummarySubmited alloc]init];
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
                VCArtMonthSubmited *vc = [[VCArtMonthSubmited alloc]init];
                vc.isSelect = YES;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCArtMonthSummarySubmited *vc = [[VCArtMonthSummarySubmited alloc]init];
                vc.isSelect = YES;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else  {
            if ([code isEqualToString:@"1"]) {
                VCInsideMonthSubmited *vc = [[VCInsideMonthSubmited alloc]init];
                vc.isSelect = YES;
                vc.tableID = tableID;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCInsideMonthSummarySubmited *vc = [[VCInsideMonthSummarySubmited alloc]init];
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
    [self getData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"已提交";
    
    [self setUI];
    
    self.arrayData = [NSMutableArray array];
    
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
