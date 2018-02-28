//
//  VCSearchMobai.m
//  Administration
//
//  Created by zhang on 2017/11/10.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCSearchMobai.h"
#import "CellMobai.h"
#import "VCMobaiDetail.h"
#import "VCTargetMobaiDetail.h"
@interface VCSearchMobai ()<UITableViewDelegate,UITableViewDataSource>
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

@implementation VCSearchMobai

#pragma -mark custem

-(void)getData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/selectWorshipRecords.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    if (self.buttonStart.titleLabel.text.length==0||self.buttonEnd.titleLabel.text.length==0) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请选择日期" andInterval:1.0];
        return;
    }
    
    NSDictionary *dict;
    
    if (self.isAllCheck) {
        dict = @{
                 @"appkey":appKeyStr,
                 @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                 @"CompanyInfoId":compid,
                 @"DepartmentId":[ShareModel shareModel].departmentID,
                 @"type":@"2",
                 @"RoleIds":[ShareModel shareModel].roleID,
                 @"nu":[NSString stringWithFormat:@"%ld",(long)self._page],
                 @"Start":self.buttonStart.titleLabel.text,
                 @"End":self.buttonEnd.titleLabel.text
                 };
    }else
    {
        dict = @{
                 @"appkey":appKeyStr,
                 @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                 @"userid":self.userID,
                 @"CompanyInfoId":compid,
                 @"DepartmentId":[ShareModel shareModel].departmentID,
                 @"type":@"3",
                 @"types":@"1",
                 @"RoleIds":[ShareModel shareModel].roleID,
                 @"nu":[NSString stringWithFormat:@"%ld",(long)self._page],
                 @"Start":self.buttonStart.titleLabel.text,
                 @"End":self.buttonEnd.titleLabel.text
                 };
    }
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (self._isFooterFresh==NO) {
            [self.arrayData removeAllObjects];
        }
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            for (NSDictionary *dict in [responseObject valueForKey:@"recordInfo"]) {
                [self.arrayData addObject:dict];
            }
            [self.tableView reloadData];
            return ;
        }
        
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return;
        }
        
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
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
        make.top.mas_equalTo(self.view.mas_top).offset(64);
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
        make.height.mas_equalTo(14);
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
        make.height.mas_equalTo(14);
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
   // [tableView registerClass:[CellTbale class] forCellReuseIdentifier:@"cell"];
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

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellMobai *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellMobai alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.dict = self.arrayData[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayData[indexPath.row];
    if (![[ShareModel shareModel].state isEqualToString:@"3"]) {
        VCMobaiDetail *vc = [[VCMobaiDetail alloc]init];
        vc.mobaiID = [NSString stringWithFormat:@"%@",dict[@"id"]];
        vc.stringTitle = dict[@"storeName"];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        VCTargetMobaiDetail *vc = [[VCTargetMobaiDetail alloc]init];
        vc.stringTitle = @"目标客户";
        vc.isofyou = NO;
        vc.oneStore = @"2";
        vc.cellend = NO;
        vc.OldTargetVisitId = [NSString stringWithFormat:@"%@",dict[@"id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.arrayData removeAllObjects];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    
    self.arrayData = [NSMutableArray array];
    
    NSDictionary *didct = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"查询" style:UIBarButtonItemStyleDone target:self action:@selector(getData)];
    [rightItem setTitleTextAttributes:didct forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
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
