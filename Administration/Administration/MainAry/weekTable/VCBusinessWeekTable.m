//
//  VCBusinessWeekTable.m
//  Administration
//
//  Created by zhang on 2017/9/2.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCBusinessWeekTable.h"
#import "CellTabelDetail.h"
#import "CellInfo.h"
#import "ZXYAlertView.h"
#import "ViewControllerPostil.h"
#import "CellSummary.h"
#import "VCBusinessWeekSummary.h"
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
@property (nonatomic,strong)NSArray *arrayKey;
@property (nonatomic,strong)NSMutableArray *arraySummary;
@property (nonatomic)BOOL havePermission;
@end

@implementation VCBusinessWeekTable
-(void)getSummary
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryUserSumReport",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dcit = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Num":self.num,
                           @"Sort":[ShareModel shareModel].sort,
                           @"flag":@"1",
                           @"PlanId":self.tableId};
    [ZXDNetworking GET:urlStr parameters:dcit success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        
        if ([code isEqualToString:@"0000"]) {
            self.arraySummary = [responseObject valueForKey:@"lists"];
            [self.tableView reloadData];
        }else
        {
            
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

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
        if (![[responseObject valueForKey:@"power"] isEqualToString:@""]) {
            NSArray *permission = [[responseObject valueForKey:@"power"] componentsSeparatedByString:@","];
            for (NSString *roleid in permission) {
                if ([roleid isEqualToString:[USER_DEFAULTS valueForKey:@"roleId"]]) {
                    self.havePermission = YES;
                    break;
                }
            }
        }
        if (self.dictInfo.count!=0) {
            NSString *stringKey = [responseObject valueForKey:@"name"];
            self.arrayKey = [stringKey componentsSeparatedByString:@","];
            
        }
        if ([stringCode isEqualToString:@"0000"]) {
            self.tableId = self.dictInfo[@"planId"];
            self.dictInfo = [[responseObject valueForKey:@"tableInfo"]mutableCopy];
            self.arrayTask2 = [NSMutableArray arrayWithObjects:@"原计划陌拜",@"实际陌拜",@"其中专业美容院",@"前店后院",@"确定意向",@"实际达成合作",@"实际回款", nil];
            self.arrayTotal2 = [NSMutableArray arrayWithObjects:@"planStore",@"actualStore",@"specialtyStore",@"frontBackStore",@"confirmStore",@"CooperationStore",@"RealityMoney", nil];
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
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本周任务计划",@"本周行程安排、目标与销售分级以及策略",@"本周其他工作跟进目标预设以及善后工作",@"本周重要事项备注及补充说明",@"下阶段工作预设及方向",@"个人成长会话安排及自我奖惩管理",@"其他事项"];
        
    }else
    {
        line.frame = CGRectMake(Scree_width/2, 94, Scree_width/2, 1);
        [self.buttonSummary setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本周完成计划情况",@"工作目标达成进展简述",@"工作进度及目标达成的分析和评估",@"出现问题及解决方案或建议",@"自我心得体会及总结",@"本周市场手机的案例、模式及市场营销策略分享",@"其他事项"];
        
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
    [self.arraySummary removeAllObjects];
    if (button.tag==200) {
        self.line.frame = CGRectMake(0, 94, Scree_width/2, 1);
        [self.buttonPlan setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle =  @[@"日期",@"职位",@"姓名",@"本周任务计划",@"本周行程安排、目标与销售分级以及策略",@"本周其他工作跟进目标预设以及善后工作",@"本周重要事项备注及补充说明",@"下阶段工作预设及方向",@"个人成长会话安排及自我奖惩管理",@"其他事项"];
        self.isSelect = YES;
        self.remark = @"2";
         [self getData];
    }else
    {
        self.line.frame = CGRectMake(Scree_width/2, 94, Scree_width/2, 1);
        [self.buttonSummary setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本周完成计划情况",@"工作目标达成进展简述",@"工作进度及目标达成的分析和评估",@"出现问题及解决方案或建议",@"自我心得体会及总结",@"本周市场手机的案例、模式及市场营销策略分享",@"其他事项"];
        self.isSelect = NO;
        self.remark = @"3";
        [self getSummary];
    }
    
}

-(void)editContent:(UIButton *)button
{
    CellTabelDetail *cell = (CellTabelDetail *)[[button superview] superview];
    
    ViewControllerPostil *vc = [[ViewControllerPostil alloc]init];
    for (NSString *key in [self.dictInfo allKeys]) {
        if ([cell.textView.text isEqualToString:self.dictInfo[key]]) {
            vc.theKey = key;
            break;
        }
    }
    vc.departmentID = self.departmentId;
    vc.remark = self.remark;
    vc.tableID = self.tableId;
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
        if (self.isSelect) {
            return self.arrayTitle.count;
        }else
        {
            if (self.arraySummary.count!=0) {
                return self.arraySummary.count;
            }else
            {
                return self.arrayTitle.count;
            }
        }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arraySummary.count!=0&&!self.isSelect) {
        CellSummary *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (cell==nil) {
            cell = [[CellSummary alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        }
        NSDictionary *dict = self.arraySummary[indexPath.row];
        cell.labelPostion.text = self.postionName;
        cell.dictInfo = dict;
        [ZXDNetworking setExtraCellLineHidden:tableView];
        return cell;
    }else{
    if (indexPath.row<3) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        CellInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell==nil) {
            cell = [[CellInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.button addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
        cell.textView.attributedText = nil;
        self.mutAttribute = [[NSMutableAttributedString alloc]init];
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
                    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"计划陌拜 %@ 家店,",self.dictInfo[@"planStore"]]];
                    [string1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(3,[NSString stringWithFormat:@"%@",self.dictInfo[@"planStore"]].length+2)];
                    
                    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"回访 %@ 家意向店\n",self.dictInfo[@"callbackStore"]]];
                    [string2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(2, [NSString stringWithFormat:@"%@",self.dictInfo[@"callbackStore"]].length+2)];
                    
                    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"预计达成合作 %@ 家,",self.dictInfo[@"estimateStore"]]];
                    [string3 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(6, [NSString stringWithFormat:@"%@",self.dictInfo[@"estimateStore"]].length+2)];
                    
                    NSMutableAttributedString *string5 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"预计回款 %@ 万元,",self.dictInfo[@"EstimateMoneyStore"]]];
                    [string5 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(3, [NSString stringWithFormat:@"%@",self.dictInfo[@"EstimateMoneyStore"]].length+2)];
                    
                    [self.mutAttribute appendAttributedString:string1];
                    [self.mutAttribute appendAttributedString:string2];
                    [self.mutAttribute appendAttributedString:string3];
                    [self.mutAttribute appendAttributedString:string5];
                   
                }
                    break;
                case 4:
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
                case 5:
                    if (self.dictInfo[@"preset"]) {
                        cell.textView.text = self.dictInfo[@"preset"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"preset"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 6:
                    if (self.dictInfo[@"content"]) {
                        cell.textView.text = self.dictInfo[@"content"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"content"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 7:
                    if (self.dictInfo[@"presetDirection"]) {
                        cell.textView.text = self.dictInfo[@"presetDirection"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"presetDirection"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 8:
                    if (self.dictInfo[@"planningManagement"]) {
                        cell.textView.text = self.dictInfo[@"planningManagement"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"planningManagement"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 9:
                    if (self.dictInfo[@"others"]) {
                        cell.textView.text = self.dictInfo[@"others"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"others"]) {
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
                    cell.button.hidden = YES;
                    cell.button.userInteractionEnabled = NO;
                    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"原计划陌拜 %@ 家店,",self.dictInfo[@"planStore"]]];
                    [string1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(5,[NSString stringWithFormat:@"%@",self.dictInfo[@"planStore"]].length+2)];
                    
                    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实际陌拜 %@ 家\n",self.dictInfo[@"actualStore"]]];
                    [string2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(4, [NSString stringWithFormat:@"%@",self.dictInfo[@"actualStore"]].length+2)];
                    
                    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"其中专业美容院 %@ 家，",self.dictInfo[@"specialtyStore"]]];
                    [string3 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(7, [NSString stringWithFormat:@"%@",self.dictInfo[@"specialtyStore"]].length+2)];
                    
                    
                    NSMutableAttributedString *string5 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"前店后院 %@ 家\n",self.dictInfo[@"frontBackStore"]]];
                    [string5 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(4, [NSString stringWithFormat:@"%@",self.dictInfo[@"frontBackStore"]].length+2)];
                    
                    NSMutableAttributedString *string6 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"确定意向 %@ 家，",self.dictInfo[@"confirmStore"]]];
                    [string6 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(4,[NSString stringWithFormat:@"%@",self.dictInfo[@"confirmStore"]].length+2)];
                    
                    NSMutableAttributedString *string7 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实际达成合作 %@ 家\n",self.dictInfo[@"cooperationStore"]]];
                    [string7 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(5,[NSString stringWithFormat:@"%@",self.dictInfo[@"cooperationStore"]].length+2)];
                    
                    NSMutableAttributedString *string8 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实际回款 %@ 万\n",self.dictInfo[@"realityMoney"]]];
                    [string8 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(4,[NSString stringWithFormat:@"%@",self.dictInfo[@"realityMoney"]].length+2)];
                    
                    [self.mutAttribute appendAttributedString:string1];
                    [self.mutAttribute appendAttributedString:string2];
                    [self.mutAttribute appendAttributedString:string3];
                    [self.mutAttribute appendAttributedString:string5];
                    [self.mutAttribute appendAttributedString:string6];
                    [self.mutAttribute appendAttributedString:string7];
                    [self.mutAttribute appendAttributedString:string8];
                    
                    cell.textView.attributedText = self.mutAttribute;
                }
                    break;
                case 4:
                    if (self.dictInfo[@"workProgress"]) {
                        cell.textView.text = self.dictInfo[@"workProgress"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"workProgress"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 5:
                    if (self.dictInfo[@"workAnalyzeAssess"]) {
                        cell.textView.text = self.dictInfo[@"workAnalyzeAssess"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"workAnalyzeAssess"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 6:
                    if (self.dictInfo[@"problemSolution"]) {
                        cell.textView.text = self.dictInfo[@"problemSolution"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"problemSolution"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 7:
                    if (self.dictInfo[@"selfSummary"]) {
                        cell.textView.text = self.dictInfo[@"selfSummary"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"selfSummary"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 8:
                    if (self.dictInfo[@"caseStrategyShare"]) {
                        cell.textView.text = self.dictInfo[@"caseStrategyShare"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"caseStrategyShare"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    break;
                case 9:
                    if (self.dictInfo[@"others"]) {
                        cell.textView.text = self.dictInfo[@"others"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"others"]) {
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
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isSelect) {
        if (self.arraySummary.count!=0) {
            //跳转页面
            NSDictionary *dict = self.arraySummary[indexPath.row];
            VCBusinessWeekSummary *vc = [[VCBusinessWeekSummary alloc]init];
            vc.departmentId = self.departmentId;
            vc.remark = self.remark;
            vc.summaryId = dict[@"id"];
            vc.isSelect = NO;
            vc.tableId=  self.tableId;
            vc.postionName = self.postionName;
            vc.state = self.state;
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
                     @"code":@"1",
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
                     @"code":@"2",
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
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
                return ;
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
        
        
        
    }
}
#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self getData];
    self.dictInfo = [NSMutableDictionary dictionary];
    self.arraySummary = [NSMutableArray array];
    self.arrayKey  = [NSArray array];
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
