//
//  VCWeekTable.m
//  Administration
//
//  Created by zhang on 2017/8/24.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCWeekTable.h"
#import "VCWeekSummaryDetail.h"
#import "CellTabelDetail.h"
#import "CellInfo.h"
#import "ZXYAlertView.h"
#import "ViewControllerPostil.h"
#import "CellSummary.h"
@interface VCWeekTable ()<UITableViewDelegate,UITableViewDataSource,ZXYAlertViewDelegate,UIAlertViewDelegate>
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

@implementation VCWeekTable
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
            self.arraySummary = [[responseObject valueForKey:@"lists"]mutableCopy];
            if (self.arraySummary.count!=0) {
                [self.tableView reloadData];
            }else
            {
//                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
                UINoResultView *resultView = [[UINoResultView alloc]initWithFrame:CGRectMake(0, 94, Scree_width, Scree_height-94) Title:@"暂无总结"];
                [self.view addSubview:resultView];
                self.navigationItem.rightBarButtonItem = nil;
                self.havePermission = NO;
                [self.tableView reloadData];
                
            }
            
        }else
        {
            UINoResultView *resultView = [[UINoResultView alloc]initWithFrame:CGRectMake(0, 94, Scree_width, Scree_height-94) Title:@"暂无总结"];
            [self.view addSubview:resultView];
          //  [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            self.navigationItem.rightBarButtonItem = nil;
            self.havePermission = NO;
            [self.tableView reloadData];
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
    
    self.mutAttribute = [[NSMutableAttributedString alloc]init];
    [self.dictInfo removeAllObjects];
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *stringCode = [responseObject valueForKey:@"status"];
        if ([stringCode isEqualToString:@"0000"]) {
            self.dictInfo = [[responseObject valueForKey:@"tableInfo"]mutableCopy];
            if (self.isSelect) {
                self.arrayTask = [NSMutableArray arrayWithObjects:@"品牌任务",@"本周任务",@"客户账面余额",@"现累计出货",@"本周预计回款",@"本周预计出货",@"\n个人任务",@"本周任务",@"客户账号余额",@"现累计出货",@"本周预计回款",@"预计出货", nil];
                self.arrayTotal = [NSMutableArray arrayWithObjects:@"",@"managerTask",@"managerBalance",@"managerAccumulateGoods",@"managerReturnedMoney",@"managerPredictGoods",@"",@"personTask",@"personBalance",@"personAccumulateGoods",@"personReturnedMoney",@"personPredictGoods", nil];
            }else
            {
                self.arrayTask2 = [NSMutableArray arrayWithObjects:@"品牌任务",@"本周任务",@"本周原预计回款",@"实际回款",@"原预计出货",@"实际出货",@"现累计出货",@"客户账面余额:",@"周初约计",@"周末",@"\n个人任务",@"本周任务",@"本周原预计回款",@"实际回款",@"原预计出货",@"实际出货",@"现累计出货",@"客户账面余额:",@"周初约计",@"周末", nil];
                self.arrayTotal2 = [NSMutableArray arrayWithObjects:@"",@"managerTask",@"managerPredictMoney",@"managerPracticalMoney",@"managerPredictCargo",@"managerPracticalCargo",@"managerAccumulateCargo",@"",@"managerWeeklyMoney",@"managerWeekendMoney",@"",@"task",@"predictMoney",@"practicalMoney",@"predictCargo",@"practicalCargo",@"accumulateCargo",@"",@"weeklyMoney",@"weekendMoney", nil];
                self.tableId = self.dictInfo[@"planId"];
            }
            NSString *stringKey = [responseObject valueForKey:@"name"];
            self.arrayKey = [stringKey componentsSeparatedByString:@","];
            
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
    [tabelView registerClass:[CellSummary class] forCellReuseIdentifier:@"cell3"];
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
    [self.dictInfo removeAllObjects];
    [self.arrayTask removeAllObjects];
    [self.arrayTask2 removeAllObjects];
    [self.arrayTotal removeAllObjects];
    [self.arrayTotal2 removeAllObjects];
    [self.arraySummary removeAllObjects];
    [self.dictInfo removeAllObjects];
    self.mutAttribute = [[NSMutableAttributedString alloc]init];
    [self.tableView reloadData];
    if (button.tag==200) {
        self.line.frame = CGRectMake(0, 94, Scree_width/2, 1);
        [self.buttonPlan setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本周任务计划",@"本周主要目标与销售分解及策略",@"本周重要事项备注",@"个人成长规划安排",@"其他事项"];
        self.isSelect = YES;
        self.remark = @"5";
        self.codeS = @"1";
        [self getData];
    }else
    {
        self.line.frame = CGRectMake(Scree_width/2, 94, Scree_width/2, 1);
        [self.buttonSummary setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本周任务总结",@"工作分析和工作整改建议",@"出现问题及解决方案和建议",@"自我心得体会及总结",@"其他事项"];
        self.isSelect = NO;
        self.remark = @"6";
        self.codeS = @"2";
        [self getSummary];
    }
    
    
}

-(void)editContent:(UIButton *)button
{
    CellTabelDetail *cell = (CellTabelDetail *)[[button superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    ViewControllerPostil *vc = [[ViewControllerPostil alloc]init];
    vc.stringName = cell.textView.text;
//    for (NSString *key in [self.dictInfo allKeys]) {
//        if (![self.dictInfo[key] isKindOfClass:[NSNull class]]) {
//            if ([cell.textView.text isEqualToString:[NSString stringWithFormat:@"%@",self.dictInfo[key]]]) {
//                vc.theKey = key;
//                break;
//            }
//        }
//    }
    
    switch (indexPath.row) {
        case 4:
            if (self.isSelect) {
                
                    vc.theKey = @"ovas";
            
            }else
            {
                vc.theKey = @"jaats";
                
            }
            break;
        case 5:
            if (self.isSelect) {
                vc.theKey = @"important";
                
            }else
            {
                vc.theKey = @"psp";
                
            }
            break;
        case 6:
            if (self.isSelect) {
                vc.theKey = @"personalProject";
                
            }else
            {
                 vc.theKey = @"comments";
                
            }
            break;
        case 7:
            if (self.isSelect) {
                vc.theKey = @"others";
                
            }else
            {
                vc.theKey = @"others";
                
            }
            break;
            
        default:
            break;
    }
    
    vc.departmentID = self.departmentId;
    vc.remark = self.remark;
    vc.tableID = self.dictInfo[@"id"];
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
    }else
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
        self.mutAttribute = [[NSMutableAttributedString alloc]init];
        [cell.button addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
        if (self.havePermission) {
            cell.button.hidden = NO;
            cell.button.userInteractionEnabled = YES;
        }else
        {
            cell.button.hidden = YES;
            cell.button.userInteractionEnabled = NO;
        }
        switch (indexPath.row) {
            case 3:
            {
                cell.button.hidden = YES;
                cell.button.userInteractionEnabled = NO;
                if (self.isSelect) {
                    for (int i=0; i<self.arrayTask.count; i++) {
                        
                        NSString *string1;
                        NSString *string2 = [NSString stringWithFormat:@" %@ ",self.dictInfo[self.arrayTotal[i]]];
                        
                        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]init];
                        
                        if (i==0||i==6) {
                            string1 = [NSString stringWithFormat:@"%@\n\n",self.arrayTask[i]];
                            string = [[NSMutableAttributedString alloc]initWithString:string1];
                            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [self.arrayTask[i] length])];
                            
                        }else
                        {
                            string1 = [NSString stringWithFormat:@"%@ %@ 万\n",self.arrayTask[i],self.dictInfo[self.arrayTotal[i]]];
                            string = [[NSMutableAttributedString alloc]initWithString:string1];
                            [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange([self.arrayTask[i] length], string2.length)];
                        }
                        
                        [self.mutAttribute appendAttributedString:string];
                        //                    
                    }
                }else
                {
                    for (int i=0; i<self.arrayTask2.count; i++) {
                        
                        NSString *string1;
                        NSString *string2 = [NSString stringWithFormat:@" %@ ",self.dictInfo[self.arrayTotal2[i]]];
                        
                        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]init];
                        if (i==0||i==7||i==10||i==17) {
                            string1 = [NSString stringWithFormat:@"%@\n\n",self.arrayTask2[i]];
                            string = [[NSMutableAttributedString alloc]initWithString:string1];
                            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [self.arrayTask2[i] length])];
                        }else
                        {
                        
                        string1 = [NSString stringWithFormat:@"%@ %@ 万\n",self.arrayTask2[i],self.dictInfo[self.arrayTotal2[i]]];
                        string2 = [NSString stringWithFormat:@" %@ ",self.dictInfo[self.arrayTotal2[i]]];
                        string = [[NSMutableAttributedString alloc]initWithString:string1];
                        [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange([self.arrayTask2[i] length], string2.length)];
                        }
                        [self.mutAttribute appendAttributedString:string];
                    }
                }
                cell.textView.attributedText = self.mutAttribute;
            }
                break;
            case 4:
                if (self.isSelect) {
                    if (self.dictInfo[@"ovas"]) {
                        cell.textView.text = self.dictInfo[@"ovas"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"ovas"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                }else
                {
                    if (self.dictInfo[@"jaats"]) {
                        cell.textView.text = self.dictInfo[@"jaats"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"jaats"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                }
                break;
            case 5:
                if (self.isSelect) {
                    if (self.dictInfo[@"important"]) {
                        cell.textView.text = self.dictInfo[@"important"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"important"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                }else
                {
                    if (self.dictInfo[@"psp"]) {
                        cell.textView.text = self.dictInfo[@"psp"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"psp"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                }
                break;
            case 6:
                if (self.isSelect) {
                    if (self.dictInfo[@"personalProject"]) {
                        cell.textView.text = self.dictInfo[@"personalProject"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"personalProject"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                }else
                {
                    if (self.dictInfo[@"comments"]) {
                        cell.textView.text = self.dictInfo[@"comments"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"comments"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                }
                break;
            case 7:
                if (self.isSelect) {
                    if (self.dictInfo[@"others"]) {
                        cell.textView.text = self.dictInfo[@"others"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"others"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                }else
                {
                    if (self.dictInfo[@"others"]) {
                        cell.textView.text = self.dictInfo[@"others"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"others"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                }
                break;
                
            default:
                break;
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
            VCWeekSummaryDetail *vc = [[VCWeekSummaryDetail alloc]init];
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
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self getData];
    self.dictInfo = [NSMutableDictionary dictionary];
    self.arraySummary = [NSMutableArray array];
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
