//
//  VCSearchSubmited.m
//  Administration
//
//  Created by zhang on 2017/10/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

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

@interface VCSearchSubmited ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UIButton *buttonStart;
@property (nonatomic,weak)UIButton *buttonEnd;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSString *today;
@property (nonatomic,weak)UIView *backView;
@property (nonatomic,weak)UILabel *labelTitle;
@property (nonatomic,weak)UIView *viewB;
@property (nonatomic,weak)UILabel *labelTime;
@property (nonatomic,weak)UIDatePicker *dataPick;
@property (nonatomic,weak)UIButton *buttonCancle;
@property (nonatomic,weak)UIButton *buttonSure;
@property (nonatomic,strong) NSDictionary *remark;
@property (nonatomic,strong)NSMutableArray *arrayData;

@property (nonatomic,assign)NSUInteger _page;//接口page
@property (nonatomic,assign)BOOL _isFirstLoadData;
@property (nonatomic,assign)BOOL _isFooterFresh;
@end

@implementation VCSearchSubmited

#pragma -mark custem

- (void)removeHUD:(id)hud

{
    //结束刷新
    
    [self.tableView.mj_header endRefreshing];
    
    [self.tableView.mj_footer endRefreshing];
    
    [hud removeFromSuperview];
    
}

-(void)setBackView
{
    UIView *viewback = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    viewback.backgroundColor = GetColor(126, 127, 128, 0.5);
    [self.view addSubview:viewback];
    self.backView = viewback;
    
    UIView *viewB = [[UIView alloc]initWithFrame:CGRectMake(0,0, 300, 262)];
    viewB.backgroundColor = GetColor(126, 127, 128, 1);
    //    viewB.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    viewB.layer.borderWidth = 1.0f;
    viewB.center = self.backView.center;
    [self.backView addSubview:viewB];
    self.viewB = viewB;
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, viewB.frame.size.width, 30)];
    labelTitle.textColor = [UIColor lightGrayColor];
    labelTitle.backgroundColor = [UIColor whiteColor];
    [viewB addSubview:labelTitle];
    self.labelTitle = labelTitle;
    
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 31, viewB.frame.size.width, 30)];
    labelTime.backgroundColor = [UIColor whiteColor];
    labelTime.textAlignment = NSTextAlignmentCenter;
    NSDate *theDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    labelTime.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:theDate]];
    [viewB addSubview:labelTime];
    self.labelTime = labelTime;
    
    UIDatePicker *datePick = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 62, viewB.frame.size.width, 158)];
    datePick.backgroundColor = [UIColor whiteColor];
    datePick.datePickerMode = UIDatePickerModeDate;
    [datePick addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    [viewB addSubview:datePick];
    self.dataPick = datePick;
    
    UIButton *buttonCancle = [[UIButton alloc]initWithFrame:CGRectMake(0, 221, viewB.frame.size.width/2, 40)];
    [buttonCancle setTitle:@"取消" forState:UIControlStateNormal];
    [buttonCancle setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonCancle setBackgroundColor:[UIColor whiteColor]];
    [buttonCancle addTarget:self action:@selector(cacleButton) forControlEvents:UIControlEventTouchUpInside];
    [viewB addSubview:buttonCancle];
    self.buttonCancle = buttonCancle;
    
    UIButton *buttonSure = [[UIButton alloc]initWithFrame:CGRectMake(viewB.frame.size.width/2+1, 221, viewB.frame.size.width/2, 40)];
    [buttonSure setTitle:@"确定" forState:UIControlStateNormal];
    [buttonSure setBackgroundColor:[UIColor whiteColor]];
    [buttonSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonSure addTarget:self action:@selector(surebutton) forControlEvents:UIControlEventTouchUpInside];
    [viewB addSubview:buttonSure];
    self.buttonSure = buttonSure;
}

- (void)dateChanged
{
    NSDate *theDate = self.dataPick.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    self.labelTime.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:theDate]];
}

