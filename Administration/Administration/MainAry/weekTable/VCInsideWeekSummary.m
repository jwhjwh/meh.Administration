//
//  VCInsideWeekSummary.m
//  Administration
//
//  Created by zhang on 2017/9/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCInsideWeekSummary.h"
#import "CellTabelDetail.h"
#import "CellInfo.h"
#import "ZXYAlertView.h"
#import "ViewControllerPostil.h"
@interface VCInsideWeekSummary ()<UITableViewDelegate,UITableViewDataSource,ZXYAlertViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic ,strong)UIButton *buttonPlan;
@property (nonatomic ,strong)UIButton *buttonSummary;
@property (nonatomic,strong)UIAlertView *alertView;
@property (nonatomic,strong)NSMutableDictionary *dictInfo;
@property (nonatomic,weak)UILabel *line;
@property (nonatomic,strong)NSMutableAttributedString *mutAttribute;
@property (nonatomic,strong) NSArray *arrayKey;
@property (nonatomic)BOOL havePermission;
@end

@implementation VCInsideWeekSummary
-(void)getData
{
        NSString *urlStr =[NSString stringWithFormat:@"%@report/queryReportInfo",KURLHeader];
        NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
        NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
        NSDictionary *dict;
        if (self.isSelect) {
            dict = @{@"appkey":appKeyStr,
                     @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                     @"CompanyInfoId":compid,
                     @"RoleId":[ShareModel shareModel].roleID,
                     @"DepartmentID":self.departmentId,
                     @"remark":self.remark,
                     @"id":self.tableId
                     };
        }else
        {
            dict = @{@"appkey":appKeyStr,
                     @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                     @"CompanyInfoId":compid,
                     @"RoleId":[ShareModel shareModel].roleID,
                     @"DepartmentID":self.departmentId,
                     @"remark":self.remark,
                     @"id":self.summaryId
                     };
        }
        
        [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
            NSString *stringCode = [responseObject valueForKey:@"status"];
            if ([stringCode isEqualToString:@"0000"]) {
                self.dictInfo = [[responseObject valueForKey:@"tableInfo"]mutableCopy];
                
                if (self.dictInfo.count!=0) {
                    NSString *stringKey = [responseObject valueForKey:@"name"];
                    self.arrayKey = [stringKey componentsSeparatedByString:@","];
                    
                }
                if (![[responseObject valueForKey:@"power"] isEqualToString:@""]) {
                    NSArray *permission = [[responseObject valueForKey:@"power"] componentsSeparatedByString:@","];
                    for (NSString *roleid in permission) {
                        if ([roleid isEqualToString:[USER_DEFAULTS valueForKey:@"roleId"]]) {
                            self.havePermission = YES;
                            break;
                        }
                    }
                }
                
                if ([[ShareModel shareModel].roleID isEqualToString:@"1"]) {
                    self.havePermission = YES;
                }
                
                [self.tableView reloadData];
                return ;
            }
            if ([stringCode isEqualToString:@"4444"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
                return;
            }
            if ([stringCode isEqualToString:@"1001"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
                return;
            }
            if ([stringCode isEqualToString:@"5000"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据为空" andInterval:1];
                return;
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
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
    
    if (self.isSelect) {
        line.frame = CGRectMake(0, 94, Scree_width/2, 1);
        [self.buttonPlan setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日",@"重要事项及补充说明",@"本周个人成长规划及自我奖罚管理"];
        
    }else
    {
        line.frame = CGRectMake(Scree_width/2, 94, Scree_width/2, 1);
        [self.buttonSummary setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本周工作落实进展简述",@"本周工作进展及目标达成的分析与评估",@"当前阶段工作方向，整改策略及建议",@"个人心得感悟",@"个人成长目标规划及方向预设"];
        
    }
    [self.view addSubview:line];
    self.line=  line;
    
    UITableView *tabelView = [[UITableView alloc]init];
    [tabelView registerClass:[CellTabelDetail class] forCellReuseIdentifier:@"cell"];
    [tabelView registerClass:[CellInfo class] forCellReuseIdentifier:@"cell2"];
    tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabelView.delegate = self;
    tabelView.dataSource = self;
    tabelView.estimatedRowHeight = 100;
    tabelView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:tabelView];
    [tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView = tabelView;
}

-(void)buttonPlan:(UIButton *)button
{
    self.mutAttribute = [[NSMutableAttributedString alloc]init];
    if (button.tag==200) {
        self.line.frame = CGRectMake(0, 94, Scree_width/2, 1);
        [self.buttonPlan setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日",@"重要事项及补充说明",@"本周个人成长规划及自我奖罚管理"];
        self.isSelect = YES;
        self.remark = @"10";
        self.tableId = [NSString stringWithFormat:@"%@",self.dictInfo[@"planId"]];
        
    }else
    {
        self.line.frame = CGRectMake(Scree_width/2, 94, Scree_width/2, 1);
        [self.buttonSummary setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本周工作落实进展简述",@"本周工作进展及目标达成的分析与评估",@"当前阶段工作方向，整改策略及建议",@"个人心得感悟",@"个人成长目标规划及方向预设"];
        self.isSelect = NO;
        self.remark = @"11";
        
    }
    [self getData];
}

-(void)editContent:(UIButton *)button
{
    CellTabelDetail *cell = (CellTabelDetail *)[[button superview] superview];
    
    ViewControllerPostil *vc = [[ViewControllerPostil alloc]init];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (self.isSelect) {
        vc.tableID = self.tableId;
        switch (indexPath.row) {
            case 3:
            {
                vc.theKey = @"monday";
            }
                break;
            case 4:
                vc.theKey = @"tuesday";
                
                break;
            case 5:
                vc.theKey = @"wednesday";
                
                break;
            case 6:
                vc.theKey = @"thursday";
                
                
                break;
            case 7:
                vc.theKey = @"friday";
                
                break;
            case 8:
                vc.theKey = @"saturday";
                
                break;
            case 9:
                vc.theKey = @"sunday";
                
                break;
            case 10:
                vc.theKey = @"important";
                
                break;
            case 11:
                vc.theKey = @"growthPlans";
                
                break;
                
            default:
                break;
        }
    }else
    {
        vc.tableID = self.summaryId;
        switch (indexPath.row) {
            case 3:
            {
                vc.theKey = @"workProgress";
                
            }
                break;
            case 4:
                vc.theKey = @"progressEvaluation";
                
                break;
            case 5:
                vc.theKey = @"strategy";
                
                break;
            case 6:
                vc.theKey = @"experience";
                
                break;
            case 7:
                vc.theKey = @"directionPreset";
                
                break;
                
            default:
                break;
        }
    }
    vc.departmentID = self.departmentId;
    vc.remark = self.remark;
    vc.stringName = cell.textView.text;
    vc.num = self.num;
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
    if (indexPath.row<3) {
       
        CellInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell==nil) {
            cell = [[CellInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
                cell.labelInfo.text = [NSString stringWithFormat:@"%@至%@",[self.dictInfo[@"startDate"] substringToIndex:10],[self.dictInfo[@"endDate"] substringToIndex:10]];
                break;
            case 1:
                cell.labelInfo.text = self.postionName;
                break;
            case 2:
                cell.labelInfo.text = self.dictInfo[@"name"];
                break;
                
            default:
                break;
        }
        cell.labelTitle.text = self.arrayTitle[indexPath.row];
        return cell;
    }else
    {
        CellTabelDetail *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell = [[CellTabelDetail alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.attributedText = nil;
        [cell.button addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
        if (self.havePermission) {
            cell.button.hidden = NO;
            cell.button.userInteractionEnabled = YES;
        }else
        {
            cell.button.hidden = YES;
            cell.button.userInteractionEnabled = NO;
        }
        if (self.isSelect) {
            switch (indexPath.row) {
                case 3:
                {
                    
                    if (self.dictInfo[@"monday"]) {
                        cell.textView.text = self.dictInfo[@"monday"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"monday"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    
                }
                    break;
                case 4:
                    
                    if (self.dictInfo[@"tuesday"]) {
                        cell.textView.text = self.dictInfo[@"tuesday"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"tuesday"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    
                    break;
                case 5:
                    
                    if (self.dictInfo[@"wednesday"]) {
                        cell.textView.text = self.dictInfo[@"wednesday"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"wednesday"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 6:
                    
                    if (self.dictInfo[@"thursday"]) {
                        cell.textView.text = self.dictInfo[@"thursday"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"thursday"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    
                    break;
                case 7:
                    if (self.dictInfo[@"friday"]) {
                        cell.textView.text = self.dictInfo[@"friday"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"friday"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 8:
                    if (self.dictInfo[@"saturday"]) {
                        cell.textView.text = self.dictInfo[@"saturday"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"saturday"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 9:
                    if (self.dictInfo[@"sunday"]) {
                        cell.textView.text = self.dictInfo[@"sunday"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"Sunday"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 10:
                    if (self.dictInfo[@"important"]) {
                        cell.textView.text = self.dictInfo[@"important"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"important"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 11:
                    if (self.dictInfo[@"growthPlans"]) {
                        cell.textView.text = self.dictInfo[@"growthPlans"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"growthPlans"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                    
                default:
                    break;
            }
        }else
        {
            switch (indexPath.row) {
                case 3:
                {
                    
                    if (self.dictInfo[@"workProgress"]) {
                        cell.textView.text = self.dictInfo[@"workProgress"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"workProgress"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                }
                    break;
                case 4:
                    
                    if (self.dictInfo[@"progressEvaluation"]) {
                        cell.textView.text = self.dictInfo[@"progressEvaluation"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"progressEvaluation"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 5:
                    
                    if (self.dictInfo[@"strategy"]) {
                        cell.textView.text = self.dictInfo[@"strategy"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"strategy"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 6:
                    
                    if (self.dictInfo[@"experience"]) {
                        cell.textView.text = self.dictInfo[@"experience"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"experience"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 7:
                    if (self.dictInfo[@"directionPreset"]) {
                        cell.textView.text = self.dictInfo[@"directionPreset"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"directionPreset"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                    
                default:
                    break;
            }
        }
        
        cell.labelTitle.text = self.arrayTitle[indexPath.row];
        return cell;
    }
    
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
                if (self.isSelect) {
                    dict = @{@"appkey":appKeyStr,
                             @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                             @"CompanyInfoId":compid,
                             @"RoleId":[ShareModel shareModel].roleID,
                             @"DepartmentID":self.departmentId,
                             @"Num":[ShareModel shareModel].num,
                             @"Sort":[ShareModel shareModel].sort,
                             @"State":@"1",
                             @"code":@"1",
                             @"id":self.tableId};
                }else
                {
                    dict = @{@"appkey":appKeyStr,
                             @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                             @"CompanyInfoId":compid,
                             @"RoleId":[ShareModel shareModel].roleID,
                             @"DepartmentID":self.departmentId,
                             @"Num":[ShareModel shareModel].num,
                             @"Sort":[ShareModel shareModel].sort,
                             @"State":@"1",
                             @"code":@"2",
                             @"id":self.summaryId};
                }
                
            }else
            {
                if (self.isSelect) {
                    dict = @{@"appkey":appKeyStr,
                             @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                             @"CompanyInfoId":compid,
                             @"RoleId":[ShareModel shareModel].roleID,
                             @"DepartmentID":self.departmentId,
                             @"Num":[ShareModel shareModel].num,
                             @"Sort":[ShareModel shareModel].sort,
                             @"State":@"2",
                             @"code":@"1",
                             @"id":self.tableId};
                }else
                {
                    dict = @{@"appkey":appKeyStr,
                             @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                             @"CompanyInfoId":compid,
                             @"RoleId":[ShareModel shareModel].roleID,
                             @"DepartmentID":self.departmentId,
                             @"Num":[ShareModel shareModel].num,
                             @"Sort":[ShareModel shareModel].sort,
                             @"State":@"2",
                             @"code":@"2",
                             @"id":self.summaryId};
                }
            }
        
        
        
        [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
            NSString *string = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
            if ([string isEqualToString:@"0000"]) {
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }
            if ([string isEqualToString:@"4444"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
                return ;
            }
            if ([string isEqualToString:@"1001"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
                return ;
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
        
        
        
    }
}
#pragma -mark system
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
    self.dictInfo = [NSMutableDictionary dictionary];
    self.arrayKey = [NSArray array];
    self.mutAttribute = [[NSMutableAttributedString alloc]init];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"审核" style:(UIBarButtonItemStyleDone) target:self action:@selector(checkTable:)];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    if ([self.state isEqualToString:@"0"]) {
        self.navigationItem.rightBarButtonItem = rightitem;
    }
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
