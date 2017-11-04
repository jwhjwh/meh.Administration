//
//  VCArtMonthTable.m
//  Administration
//
//  Created by zhang on 2017/8/24.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCArtMonthTable.h"
#import "CellTabelDetail.h"
#import "ZXYAlertView.h"
#import "CellInfo.h"
#import "ViewControllerPostil.h"
#import "VCArtMonthSummary.h"
#import "CellSummary.h"
@interface VCArtMonthTable ()<UITableViewDelegate,UITableViewDataSource,ZXYAlertViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)NSArray *arrayTitle;
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

@implementation VCArtMonthTable

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
        if ([stringCode isEqualToString:@"0000"]) {
            self.dictInfo = [[responseObject valueForKey:@"tableInfo"]mutableCopy];
            if (self.dictInfo.count!=0) {
                if ([responseObject valueForKey:@"name"]!=nil) {
                    NSString *stringKey = [responseObject valueForKey:@"name"];
                    self.arrayKey = [stringKey componentsSeparatedByString:@","];
                }
                
                if (![[responseObject valueForKey:@"power"] isEqualToString:@""]) {
                    NSArray *permission = [[responseObject valueForKey:@"power"] componentsSeparatedByString:@","];
                    for (NSString *roleid in permission) {
                        if ([roleid isEqualToString:[ShareModel shareModel].roleID]) {
                            self.havePermission = YES;
                            break;
                        }
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
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本月任务计划",@"工作主线和方向",@"本月重点服务店家和行程目标安排",@"对公司要求和建议",@"本月个人成长管理",@"其他事项"];
        
    }else
    {
        line.frame = CGRectMake(Scree_width/2, 94, Scree_width/2, 1);
        [self.buttonSummary setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本月目标完成情况",@"本月出货及回款情况分析",@"工作得失及建议",@"个人问题及规划",@"其他事项"];
        
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
    [self.arraySummary removeAllObjects];
    if (button.tag==200) {
        self.line.frame = CGRectMake(0, 94, Scree_width/2, 1);
        [self.buttonPlan setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本月任务计划",@"工作主线和方向",@"本月重点服务店家和行程目标安排",@"对公司要求和建议",@"本月个人成长管理",@"其他事项"];
        self.isSelect = YES;
        self.remark = @"7";
        self.codeS = @"1";
        [self getData];
    }else
    {
        self.line.frame = CGRectMake(Scree_width/2, 94, Scree_width/2, 1);
        [self.buttonSummary setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本月目标完成情况",@"本月出货及回款情况分析",@"工作得失及建议",@"个人问题及规划",@"其他事项"];
        self.isSelect = NO;
        self.remark = @"8";
        self.codeS = @"2";
        [self getSummary];
    }
    
}

-(void)editContent:(UIButton *)button
{
    CellTabelDetail *cell = (CellTabelDetail *)[[button superview] superview];
    
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
        if (dict[@"months"]) {
            cell.labelFilledTime.text = [dict[@"months"] substringToIndex:7];
        }
        if (![dict[@"updateTime"] isKindOfClass:[NSNull class]]) {
            cell.labelState.text = dict[@"updateTime"];
        }
        if (![dict[@"dates"] isKindOfClass:[NSNull class]]) {
            cell.labelUpTime.text = [dict[@"dates"] substringToIndex:10];
        }
        [ZXDNetworking setExtraCellLineHidden:tableView];
        return cell;
    }else
    {
    if (indexPath.row<3) {
        CellInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell==nil) {
            cell = [[CellInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        switch (indexPath.row) {
            case 0:
                if (self.dictInfo[@"months"]!=NULL) {
                   cell.labelInfo.text = [self.dictInfo[@"months"]substringToIndex:7];
                }else
                {
                    cell.labelInfo.text = @"";
                }
                
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
                    
                    NSMutableAttributedString *string0 = [[NSMutableAttributedString alloc]initWithString:@"品牌任务："];
                    
                    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"计划 %@ 万,",self.dictInfo[@"taskPlanMoney"]]];
                    [string1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(2,[NSString stringWithFormat:@"%@",self.dictInfo[@"taskPlanMoney"]].length+2)];
                    
                    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"冲刺 %@ 万\n",self.dictInfo[@"taskSprintMoney"]]];
                    [string2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(2, [NSString stringWithFormat:@"%@",self.dictInfo[@"taskSprintMoney"]].length+2)];
                    
                    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc]initWithString:@"个人任务："];
                    
                    NSMutableAttributedString *string4 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"计划 %@ 万,",self.dictInfo[@"personPlanMoney"]]];
                    [string4 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(2, [NSString stringWithFormat:@"%@",self.dictInfo[@"personPlanMoney"]].length+2)];
                    
                    NSMutableAttributedString *string5 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"冲刺 %@ 万\n",self.dictInfo[@"personSprintMoney"]]];
                    [string5 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(2,[NSString stringWithFormat:@"%@",self.dictInfo[@"personSprintMoney"]].length+2)];
                    
                    [self.mutAttribute appendAttributedString:string0];
                    [self.mutAttribute appendAttributedString:string1];
                    [self.mutAttribute appendAttributedString:string2];
                    [self.mutAttribute appendAttributedString:string3];
                    [self.mutAttribute appendAttributedString:string4];
                    [self.mutAttribute appendAttributedString:string5];

                    cell.textView.attributedText = self.mutAttribute;
                }
                    break;
                case 4:
                    if (self.dictInfo[@"direction"]) {
                        cell.textView.text = self.dictInfo[@"direction"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    
                    if(self.arrayKey.count!=0){
                      if ([self.arrayKey containsObject:@"direction"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                       }
                    }
                   
                    break;
                case 5:
                    if (self.dictInfo[@"shopsArrange"]) {
                        cell.textView.text = self.dictInfo[@"shopsArrange"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    
                    if(self.arrayKey.count!=0){
                        if ([self.arrayKey containsObject:@"shopsArrange"]) {
                            [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        }
                    }
                        
                    
                    break;
                case 6:
                    
                    if (self.dictInfo[@"requestForProposal"]) {
                        cell.textView.text = self.dictInfo[@"requestForProposal"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if(self.arrayKey.count!=0){
                        if ([self.arrayKey containsObject:@"requestForProposal"]) {
                            [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        }
                    }
                    
                    break;
                case 7:
                    
                    if (self.dictInfo[@"personalGrowth"]) {
                        cell.textView.text = self.dictInfo[@"personalGrowth"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if(self.arrayKey.count!=0){
                        if ([self.arrayKey containsObject:@"personalGrowth"]) {
                            [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        }
                    }
                    
                    break;
                case 8:
                    
                    if (self.dictInfo[@"others"]) {
                        cell.textView.text = self.dictInfo[@"others"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if(self.arrayKey.count!=0){
                        if ([self.arrayKey containsObject:@"others"]) {
                            [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        }
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
                    
                    NSMutableAttributedString *string0 = [[NSMutableAttributedString alloc]initWithString:@"品牌任务：\n"];
                    
                    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"品牌中任务 %@ 万元,",self.dictInfo[@"managerBrandMission"]]];
                    [string1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(5,[NSString stringWithFormat:@"%@",self.dictInfo[@"managerBrandMission"]].length+2)];
                    
                    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实际出货 %@ 万\n",self.dictInfo[@"managerPracticalCargo"]]];
                    [string2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(4, [NSString stringWithFormat:@"%@",self.dictInfo[@"managerPracticalCargo"]].length+2)];
                    
                    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"完成比例 %@ %%\n",self.dictInfo[@"managerFinishRatio"]]];
                    [string3 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(4, [NSString stringWithFormat:@"%@",self.dictInfo[@"managerFinishRatio"]].length+2)];
                    
                    NSMutableAttributedString *string4 = [[NSMutableAttributedString alloc]initWithString:@"个人任务：\n"];
                    
                    NSMutableAttributedString *string5 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"个人任务 %@ 万,",self.dictInfo[@"brandMission"]]];
                    [string5 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(4, [NSString stringWithFormat:@"%@",self.dictInfo[@"brandMission"]].length+2)];
                    
                    NSMutableAttributedString *string6 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"个人出货 %@ 万\n",self.dictInfo[@"practicalCargo"]]];
                    [string6 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(4,[NSString stringWithFormat:@"%@",self.dictInfo[@"practicalCargo"]].length+2)];
                    
                    NSMutableAttributedString *string7 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"完成比例 %@ %%\n",self.dictInfo[@"finishRatio"]]];
                    [string7 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(4,[NSString stringWithFormat:@"%@",self.dictInfo[@"finishRatio"]].length+2)];
                    
                    NSMutableAttributedString *string8 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"占品牌完成任务 %@ %%\n",self.dictInfo[@"performRatio"]]];
                    [string8 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(7,[NSString stringWithFormat:@"%@",self.dictInfo[@"performRatio"]].length+2)];
                    
                    
                    [self.mutAttribute appendAttributedString:string0];
                    [self.mutAttribute appendAttributedString:string1];
                    [self.mutAttribute appendAttributedString:string2];
                    [self.mutAttribute appendAttributedString:string3];
                    [self.mutAttribute appendAttributedString:string4];
                    [self.mutAttribute appendAttributedString:string5];
                    [self.mutAttribute appendAttributedString:string6];
                    [self.mutAttribute appendAttributedString:string7];
                    [self.mutAttribute appendAttributedString:string8];
                    cell.textView.attributedText = self.mutAttribute;
                }
                    break;
                case 4:
                    if (self.dictInfo[@"sca"]) {
                        cell.textView.text = self.dictInfo[@"sca"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                        //cell.textView.text = self.dictInfo[@"SCA"];
                    if(self.arrayKey.count!=0){
                        if ([self.arrayKey containsObject:@"sca"]) {
                            [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        }
                    }
                    
                    break;
                case 5:
                    
                    if (self.dictInfo[@"experience"]) {
                        cell.textView.text = self.dictInfo[@"experience"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if(self.arrayKey.count!=0){
                        if ([self.arrayKey containsObject:@"experience"]) {
                            [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        }
                    }
                    
                    break;
                case 6:
                    
                    if (self.dictInfo[@"problem"]) {
                        cell.textView.text = self.dictInfo[@"problem"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if(self.arrayKey.count!=0){
                        if ([self.arrayKey containsObject:@"problem"]) {
                            [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        }
                    }
                    
                    break;
                case 7:
                    
                    if (self.dictInfo[@"others"]) {
                        cell.textView.text = self.dictInfo[@"others"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if(self.arrayKey.count!=0){
                        if ([self.arrayKey containsObject:@"others"]) {
                            [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                        }
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
            VCArtMonthSummary *vc = [[VCArtMonthSummary alloc]init];
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
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    self.dictInfo = [NSMutableDictionary dictionary];
    self.arrayKey = [NSArray array];
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


@end
