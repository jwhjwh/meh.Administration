//
//  VCInsideMonthSummary.m
//  Administration
//
//  Created by zhang on 2017/9/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCInsideMonthSummary.h"
#import "CellTabelDetail.h"
#import "CellInfo.h"
#import "ZXYAlertView.h"
#import "ViewControllerPostil.h"
@interface VCInsideMonthSummary ()<UITableViewDelegate,UITableViewDataSource,ZXYAlertViewDelegate,UIAlertViewDelegate>
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
@property (nonatomic,strong)NSArray *arrayKey;
@property (nonatomic,strong)NSArray *arraySummary;
@property (nonatomic)BOOL havePermission;
@end

@implementation VCInsideMonthSummary

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
    [self.buttonPlan setTitle:@"月计划" forState:UIControlStateNormal];
    self.buttonPlan.tag = 200;
    [self.buttonPlan addTarget:self action:@selector(buttonPlan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonPlan];
    
    self.buttonSummary = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width/2, 64, Scree_width/2, 30)];
    self.buttonSummary.tag = 300;
    [self.buttonSummary addTarget:self action:@selector(buttonPlan:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonSummary setTitle:@"月总结" forState:UIControlStateNormal];
    [self.view addSubview:self.buttonSummary];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = GetColor(186, 153, 203, 1);
    
    if (self.isSelect) {
        line.frame = CGRectMake(0, 94, Scree_width/2, 1);
        [self.buttonPlan setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本月主要工作规划",@"第一周",@"第二周",@"第三周",@"第四周",@"补充备注"];
        
    }else
    {
        line.frame = CGRectMake(Scree_width/2, 94, Scree_width/2, 1);
        [self.buttonSummary setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本月工作完成简述",@"本月工作进度及目标达成的分析与评估",@"当前阶段工作方向。整改策略及建议",@"个人心得感悟",@"下阶段个人成长目标规划及方向预设"];
        
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
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本月主要工作规划",@"第一周",@"第二周",@"第三周",@"第四周",@"补充备注"];
        self.isSelect = YES;
        self.codeS = @"1";
        self.remark = @"12";
        
    }else
    {
        self.line.frame = CGRectMake(Scree_width/2, 94, Scree_width/2, 1);
        [self.buttonSummary setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本月工作完成简述",@"本月工作进度及目标达成的分析与评估",@"当前阶段工作方向。整改策略及建议",@"个人心得感悟",@"下阶段个人成长目标规划及方向预设"];
        self.isSelect = NO;
        self.codeS = @"2";
        self.remark = @"13";
    }
    [self getData];
    [self.tableView reloadData];
}

-(void)editContent:(UIButton *)button
{
    CellTabelDetail *cell = (CellTabelDetail *)[[button superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    
    ViewControllerPostil *vc = [[ViewControllerPostil alloc]init];
    vc.stringName = cell.textView.text;
    for (NSString *key in [self.dictInfo allKeys]) {
        if ([cell.textView.text isEqualToString:self.dictInfo[key]]) {
            vc.theKey = key;
            break;
        }
    }
    vc.departmentID = self.departmentId;
    vc.remark = self.remark;
    vc.tableID = self.tableId;
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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                        cell.button.hidden = YES;
                        cell.button.userInteractionEnabled = NO;
                        for (int i=0; i<self.arrayTask.count; i++) {
                            
                            NSString *string1 = [NSString stringWithFormat:@"%@ %@ 万\n",self.arrayTask[i],self.dictInfo[self.arrayTotal[i]]];
                            NSString *string2 = [NSString stringWithFormat:@" %@ ",self.dictInfo[self.arrayTotal[i]]];
                            
                            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:string1];
                            [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange([self.arrayTask[i] length], string2.length)];
                            [self.mutAttribute appendAttributedString:string];
                            //
                        }
                    }
                        break;
                    case 4:
                        if (self.dictInfo[@"workPlan"]) {
                            cell.textView.text = self.dictInfo[@"workPlan"];
                        }else
                        {
                            cell.textView.text = @"  ";
                        }
                        if ([self.arrayKey containsObject:@"workPlan"]) {
                            [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        }
                        break;
                    case 5:
                        if (self.dictInfo[@"firstWeek"]) {
                            cell.textView.text = self.dictInfo[@"firstWeek"];
                        }else
                        {
                            cell.textView.text = @"  ";
                        }
                        if ([self.arrayKey containsObject:@"firstWeek"]) {
                            [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        }
                        break;
                    case 6:
                        if (self.dictInfo[@"SecondWeek"]) {
                            cell.textView.text = self.dictInfo[@"SecondWeek"];
                        }else
                        {
                            cell.textView.text = @"  ";
                        }
                        if ([self.arrayKey containsObject:@"SecondWeek"]) {
                            [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        }
                        break;
                    case 7:
                        if (self.dictInfo[@"FourthWeek"]) {
                            cell.textView.text = self.dictInfo[@"FourthWeek"];
                        }else
                        {
                            cell.textView.text = @"  ";
                        }
                        if ([self.arrayKey containsObject:@"FourthWeek"]) {
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
                        for (int i=0; i<self.arrayTask2.count; i++) {
                            
                            NSString *string1 = [NSString stringWithFormat:@"%@ %@ 万\n",self.arrayTask2[i],self.dictInfo[self.arrayTotal2[i]]];
                            NSString *string2 = [NSString stringWithFormat:@" %@ ",self.dictInfo[self.arrayTotal2[i]]];
                            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:string1];
                            [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange([self.arrayTask2[i] length], string2.length)];
                            [self.mutAttribute appendAttributedString:string];
                            
                        }
                        
                        cell.textView.attributedText = self.mutAttribute;
                        break;
                    case 4:
                        if (self.dictInfo[@"completeProgressBriefly"]) {
                            cell.textView.text = self.dictInfo[@"completeProgressBriefly"];
                        }else
                        {
                            cell.textView.text = @"  ";
                        }
                        if ([self.arrayKey containsObject:@"completeProgressBriefly"]) {
                            [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        }
                        break;
                    case 5:
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
                    case 6:
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
                    case 7:
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
                    case 8:
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isSelect) {
        if (self.arraySummary.count!=0) {
            //跳转页面
            NSDictionary *dict = self.arraySummary[indexPath.row];
            VCInsideMonthSummary *vc = [[VCInsideMonthSummary alloc]init];
            vc.departmentId = self.departmentId;
            vc.remark = self.remark;
            vc.summaryId = dict[@"id"];
            vc.isSelect = NO;
            vc.tableId=  self.tableId;
            vc.postionName = self.postionName;
            [self.navigationController pushViewController:vc animated:YES];
        }
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
                     @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                     @"CompanyInfoId":compid,
                     @"RoleId":[ShareModel shareModel].roleID,
                     @"DepartmentID":self.departmentId,
                     @"Num":self.num,
                     @"Sort":[ShareModel shareModel].sort,
                     @"State":@"1",
                     @"code":self.codeS,
                     @"id":self.tableId};
        }else
        {
            dict = @{@"appkey":appKeyStr,
                     @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                     @"CompanyInfoId":compid,
                     @"RoleId":[ShareModel shareModel].roleID,
                     @"DepartmentID":self.departmentId,
                     @"Num":self.num,
                     @"Sort":[ShareModel shareModel].sort,
                     @"State":@"2",
                     @"code":self.codeS,
                     @"id":self.tableId};
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
    self.arrayKey = [NSArray array];
    self.arraySummary = [NSArray array];
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