-(void)surebutton
{
    NSDate *theDate = self.dataPick.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    if (self.buttonSure.tag==20) {
        [self.buttonStart setTitle:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:theDate]] forState:UIControlStateNormal];
    }else
    {
        [self.buttonEnd setTitle:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:theDate]] forState:UIControlStateNormal];
    }
    
    [self.backView removeFromSuperview];
    
}

-(void)cacleButton
{
    
    [self.backView removeFromSuperview];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.backView removeFromSuperview];
}


-(void)setUI
{
    UIView *viewTop = [[UIView alloc]init];
    viewTop.layer.borderColor = [UIColor lightGrayColor].CGColor;
    viewTop.layer.borderWidth = 1.0f;
    [self.view addSubview:viewTop];
    [viewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(-1);
        make.right.mas_equalTo(self.view.mas_right).offset(1);
        make.top.mas_equalTo(self.view.mas_top).offset(kTopHeight);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"开始日期";
    label1.font = [UIFont systemFontOfSize:12];
    [viewTop addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.backgroundColor = [UIColor lightGrayColor];
    [viewTop addSubview:label2];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewTop.mas_left).offset(10);
        make.right.mas_equalTo(label2.mas_left);
        make.centerY.mas_equalTo(viewTop.mas_centerY);
        make.height.mas_equalTo(21);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(viewTop.mas_centerX);
        make.left.mas_equalTo(60);
        make.bottom.mas_equalTo(label1.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *buttonStart = [[UIButton alloc]init];
    [buttonStart setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonStart.tag = 200;
    [buttonStart addTarget:self action:@selector(setDate1:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewTop addSubview:buttonStart];
    [buttonStart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right);
        make.right.mas_equalTo(viewTop.mas_centerX);
        make.bottom.mas_equalTo(label2.mas_top);
        make.height.mas_equalTo(21);
    }];
    self.buttonStart = buttonStart;
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"结束日期";
    label3.font = [UIFont systemFontOfSize:12];
    [viewTop addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.backgroundColor = [UIColor lightGrayColor];
    [viewTop addSubview:label4];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewTop.mas_centerX);
        make.right.mas_equalTo(label4.mas_left);
        make.centerY.mas_equalTo(viewTop.mas_centerY);
        make.height.mas_equalTo(21);
    }];
    
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(viewTop.mas_right).offset(-10);
        make.left.mas_equalTo(viewTop.mas_centerX).offset(50);
        make.bottom.mas_equalTo(label3.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *buttonEnd = [[UIButton alloc]init];
    buttonEnd.tag = 300;
    [buttonEnd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonEnd addTarget:self action:@selector(setDate1:) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:buttonEnd];
    [buttonEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label3.mas_right);
        make.right.mas_equalTo(viewTop.mas_right).offset(-10);
        make.bottom.mas_equalTo(label4.mas_top);
        make.height.mas_equalTo(21);
    }];
    self.buttonEnd = buttonEnd;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[CellSummaryList class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(viewTop.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self._page = 1;
        
        self. _isFooterFresh = NO;
        
        [self getData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //上拉加载
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self._page++;
        
        self._isFooterFresh = YES;
        
        [self getData];
    }];
    self.tableView = tableView;
    
}

-(void)setDate1:(UIButton *)button
{
    [self setBackView];
    if (button.tag==200) {
        self.labelTitle.text = @"请选择开始时间";
        self.buttonSure.tag = 20;
    }else
    {
        self.labelTitle.text = @"请选择结束时间";
        self.buttonSure.tag = 30;
    }
    
    
}

