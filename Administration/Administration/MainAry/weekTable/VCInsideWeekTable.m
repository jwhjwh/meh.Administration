//
//  VCInsideWeekTable.m
//  Administration
//
//  Created by zhang on 2017/8/24.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCInsideWeekTable.h"
#import "CellTabelDetail.h"
#import "ZXYAlertView.h"
#import "ViewControllerPostil.h"
@interface VCInsideWeekTable ()<UITableViewDelegate,UITableViewDataSource,ZXYAlertViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic)BOOL isSelect;
@property (nonatomic ,strong)UIButton *buttonPlan;
@property (nonatomic ,strong)UIButton *buttonSummary;
@property (nonatomic,weak)UILabel *line;
@property (nonatomic,weak) UIView *viewHeader;
@property (nonatomic,weak) UILabel *labelDate;
@property (nonatomic,weak) UILabel *labelName;
@property (nonatomic,weak) UILabel *labelPosition;
@property (nonatomic,strong)UIAlertView *alertView;
@property (nonatomic,strong)UILabel *label;
@end

@implementation VCInsideWeekTable

-(void)getData:(NSDictionary *)dic
{
    
}
-(void)setUI
{
    self.buttonPlan = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, Scree_width/2, 30)];
    [self.buttonPlan setTitle:@"周计划" forState:UIControlStateNormal];
    self.buttonPlan.tag = 200;
    [self.buttonPlan addTarget:self action:@selector(buttonPlan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonPlan];
    
    self.buttonSummary = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width/2, 64, Scree_width/2, 30)];
    self.buttonSummary.tag = 300;
    [self.buttonSummary addTarget:self action:@selector(buttonPlan:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonSummary setTitle:@"周总结" forState:UIControlStateNormal];
    [self.view addSubview:self.buttonSummary];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = GetColor(186, 153, 203, 1);
    
    self.label = [[UILabel alloc]init];
    self.label.backgroundColor = GetColor(192, 192, 192, 1);
    self.label.text = @"本周主要工作";
    [self.view addSubview:self.label];
    
    UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(-1, 95, Scree_width+1, 81)];
    viewHeader.backgroundColor = GetColor(200, 200, 200, 1);
    viewHeader.layer.borderColor = GetColor(192, 192, 192, 1).CGColor;
    viewHeader.layer.borderWidth = 1.0f;
    [self.view addSubview:viewHeader];
    self.viewHeader = viewHeader;
    
    NSArray *array = @[@"    日期",@"    职位",@"    姓名"];
    for(int i=0;i<3;i++)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, i*28, 120, 27)];
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = [UIColor whiteColor];
        label.text = array[i];
        [viewHeader addSubview:label];
    }
    
    UILabel *labelDate = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, Scree_width-120, 27)];
    labelDate.textColor = [UIColor lightGrayColor];
    labelDate.backgroundColor = [UIColor whiteColor];
    [viewHeader addSubview:labelDate];
    self.labelDate = labelDate;
    
    UILabel *labelPosition = [[UILabel alloc]initWithFrame:CGRectMake(120, 28, Scree_width-120, 27)];
    labelPosition.textColor = [UIColor lightGrayColor];
    labelPosition.backgroundColor = [UIColor whiteColor];
    [viewHeader addSubview:labelPosition];
    self.labelPosition = labelPosition;
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(120, 56, Scree_width-120, 27)];
    labelName.textColor = [UIColor lightGrayColor];
    labelName.backgroundColor = [UIColor whiteColor];
    [viewHeader addSubview:labelName];
    self.labelName = labelName;
    
    if (self.isSelect) {
        line.frame = CGRectMake(0, 94, Scree_width/2, 1);
        [self.buttonPlan setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
        [UIView animateWithDuration:1 animations:^{
            self.label.frame = CGRectMake(0, 176, Scree_width, 20);
        }];
    }else
    {
        line.frame = CGRectMake(Scree_width/2, 94, Scree_width/2, 1);
        [self.buttonSummary setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"本周工作落实进展简述",@"本周工作进展及目标达成的反洗与评估",@"当前阶段工作方向，整改策略及建议",@"个人心得感悟",@"个人成长目标规划及方向预设"];
        [UIView animateWithDuration:1 animations:^{
            self.label.frame = CGRectMake(0, 176, Scree_width, 0);
        }];
    }
    [self.view addSubview:line];
    self.line=  line;
    
    UITableView *tabelView = [[UITableView alloc]init];
    [tabelView registerClass:[CellTabelDetail class] forCellReuseIdentifier:@"cell2"];
    tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabelView.delegate = self;
    tabelView.dataSource = self;
    tabelView.estimatedRowHeight = 100;
    tabelView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:tabelView];
    [tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.label.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView = tabelView;
}

