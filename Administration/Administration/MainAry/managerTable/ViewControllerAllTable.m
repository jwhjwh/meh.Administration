//
//  ViewControllerAllTable.m
//  Administration
//
//  Created by zhang on 2017/8/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewControllerAllTable.h"
#import "ViewControllerSelectTable.h"
#import "ViewControllerPersonTableDetail.h"
#import "VCInsideWeekTable.h"
#import "VCArtMonthTable.h"
#import "VCInsideMonthTable.h"
#import "VCBusinessWeekTable.h"
#import "VCWeekTable.h"
#import "CellTbale.h"
@interface ViewControllerAllTable ()<UITableViewDelegate,UITableViewDataSource>
{
    NSUInteger _page;//接口page
    //是不是第一次执行请求
    
    BOOL _isFirstLoadData ;
    
    //是不是上拉加载数据（脚视图刷新）
    
    BOOL _isFooterFresh ;
    
    UITableView *tableView1;
    UILabel *label;
    NSMutableArray *arrayData;
    NSDictionary *remark;
    
}
@end

@implementation ViewControllerAllTable

#pragma mark - 添加刷新

- (void)removeHUD:(id)hud

{
    
    //结束刷新
    
    [tableView1.mj_header endRefreshing];
    
    [tableView1.mj_footer endRefreshing];
    
    [hud removeFromSuperview];
    
}

-(void)gotoNext
{
    ViewControllerSelectTable *vc = [[ViewControllerSelectTable alloc]init];
    vc.departmentID = self.departmentID;
    vc.num = self.num;
    vc.positionName = self.positionName;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)getData
{
   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryPositionReport",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"Sort":[ShareModel shareModel].sort,
                           @"DepartmentID":self.departmentID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"Num":self.num,
                           @"rid":self.rid,
                           @"power":self.power,
                           @"page":[NSString stringWithFormat:@"%lu",(unsigned long)_page]};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *stringCode = [responseObject valueForKey:@"status"];
        [self performSelector:@selector(removeHUD:) withObject:hud afterDelay:0.5];
            [arrayData removeAllObjects];
        if ([stringCode isEqualToString:@"0000"]) {
            for (NSDictionary *dict in [responseObject valueForKey:@"list"]) {
                [arrayData addObject:dict];
            }
            [tableView1 reloadData];
            return ;

        }
        if ([stringCode isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1];
            return;
        }
        if ([stringCode isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([stringCode isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1.0];
        }
        
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

- (void)createRefresh

{
    UIView *view = [[UIView alloc]init];
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 0.5f;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.left.mas_equalTo(self.view.mas_left).offset(-1);
        make.right.mas_equalTo(self.view.mas_right).offset(-1);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundImage:[UIImage imageNamed:@"ss_ico01"]forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoNext) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = NO;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).offset(8);
        make.bottom.mas_equalTo(view.mas_bottom).offset(-8);
        make.left.mas_equalTo(view.mas_left).offset(20);
        make.right.mas_equalTo(view.mas_right).offset(-20);
    }];
    
    label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"    所有报表" ];
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 1.0f;
    label.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left).offset(-1);
        make.right.mas_equalTo(self.view.mas_right).offset(1);
        make.height.mas_equalTo(20);
    }];
    
    
    tableView1 = [[UITableView alloc]init];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView1];
    [self.view addSubview:tableView1];
    [tableView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    //添加下拉刷新
    
    tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 1;
        
        _isFooterFresh = NO;
        
        [self getData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    
    tableView1.mj_header.automaticallyChangeAlpha = YES;
    
    
    
    //上拉加载
    
    tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page++;
        
        _isFooterFresh = YES;
        
        [self getData];
        
        
        
    }];
    
    tableView1.mj_footer.automaticallyChangeAlpha = YES;
    
}

