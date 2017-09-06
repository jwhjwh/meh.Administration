//
//  VCBusinessWeekTable.m
//  Administration
//
//  Created by zhang on 2017/8/24.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCBusinessWeekTable.h"
#import "CellTabelDetail.h"
#import "CellInfo.h"
#import "ZXYAlertView.h"
#import "ViewControllerPostil.h"
@interface VCBusinessWeekTable ()<UITableViewDelegate,UITableViewDataSource,ZXYAlertViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSMutableArray *arrayTask;
@property (nonatomic,strong)NSMutableArray *arrayTotal;
@property (nonatomic,strong)NSMutableArray *arrayTask2;
@property (nonatomic,strong)NSMutableArray *arrayTotal2;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic ,strong)UIButton *buttonPlan;
@property (nonatomic ,strong)UIButton *buttonSummary;
@property (nonatomic,strong)UIAlertView *alertView;
@property (nonatomic,strong)NSMutableDictionary *dictInfo;
@property (nonatomic,weak)UILabel *line;
@property (nonatomic,strong)NSMutableAttributedString *mutAttribute;
@end

@implementation VCBusinessWeekTable

-(void)getData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryReportInfo",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"DepartmentID":self.departmentId,
                           @"remark":self.remark,
                           @"id":self.tableId
                           };
    
    [self.arrayTotal removeAllObjects];
    [self.arrayTask removeAllObjects];
    [self.dictInfo removeAllObjects];
    [self.tableView reloadData];
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *stringCode = [responseObject valueForKey:@"status"];
        if ([stringCode isEqualToString:@"0000"]) {
            self.dictInfo = [[responseObject valueForKey:@"tableInfo"]mutableCopy];
            if (self.isSelect) {
                self.arrayTask = [NSMutableArray arrayWithObjects:@"计划陌拜",@"回访",@"预计达成合作",@"预计回款", nil];
                self.arrayTotal = [NSMutableArray arrayWithObjects:@"planStore",@"callbackStore",@"estimateStore",@"estimateMoneyStore", nil];
            }else
            {
                self.arrayTask2 = [NSMutableArray arrayWithObjects:@"原计划陌拜",@"实际陌拜",@"其中专业美容院",@"前店后院",@"确定意向",@"知己达成合作",@"实际回款", nil];
                self.arrayTotal2 = [NSMutableArray arrayWithObjects:@"planStore",@"actualStore",@"specialtyStore",@"frontBackStore",@"confirmStore",@"cooperationStore",@"realityMoney", nil];
            }
            
            [self.tableView reloadData];
            return ;
        }
        if ([stringCode isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return;
        }
        if ([stringCode isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"token请求超时" andInterval:1];
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
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本周任务计划",@"本周主要目标与销售分解及策略",@"本周重要事项备注",@"个人成长规划安排",@"其他事项"];
        
    }else
    {
        line.frame = CGRectMake(Scree_width/2, 94, Scree_width/2, 1);
        [self.buttonSummary setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本周任务总结",@"工作分析和工作整改建议",@"出现问题及解决方案和建议",@"自我心得体会及总结",@"其他事项"];
        
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
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本周任务计划",@"本周行程安排、目标与销售分解及策略",@"本周其他工作跟进目标预设以及善后工作",@"本周重要事项备注及补充说明",@"下极端工作预设及方向",@"个人成长规划安排及自我奖惩管理",@"其他事项"];
        self.isSelect = YES;
        self.remark = @"5";
        
    }else
    {
        self.line.frame = CGRectMake(Scree_width/2, 94, Scree_width/2, 1);
        [self.buttonSummary setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本周本周完成计划情况",@"工作目标达成进展简述",@"工作进度及目标达成的反洗和评估",@"出现问题及结局方案或建议",@"自我心得体会及总结",@"本周市场手机的案例、模式及市场营销策略分享",@"其他事项"];
        self.isSelect = NO;
        self.remark = @"6";
    }
    [self getData];
    [self.tableView reloadData];
}

-(void)editContent:(UIButton *)button
{
    CellTabelDetail *cell = (CellTabelDetail *)[[button superview] superview];

    ViewControllerPostil *vc = [[ViewControllerPostil alloc]init];
    
    for (NSString *key in [self.dictInfo allKeys]) {
        if ([cell.labelContent.text isEqualToString:self.dictInfo[key]]) {
            vc.theKey = key;
            break;
        }
    }
    vc.departmentID = self.departmentId;
    vc.remark = self.remark;
    vc.tableID = self.tableId;
    vc.stringName = cell.labelContent.attributedText;
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
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        CellInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell==nil) {
            cell = [[CellInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        switch (indexPath.row) {
            case 0:
                cell.labelInfo.text = [NSString stringWithFormat:@"%@至%@",[self.dictInfo[@"startDate"] substringToIndex:9],[self.dictInfo[@"endDate"] substringToIndex:9]];
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
        cell.labelContent.attributedText = nil;
        [cell.button addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
        switch (indexPath.row) {
            case 3:
            {
                if (self.isSelect) {
                    for (int i=0; i<self.arrayTask.count; i++) {
                        
                        NSString *string1 = [NSString stringWithFormat:@"%@ %@ 万\n",self.arrayTask[i],self.dictInfo[self.arrayTotal[i]]];
                        NSString *string2 = [NSString stringWithFormat:@" %@ ",self.dictInfo[self.arrayTotal[i]]];
                        
                        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:string1];
                        [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange([self.arrayTask[i] length], string2.length)];
                        [self.mutAttribute appendAttributedString:string];
                        //
                    }
                }else
                {
                    for (int i=0; i<self.arrayTask2.count; i++) {
                        
                        NSString *string1 = [NSString stringWithFormat:@"%@ %@ 万\n",self.arrayTask2[i],self.dictInfo[self.arrayTotal2[i]]];
                        NSString *string2 = [NSString stringWithFormat:@" %@ ",self.dictInfo[self.arrayTotal2[i]]];
                        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:string1];
                        [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange([self.arrayTask2[i] length], string2.length)];
                        [self.mutAttribute appendAttributedString:string];
                        
                    }
                }
                
                
                cell.labelContent.attributedText = self.mutAttribute;
                
                
            }
                break;
            case 4:
                if (self.isSelect) {
                    cell.labelContent.text = self.dictInfo[@"ovas"];
                }else
                {
                    cell.labelContent.text = self.dictInfo[@"jaats"];
                }
                break;
            case 5:
                if (self.isSelect) {
                    cell.labelContent.text = self.dictInfo[@"important"];
                    
                }else
                {
                    cell.labelContent.text = self.dictInfo[@"psp"];
                }
                break;
            case 6:
                if (self.isSelect) {
                    cell.labelContent.text = self.dictInfo[@"personalProject"];
                }else
                {
                    cell.labelContent.text = self.dictInfo[@"comments"];
                }
                break;
            case 7:
                if (self.isSelect) {
                    cell.labelContent.text = self.dictInfo[@"others"];
                }else
                {
                    cell.labelContent.text = self.dictInfo[@"others"];
                }
                break;
                
            default:
                break;
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
        
        
        [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
            NSString *string = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
            if ([string isEqualToString:@"0000"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"成功" andInterval:1];
                return ;
            }
            if ([string isEqualToString:@"4444"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
                return ;
            }
            if ([string isEqualToString:@"1001"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"token请求超时" andInterval:1];
                return ;
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
        
        
        
    }
}
#pragma -mark system
-(void)viewWillAppear:(BOOL)animated
{
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
    self.dictInfo = [NSMutableDictionary dictionary];
    
    self.mutAttribute = [[NSMutableAttributedString alloc]init];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"审核" style:(UIBarButtonItemStyleDone) target:self action:@selector(checkTable:)];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
