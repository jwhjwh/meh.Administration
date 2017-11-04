//
//  VCDrafts.m
//  Administration
//
//  Created by zhang on 2017/9/26.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCDrafts.h"
#import "CellDrafts.h"
#import "VCArtShopDrfts.h"
#import "VCInsideShopDrafts.h"
#import "VCBuessShopDrafts.h"
#import "VCArtWeekDrafts.h"
#import "VCArtWeekSummaryDrafts.h"
#import "VCArtMonthDrafts.h"
#import "VCArtMonthSummaryDrafts.h"
#import "VCInsideWeekDrafts.h"
#import "VCInsideWeekSummaryDrafts.h"
#import "VCInsideMonthDrafts.h"
#import "VCInsideMonthSummaryDrafts.h"
#import "VCBuessWeekDrafts.h"
#import "VCBuessWeekSummaryDrafts.h"
@interface VCDrafts ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,strong)NSDictionary *remark;
@property (nonatomic,assign)NSUInteger _page;//接口page
//是不是第一次执行请求
@property (nonatomic)BOOL _isFirstLoadData ;
//是不是上拉加载数据（脚视图刷新）
@property (nonatomic)BOOL _isFooterFresh ;
@end

@implementation VCDrafts

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
                           @"page":[NSString stringWithFormat:@"%ld",self._page],
                           @"DepartmentID":[ShareModel shareModel].departmentID,
                           @"flag":@"3",
                           @"Num":[ShareModel shareModel].num};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            
            for (NSDictionary *dict in [responseObject valueForKey:@"lists"] ) {
                [self.arrayData addObject:dict];
            }
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return ;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    UILabel *label = [[UILabel alloc]init];
    label.text = @"    最近报表";
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 1.0f;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(-1);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.right.mas_equalTo(self.view.mas_right).offset(1);
        make.height.mas_equalTo(21);
    }];
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[CellDrafts class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(label.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self._page = 1;
        
        self._isFooterFresh = NO;
        [self.arrayData removeAllObjects];
        [self getData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    
    
    //上拉加载
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self._page++;
        
        self._isFooterFresh = YES;
        
        [self getData];
    }];
    
    tableView.mj_footer.automaticallyChangeAlpha = YES;
    
    
    self._isFirstLoadData = YES;
    
    //不是上拉加载数据
    
    self._isFooterFresh = NO;
    
    //页码赋初值
    
    self._page=1;
    self.tableView = tableView;
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellDrafts *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellDrafts alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = self.arrayData[indexPath.row];
    [self.remark enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:[NSString stringWithFormat:@"%@",dict[@"remark"]]]) {
            NSString *string = [NSString stringWithFormat:@"%@",obj];
            cell.labelName.text = [string substringWithRange:NSMakeRange(2, 3)];
            *stop = YES;
        }
    }];
    if ([[ShareModel shareModel].sort isEqualToString:@"1"]) {
        cell.dict = dict;
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
                    VCArtShopDrfts  *vc = [[VCArtShopDrfts alloc]init];
                    vc.remark = remark;
                    vc.tableID = tableID;
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([roleID isEqualToString:@"5"]||[roleID isEqualToString:@"8"]||[roleID isEqualToString:@"9"]) {
                    //跳转业务界面
                    VCBuessShopDrafts *vc = [[VCBuessShopDrafts alloc]init];
                    vc.remark = remark;
                    vc.tableID = tableID;
                    [self.navigationController pushViewController:vc animated:YES];
                }else
                {
                    VCInsideShopDrafts *vc = [[VCInsideShopDrafts alloc]init];
                    vc.remark = remark;
                    vc.tableID = tableID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
        }
        if ([sort isEqualToString:@"2"]) {
            if ([roleID isEqualToString:@"2"]||[roleID isEqualToString:@"6"]||[roleID isEqualToString:@"10"]) {
                if ([code isEqualToString:@"1"]) {
                    VCArtWeekDrafts *vc = [[VCArtWeekDrafts alloc]init];
                    vc.remark = remark;
                    vc.isSelect = YES;
                    vc.code = code;
                    vc.tableID = tableID;
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }else
                {
                    VCArtWeekSummaryDrafts *vc = [[VCArtWeekSummaryDrafts alloc]init];
                    vc.isSelect = NO;
                    vc.remark = remark;
                    vc.code = code;
                    vc.tableID = tableID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }else if ([roleID isEqualToString:@"5"]||[roleID isEqualToString:@"8"]||[roleID isEqualToString:@"9"]) {
                //跳转业务界面
                if ([code isEqualToString:@"1"]) {
                    VCBuessWeekDrafts *vc = [[VCBuessWeekDrafts alloc]init];
                    vc.isSelect= YES;
                    vc.tableID = tableID;
                    vc.code = code;
                    vc.remark = remark;
                    [self.navigationController pushViewController:vc animated:YES];
                }else
                {
                    VCBuessWeekSummaryDrafts *vc = [[VCBuessWeekSummaryDrafts alloc]init];
                    vc.isSelect = NO;
                    vc.tableID = tableID;
                    vc.code = code;
                    vc.remark = remark;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }else
            {
                if ([code isEqualToString:@"1"]) {
                    VCInsideWeekDrafts *vc = [[VCInsideWeekDrafts alloc]init];
                    vc.isSelect = YES;
                    vc.tableID = tableID;
                    vc.code = code;
                    vc.remark = remark;
                    [self.navigationController pushViewController:vc animated:YES];
                }else
                {
                    VCInsideWeekSummaryDrafts *vc = [[VCInsideWeekSummaryDrafts alloc]init];
                    vc.isSelect = NO;
                    vc.tableID = tableID;
                    vc.code = code;
                    vc.remark = remark;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            
        }
      if ([sort isEqualToString:@"3"]) {
        if ([roleID isEqualToString:@"2"]||[roleID isEqualToString:@"6"]||[roleID isEqualToString:@"10"]) {
            
            if ([code isEqualToString:@"1"]) {
                VCArtMonthDrafts *vc = [[VCArtMonthDrafts alloc]init];
                vc.isSelect = YES;
                vc.tableID = tableID;
                vc.code = code;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCArtMonthSummaryDrafts *vc = [[VCArtMonthSummaryDrafts alloc]init];
                vc.isSelect = YES;
                vc.tableID = tableID;
                vc.code = code;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else  {
            if ([code isEqualToString:@"1"]) {
                VCInsideMonthDrafts *vc = [[VCInsideMonthDrafts alloc]init];
                vc.isSelect = YES;
                vc.tableID = tableID;
                vc.code = code;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                VCInsideMonthSummaryDrafts *vc = [[VCInsideMonthSummaryDrafts alloc]init];
                vc.isSelect = NO;
                vc.tableID = tableID;
                vc.code = code;
                vc.remark = remark;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    
    self.title = self.stringTitle;
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
