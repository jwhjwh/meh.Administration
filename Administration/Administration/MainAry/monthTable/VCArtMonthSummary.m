//
//  VCArtMonthSummary.m
//  Administration
//
//  Created by zhang on 2017/9/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCArtMonthSummary.h"
#import "CellTabelDetail.h"
#import "CellInfo.h"
#import "ZXYAlertView.h"
#import "ViewControllerPostil.h"
@interface VCArtMonthSummary ()<UITableViewDelegate,UITableViewDataSource,ZXYAlertViewDelegate,UIAlertViewDelegate>
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
@property (nonatomic)BOOL havePermission;
@end

@implementation VCArtMonthSummary

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
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本月任务计划",@"工作主线和方向",@"本月重点服务店家和行程目标安排",@"对公司要求和建议",@"本月个人成长管理",@"其他事项"];
        self.isSelect = YES;
        self.codeS = @"1";
        self.remark = @"7";
        
        
    }else
    {
        self.line.frame = CGRectMake(Scree_width/2, 94, Scree_width/2, 1);
        [self.buttonSummary setTitleColor:GetColor(186, 153, 203, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"日期",@"职位",@"姓名",@"本月目标完成情况",@"本月出货及回款情况分析",@"工作得失及建议",@"个人问题及规划",@"其他事项"];
        self.isSelect = NO;
        self.codeS = @"2";
        self.remark = @"8";
        
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
    
    return self.arrayTitle.count;
    
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<3) {
        CellInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell==nil) {
            cell = [[CellInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        switch (indexPath.row) {
            case 0:
                cell.labelInfo.text = [self.dictInfo[@"months"]substringToIndex:7];
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
        if (self.havePermission) {
            cell.button.hidden = NO;
            cell.button.userInteractionEnabled = YES;
        }else
        {
            cell.button.hidden  = YES;
            cell.button.userInteractionEnabled = NO;
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
                    
                    if ([self.arrayKey containsObject:@"direction"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    
                    break;
                case 5:
                    if (self.dictInfo[@"shopsArrange"]) {
                        cell.textView.text = self.dictInfo[@"shopsArrange"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    
                    if ([self.arrayKey containsObject:@"shopsArrange"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    
                    
                    break;
                case 6:
                    
                    if (self.dictInfo[@"requestForProposal"]) {
                        cell.textView.text = self.dictInfo[@"requestForProposal"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"requestForProposal"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    
                    break;
                case 7:
                    
                    if (self.dictInfo[@"personalGrowth"]) {
                        cell.textView.text = self.dictInfo[@"personalGrowth"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"personalGrowth"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    
                    break;
                case 8:
                    
                    if (self.dictInfo[@"others"]) {
                        cell.textView.text = self.dictInfo[@"others"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }                    if ([self.arrayKey containsObject:@"others"]) {
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
                    
                    NSMutableAttributedString *string0 = [[NSMutableAttributedString alloc]initWithString:@"品牌任务：\n"];
                    
                    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"品牌中任务 %@ 万元,",self.dictInfo[@"managerBrandMission"]]];
                    [string1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(5,[NSString stringWithFormat:@"%@",self.dictInfo[@"managerBrandMission"]].length+2)];
                    
                    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实际出货 %@ 万\n",self.dictInfo[@"managerPracticalCargo"]]];
                    [string2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(4, [NSString stringWithFormat:@"%@",self.dictInfo[@"managerPracticalCargo"]].length+2)];
                    
                    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"完成比例 %@ %%\n",self.dictInfo[@"managerFinishRatio"]]];
                    [string3 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(4, [NSString stringWithFormat:@"%@",self.dictInfo[@"managerFinishRatio"]].length+2)];
                    
                    NSMutableAttributedString *string4 = [[NSMutableAttributedString alloc]initWithString:@"个人任务：\n"];
                    
                    NSMutableAttributedString *string5 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"个人任务 %@ 万,",self.dictInfo[@"brandMission"]]];
                    [string5 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(4, [NSString stringWithFormat:@"%@",self.dictInfo[@"brandMission"]].length)];
                    
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
                    if ([self.arrayKey containsObject:@"sca"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    
                    break;
                case 5:
                    
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
                case 6:
                    
                    if (self.dictInfo[@"problem"]) {
                        cell.textView.text = self.dictInfo[@"problem"];
                    }else
                    {
                        cell.textView.text = @"  ";
                    }
                    if ([self.arrayKey containsObject:@"problem"]) {
                        [cell.button setBackgroundImage:[UIImage imageNamed:@"tjpco02"] forState:UIControlStateNormal];
                    }
                    
                    break;
                case 7:
                    
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
    [super viewWillAppear:YES];
    
    [self getData];
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
    self.dictInfo = [NSMutableDictionary dictionary];
    
    self.mutAttribute = [[NSMutableAttributedString alloc]init];
    self.arrayKey = [NSArray array];
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