-(void)getData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/timeQuery",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSString *startDate;
    NSString *endDate;
    
    if (self.buttonStart.titleLabel.text!=nil) {
        startDate = self.buttonStart.titleLabel.text;
    }
    
    if (self.buttonEnd.titleLabel.text!=nil) {
        endDate = self.buttonEnd.titleLabel.text;
    }
    
    
    if ([[ShareModel shareModel].sort isEqualToString:@"3"]) {
        startDate = [startDate substringToIndex:8];
        startDate = [startDate stringByAppendingString:@"15"];
        endDate = [startDate substringToIndex:8];
        endDate = [endDate stringByAppendingString:@"15"];
    }
    
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"DepartmentID":[ShareModel shareModel].departmentID,
                           @"Num":[ShareModel shareModel].num,
                           @"Sort":[ShareModel shareModel].sort,
                           @"page":[NSString stringWithFormat:@"%ld",self._page],
                           @"StartTime":startDate,
                           @"EndTime":endDate,
                           @"flag":@"1"};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            
            if (self._isFooterFresh==NO) {
                [self.arrayData removeAllObjects];
            }
            
            for (NSDictionary *dict in [responseObject valueForKey:@"lists"]) {
                [self.arrayData addObject:dict];
            }
            
            [self.tableView reloadData];
            return ;
        }
        
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return ;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据为空" andInterval:1];
            return ;
        }
        
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)selectCheck
{
    if ([self.buttonSure.titleLabel.text isEqualToString:@"请选择开始时间"]) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请选择开始日期" andInterval:1];
        return;
    }
    if ([self.buttonEnd.titleLabel.text isEqualToString:@"请选择结束时间"]) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请选择结束日期" andInterval:1];
        return;
    }
    if ([self.buttonStart.titleLabel.text compare:self.buttonEnd.titleLabel.text]==NSOrderedDescending) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"开始日期不能大于结束日期" andInterval:1];
        return;
    }
    if ([self.buttonEnd.titleLabel.text compare:self.today]==NSOrderedDescending) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"结束日期不能大于今天" andInterval:1];
        return;
    }
    if ([self.buttonStart.titleLabel.text compare:self.today]==NSOrderedDescending) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"开始日期不能大于今天" andInterval:1];
        return;
    }
    [self getData];
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
    if (self.arrayData.count==0) {
        return cell;
    }
    NSDictionary *dict = self.arrayData[indexPath.row];
    [self.remark enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:[NSString stringWithFormat:@"%@",dict[@"remark"]]]) {
            NSString *string = [NSString stringWithFormat:@"%@",obj];
            cell.labelMode.text = [string substringWithRange:NSMakeRange(2, 3)];
            *stop = YES;
        }
    }];
    
    cell.labelTime.text = [dict[@"dates"]substringToIndex:16];
    NSString *state = [NSString stringWithFormat:@"%@",dict[@"state"]];
    if ([state isEqualToString:@"0"]) {
        cell.labelState.text = @"待审核";
        cell.labelState.textColor = GetColor(192, 192, 192, 1);
    }else if ([state isEqualToString:@"1"])
    {
        cell.labelState.text = [NSString stringWithFormat:@"通过:%@",dict[@"updateTime"]];
        cell.labelState.textColor = GetColor(246, 0, 49, 1);
    }else
    {
        cell.labelState.text = [NSString stringWithFormat:@"驳回:%@",dict[@"updateTime"]];
        cell.labelState.textColor = GetColor(206, 157, 86, 1);
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
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
                vc.isSelect = NO;
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

#pragma -mark

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.arrayData removeAllObjects];
    
    self._isFirstLoadData = NO;
    self._isFooterFresh = NO;
    self._page = 1;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"搜索";
    
    [self setUI];
    
    NSDate *theDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    self.today = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:theDate]];
    
    self.arrayData = [NSMutableArray array];
    
    self._isFirstLoadData = YES;
    
    //不是上拉加载数据
    
    self._isFooterFresh = NO;
    
    //页码赋初值
    
    self._page=1;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"查询" style:(UIBarButtonItemStyleDone) target:self action:@selector(selectCheck)];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    
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