#pragma -mark tabelView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellTbale *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellTbale alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = arrayData[indexPath.row];
    [remark enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:[NSString stringWithFormat:@"%@",dict[@"remark"]]]) {
            NSString *string = [NSString stringWithFormat:@"%@",obj];
            cell.labelMold.text = [string substringWithRange:NSMakeRange(2, 3)];
            *stop = YES;
        }
    }];
    
    cell.lableName.text = dict[@"name"];
    cell.lableAccount.text = dict[@"phone"];
    cell.labelTime.text = dict[@"dates"];
    NSString *state = [NSString stringWithFormat:@"%@",dict[@"state"]];
    if ([state isEqualToString:@"0"]) {
        cell.labelStatus.text = @"待审核";
        cell.labelStatus.textColor = GetColor(192, 192, 192, 1);
    }else if ([state isEqualToString:@"1"])
    {
        cell.labelStatus.text = [NSString stringWithFormat:@"通过:%@",dict[@"updateTime"]];
        cell.labelStatus.textColor = GetColor(246, 0, 49, 1);
    }else
    {
        cell.labelStatus.text = [NSString stringWithFormat:@"驳回:%@",dict[@"updateTime"]];
        cell.labelStatus.textColor = GetColor(206, 157, 86, 1);
    }
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = arrayData[indexPath.row];
    NSString *roleID = [NSString stringWithFormat:@"%@",dict[@"roleId"]];
    if ([[ShareModel shareModel].sort isEqualToString:@"1"]) {
        ViewControllerPersonTableDetail *vc = [[ViewControllerPersonTableDetail alloc]init];
        vc.stringTitle = dict[@"name"];
        //  vc.roleId = self.rid;
        vc.departmentId = self.departmentID;
        vc.postionName = self.positionName;
        vc.remark = dict[@"remark"];
        vc.tableId = dict[@"id"];
        vc.num = self.num;
        //  VCInsideWeekTable *vc = [[VCInsideWeekTable alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([[ShareModel shareModel].sort isEqualToString:@"2"])
    {
        if ([roleID isEqualToString:@"2"]||[roleID isEqualToString:@"6"]||[roleID isEqualToString:@"10"]) {
            VCWeekTable *vc = [[VCWeekTable alloc]init];
            vc.stringTitle = dict[@"name"];
            //  vc.roleId = self.rid;
            vc.departmentId = self.departmentID;
            vc.postionName = self.positionName;
            vc.remark = dict[@"remark"];
            vc.tableId = dict[@"id"];
            vc.num = self.num;
            if ([dict[@"code"] intValue]==1) {
                vc.isSelect = YES;
                vc.tableId = dict[@"id"];
            }else
            {
                vc.isSelect = NO;
                vc.summaryId = dict[@"id"];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }else if([roleID isEqualToString:@"5"]||[roleID isEqualToString:@"8"]||[roleID isEqualToString:@"9"])
        {
            VCBusinessWeekTable *vc = [[VCBusinessWeekTable alloc]init];
            vc.stringTitle = dict[@"name"];
            // vc.roleId = self.rid;
            vc.departmentId = self.departmentID;
            vc.postionName = self.positionName;
            vc.remark = dict[@"remark"];
            vc.tableId = dict[@"id"];
            vc.num = self.num;
            if ([dict[@"code"] intValue]==1) {
                vc.isSelect = YES;
                vc.tableId = dict[@"id"];
            }else
            {
                vc.isSelect = NO;
                vc.summaryId = dict[@"id"];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            VCInsideWeekTable *vc = [[VCInsideWeekTable alloc]init];
            vc.stringTitle = dict[@"name"];
            //  vc.roleId = self.rid;
            vc.departmentId = self.departmentID;
            vc.postionName = self.positionName;
            vc.remark = dict[@"remark"];
            vc.tableId = dict[@"id"];
            vc.num = self.num;
            if ([dict[@"code"] intValue]==1) {
                vc.isSelect = YES;
                vc.tableId = dict[@"id"];
            }else
            {
                vc.isSelect = NO;
                vc.summaryId = dict[@"id"];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else
    {
        if ([roleID isEqualToString:@"2"]||[roleID isEqualToString:@"6"]||[roleID isEqualToString:@"10"])
        {
            VCArtMonthTable *vc = [[VCArtMonthTable alloc]init];
            vc.stringTitle = dict[@"name"];
            // vc.roleId = self.rid;
            vc.departmentId = self.departmentID;
            vc.postionName = self.positionName;
            vc.remark = dict[@"remark"];
            vc.tableId = dict[@"id"];
            vc.num = self.num;
            if ([dict[@"code"] intValue]==1) {
                vc.isSelect = YES;
                vc.tableId = dict[@"id"];
            }else
            {
                vc.isSelect = NO;
                vc.summaryId = dict[@"id"];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            VCInsideMonthTable *vc = [[VCInsideMonthTable alloc]init];
            vc.stringTitle = dict[@"name"];
            //  vc.roleId = self.rid;
            vc.departmentId = self.departmentID;
            vc.postionName = self.positionName;
            vc.remark = dict[@"remark"];
            vc.tableId = dict[@"id"];
            vc.num = self.num;
            if ([dict[@"code"] intValue]==1) {
                vc.isSelect = YES;
                vc.tableId = dict[@"id"];
            }else
            {
                vc.isSelect = NO;
                vc.summaryId = dict[@"id"];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [arrayData removeAllObjects];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"所有报表";
    
    _isFirstLoadData = YES;
    
    //不是上拉加载数据
    
    _isFooterFresh = NO;
    
    //页码赋初值
    
    _page=1;
    
    [self createRefresh];
  //  [self setUI];
    
    
    arrayData = [NSMutableArray array];
    
    remark = @{@"1":@"业务日报表",
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