-(void)buttonPlan:(UIButton *)button
{
    if (button.tag==200) {
        self.line.frame = CGRectMake(0, 94, Scree_width/2, 1);
        [self.buttonPlan setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
        [UIView animateWithDuration:1 animations:^{
            self.label.frame = CGRectMake(0, 176, Scree_width, 20);
        }];
    }else
    {
        self.line.frame = CGRectMake(Scree_width/2, 94, Scree_width/2, 1);
        [self.buttonSummary setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"本周工作落实进展简述",@"本周工作进展及目标达成的反洗与评估",@"当前阶段工作方向，整改策略及建议",@"个人心得感悟",@"个人成长目标规划及方向预设"];
        [UIView animateWithDuration:1 animations:^{
            self.label.frame = CGRectMake(0, 176, Scree_width, 0);
        }];
    }
    [self.tableView reloadData];
}

-(void)editContent:(UIButton *)button
{
    CellTabelDetail *cell = (CellTabelDetail *)[[button superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ViewControllerPostil *vc = [[ViewControllerPostil alloc]init];
    vc.stringName = self.arrayTitle[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)checkTable:(UIButton *)button
{
    ZXYAlertView *alt = [ZXYAlertView alertViewDefault];
    alt.title = @"审核";
    alt.buttonArray = @[@"通过",@"不通过"];
    [alt.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    alt.delegate = self;
    [alt show];
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTitle.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellTabelDetail *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    if (cell==nil) {
        cell = [[CellTabelDetail alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
    }
    cell.labelTitle.text = self.arrayTitle[indexPath.row];
    cell.labelContent.text = @"德玛西亚德玛西亚德玛西亚德玛西亚德玛西亚德玛西亚德玛西亚德玛西亚德玛西亚德玛西亚德玛西亚";
    [cell.button addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}
#pragma -mark alertView
-(void)alertView:(ZXYAlertView *)alertView clickedCustomButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        self.alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否将次内容审核为通过？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.alertView.tag = 200;
        [self.alertView show];
        
    }else
    {
        self.alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否将次内容审核为不通过？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.alertView.tag = 300;
        [self.alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/updateReportState",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict;
    
    if (buttonIndex==1) {
        //审核接口
        if (alertView.tag == 200) {
            dict = @{@"appkey":appKeyStr,
                     @"usersid ":[USER_DEFAULTS valueForKey:@"userid"],
                     @"CompanyInfoId":compid,
                     @"RoleId":self.roleId,
                     @"DepartmentID":self.departmentId,
                     @"Num":self.remark,
                     @"Sort":[ShareModel shareModel].sort,
                     @"State":@"1",
                     @"code":@"2"};
        }else
        {
            dict = @{@"appkey":appKeyStr,
                     @"usersid ":[USER_DEFAULTS valueForKey:@"userid"],
                     @"CompanyInfoId":compid,
                     @"RoleId":self.roleId,
                     @"DepartmentID":self.departmentId,
                     @"Num":self.remark,
                     @"Sort":[ShareModel shareModel].sort,
                     @"State":@"2",
                     @"code":@"2"};
        }
        
        
        
        
    }
}
#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"审核" style:(UIBarButtonItemStyleDone) target:self action:@selector(checkTable:)];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
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
