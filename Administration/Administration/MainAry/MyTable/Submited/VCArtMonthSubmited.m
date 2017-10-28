//
//  VCArtMonthDrafts.m
//  Administration
//
//  Created by zhang on 2017/9/28.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCArtMonthSubmited.h"
#import "ViewArtMonthPlan.h"
#import "ViewArtMonthSummary.h"
#import "CellEditPlan.h"
#import "ViewChooseEdit.h"
#import "CellSummary.h"
#import "VCArtMonthSummaryUnPassed.h"
#import "VCPositil.h"
@interface VCArtMonthSubmited ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ViewChooseEditDelegate>
{
    BOOL isBack;
    ViewChooseEdit *chooseEdit;
    BOOL isEditing;
    BOOL canEdit;
}
@property (nonatomic,weak)UIButton *buttonPlan;
@property (nonatomic,weak)UIButton *buttopSummary;
@property (nonatomic,weak)UILabel *labelLine;
@property (nonatomic,weak)ViewArtMonthPlan *artMonthPlan;
@property (nonatomic,weak)ViewArtMonthSummary *artMonthSummary;
@property (nonatomic,strong)NSString *string1;
@property (nonatomic,strong)NSString *string2;
@property (nonatomic,strong)NSString *string3;
@property (nonatomic,strong)NSString *string4;
@property (nonatomic,strong)NSString *string5;
@property (nonatomic,strong)NSArray *arryaTitle;
@property (nonatomic,strong)NSArray *arrayContent;
@property (nonatomic,weak)UIView *viewPlan;
@property (nonatomic,weak)UIView *viewSummary;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)UIBarButtonItem *rightItem;
@property (nonatomic,strong)NSMutableDictionary *dict;
@property (nonatomic,strong)NSArray *arraySummary;
@property (nonatomic,strong)NSArray *arrayPostil;
@property (nonatomic,strong)UIBarButtonItem *rightitem1;
@property (nonatomic,strong)NSString *stringDate;
@end

@implementation VCArtMonthSubmited

-(void)getSummary
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryUserSumReport",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dcit = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Num":[ShareModel shareModel].num,
                           @"Sort":[ShareModel shareModel].sort,
                           @"flag":@"1",
                           @"PlanId":self.tableID};
    [ZXDNetworking GET:urlStr parameters:dcit success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if (![[responseObject valueForKey:@"power"] isEqualToString:@""]) {
            NSArray *permission = [[responseObject valueForKey:@"power"] componentsSeparatedByString:@","];
            for (NSString *roleid in permission) {
                if ([roleid isEqualToString:[USER_DEFAULTS valueForKey:@"roleId"]]) {
                    
                    break;
                }
            }
        }
        if ([code isEqualToString:@"0000"]) {
            self.arraySummary = [[responseObject valueForKey:@"lists"]mutableCopy];
            if (self.arraySummary.count!=0) {
                [self setSummaryList];
                self.navigationItem.rightBarButtonItem = nil;
            }else
            {
                [self setSummaryUI];
                [self.artMonthSummary.buttonDate setTitle:self.stringDate forState:UIControlStateNormal];
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无内容,可以填写" andInterval:1.0];
                return ;
            }

            [self.tableView reloadData];
        }else
        {
            [self setSummaryUI];
            [self.artMonthSummary.buttonDate setTitle:self.stringDate forState:UIControlStateNormal];
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无内容,可以填写" andInterval:1.0];
            return ;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryReportInfo",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"DepartmentID":[ShareModel shareModel].departmentID,
                           @"remark":self.remark,
                           @"id":self.tableID};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.dict = [[responseObject valueForKey:@"tableInfo"]mutableCopy];
            [self.artMonthPlan.buttonDate setTitle:[self.dict[@"months"]substringToIndex:7] forState:UIControlStateNormal];
            self.stringDate = [self.dict[@"dates"]substringToIndex:7];
            self.artMonthPlan.textFiled1.text = [NSString stringWithFormat:@"%@",self.dict[@"taskPlanMoney"]];
            self.artMonthPlan.textFiled2.text = [NSString stringWithFormat:@"%@",self.dict[@"taskSprintMoney"]];
            self.artMonthPlan.textFiled3.text = [NSString stringWithFormat:@"%@",self.dict[@"personPlanMoney"]];
            self.artMonthPlan.textFiled4.text = [NSString stringWithFormat:@"%@",self.dict[@"personSprintMoney"]];
            self.string1 = self.dict[@"direction"];
            self.string2 = self.dict[@"shopsArrange"];
            self.string3 = self.dict[@"requestForProposal"];
            self.string4 = self.dict[@"personalGrowth"];
            self.string5 = self.dict[@"others"];
            
            if ([[responseObject valueForKey:@"owner"] length]!=0) {
                if (![[responseObject valueForKey:@"owner"] isEqualToString:@""]) {
                    NSString *string = [responseObject valueForKey:@"owner"];
                    self.arrayPostil = [string componentsSeparatedByString:@","];
                }
                
            }
            
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
            return;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常" andInterval:1];
            return;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据空" andInterval:1];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}

-(void)setPlanUI
{
    UIView *viewPlan = [[UIView alloc]init];
    [self.view addSubview:viewPlan];
    [viewPlan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.labelLine.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.bottom);
    }];
    self.viewPlan = viewPlan;
    
    ViewArtMonthPlan *artMonthPlan = [[ViewArtMonthPlan alloc]initWithFrame:CGRectMake(0, 0, Scree_width,220)];
    [viewPlan addSubview:artMonthPlan];
    artMonthPlan.userInteractionEnabled = NO;
    self.artMonthPlan = artMonthPlan;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.tableHeaderView = artMonthPlan;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    [tableView registerClass:[CellEditPlan class] forCellReuseIdentifier:@"cell"];
    [viewPlan addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(105);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView = tableView;
    
}

-(void)setSummaryUI
{
    UIView *viewSummary = [[UIView alloc]init];
    [self.view addSubview:viewSummary];
    [viewSummary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.labelLine.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.bottom);
    }];
    self.viewSummary = viewSummary;
    
    if (self.arraySummary.count!=0) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 100;
        [ZXDNetworking setExtraCellLineHidden:tableView];
        [tableView registerClass:[CellSummary class] forCellReuseIdentifier:@"cell1"];
        [viewSummary addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.top.mas_equalTo(self.view.mas_top).offset(105);
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
        self.tableView = tableView;
    }else
    {
    ViewArtMonthSummary *artMonthSummary = [[ViewArtMonthSummary alloc]initWithFrame:CGRectMake(0, 105, Scree_width,450)];
    artMonthSummary.buttonDate.userInteractionEnabled = NO;
    [viewSummary addSubview:artMonthSummary];
    self.artMonthSummary = artMonthSummary;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.tableHeaderView = artMonthSummary;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    [tableView registerClass:[CellEditPlan class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[CellSummary class] forCellReuseIdentifier:@"cell1"];
    [viewSummary addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(105);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView = tableView;
    }
}

-(void)setSummaryList
{
    self.viewSummary.hidden = YES;
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [tableView registerClass:[CellSummary class] forCellReuseIdentifier:@"cell1"];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(kTopHeight);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView = tableView;
}


-(void)setUI
{
    UIButton *buttonPlan = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, Scree_width/2, 40)];
    [buttonPlan setTitleColor:GetColor(152, 71, 187, 1) forState:UIControlStateNormal];
    [buttonPlan setTitle:@"月计划" forState:UIControlStateNormal];
    [buttonPlan addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventTouchUpInside];
    buttonPlan.tag = 100;
    [self.view addSubview:buttonPlan];
    self.buttonPlan  = buttonPlan;
    
    UIButton *buttonSummary = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width/2, 64, Scree_width/2, 40)];
    [buttonSummary setTitle:@"月总结" forState:UIControlStateNormal];
    [buttonSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [buttonSummary addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventTouchUpInside];
    buttonSummary.tag = 200;
    [self.view addSubview:buttonSummary];
    self.buttopSummary = buttonSummary;
    
    UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(0,104, Scree_width/2, 1)];
    labelLine.backgroundColor = GetColor(152, 71, 187, 1);
    [self.view addSubview:labelLine];
    self.labelLine = labelLine;
    
    [self setPlanUI];
    
    
}
-(void)changeData:(UIButton *)button
{
    [self.dict removeAllObjects];
    if (button.tag==100) {
        self.viewPlan.hidden=  NO;
        self.viewSummary.hidden = YES;
        self.labelLine.frame = CGRectMake(0, 104, Scree_width/2, 1);
        [button setTitleColor:GetColor(152, 71, 187, 1) forState:UIControlStateNormal];
        [self.buttopSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arryaTitle = @[@"工作主线和方向",@"本月重点服务店家和行程目标安排",@"对公司要求和建议",@"本月个人成长管理",@"其他事项"];
        self.arrayContent = @[@"填写工作主线和方向",@"填写本月重点服务店家和行程目标安排",@"填写对公司要求和建议",@"填写本月个人成长管理",@"填写其他事项"];
        self.isSelect = YES;
        self.navigationItem.rightBarButtonItem = self.rightItem;
        [self getHttpData];
    }
    else
    {
        self.labelLine.frame = CGRectMake(Scree_width/2, 104, Scree_width/2, 1);
        [button setTitleColor:GetColor(152, 71, 187, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        [self.viewSummary removeFromSuperview];
        [self getSummary];
        
        self.artMonthSummary.buttonDate.userInteractionEnabled = NO;
        self.viewPlan.hidden = YES;
        self.arryaTitle = @[@"本月出货及回款情况分析",@"工作得失心得及建议",@"个人问题及规划",@"其他事项"];
        self.arrayContent = @[@"填写本月出货及回款情况分析",@"填写工作得失心得及建议",@"填写个人问题及规划",@"填写其他事项"];
        self.isSelect = NO;
        self.navigationItem.rightBarButtonItem = self.rightitem1;
        
    }
    [self.tableView reloadData];
    
}

-(void)showChooseEdit
{
    chooseEdit  = [[ViewChooseEdit alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    chooseEdit.delegate = self;
    chooseEdit.arrayButton = @[@"编辑",@"取消"];
    [self.view addSubview:chooseEdit];
}

-(void)gotoPositil:(UIButton *)button
{
    CellEditPlan *cell = (CellEditPlan *)[button superview].superview;
    
    VCPositil *vc = [[VCPositil alloc]init];
    for (NSString *key in [self.dict allKeys]) {
        if (![self.dict[key] isKindOfClass:[NSNull class]]) {
            if ([cell.textView.text isEqualToString:self.dict[key]]) {
                vc.field = key;
                break;
            }
        }
        
    }
    
    vc.remark = self.remark;
    vc.reportID = self.dict[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)getState
{
    NSIndexPath *indexPath = [chooseEdit.tableView indexPathForSelectedRow];
    if (indexPath.row==0) {
        
        
        UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(31, 0, 25, 25)];
        [button2 setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button2];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        self.artMonthPlan.userInteractionEnabled = YES;
        canEdit = YES;
        
        isEditing = YES;
        [self.tableView reloadData];
    }else
    {
        [chooseEdit removeFromSuperview];
    }
    
}

-(void)showAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要提交此项内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    isBack = NO;
    [alertView show];
}

-(void)back
{
    if (isEditing==YES) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"离开后编辑的内容将要消失" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存到草稿箱",@"确定" ,nil];
        alertView.tag = 200;
        [alertView show];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma -mark alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if (buttonIndex ==1) {
            [self submitData:@"1"];
        }
    }else if(alertView.tag==200)
    {
        if (buttonIndex==1) {
            isBack = YES;
            [self submitData:@"3"];
        }
        if (buttonIndex==2) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)submitData:(NSString *)hint
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/insert",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    if (isBack) {
        if ([self.artMonthPlan.buttonDate.titleLabel.text isEqualToString:@"选择日期"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请选择日期" andInterval:1];
            return;
        }
    }else
    {
        if (self.isSelect==NO) {

                if ([self.artMonthSummary.buttonDate.titleLabel.text isEqualToString:@"选择日期"]||
                    self.artMonthSummary.textFiled1.text.length==0||
                    self.artMonthSummary.textFiled2.text.length==0||
                    self.artMonthSummary.textFiled3.text.length==0||
                    self.artMonthSummary.textFiled4.text.length==0||
                    self.artMonthSummary.textFiled5.text.length==0||
                    self.artMonthSummary.textFiled6.text.length==0||
                    self.artMonthSummary.textFiled7.text.length==0||
                    [self.string1 isEqualToString:@""]||
                    [self.string2 isEqualToString:@""]||
                    [self.string3 isEqualToString:@""]||
                    [self.string4 isEqualToString:@""]
                    
                    )
                {
                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
                    return;
                }
            
            
            NSDictionary *dict = @{@"appkey":appKeyStr,
                                   @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                                   @"Num":[ShareModel shareModel].num,
                                   @"DepartmentID":[ShareModel shareModel].departmentID,
                                   @"code":@"2",
                                   @"planId":self.tableID,
                                   @"RoleId":[ShareModel shareModel].roleID,
                                   @"CompanyInfoId":compid,
                                   @"Sort":[ShareModel shareModel].sort,
                                   @"Months":[NSString stringWithFormat:@"%@-15",self.artMonthPlan.buttonDate.titleLabel.text],
                                   @"ManagerBrandMission":self.artMonthSummary.textFiled1.text,
                                   @"ManagerPracticalCargo":self.artMonthSummary.textFiled2.text,
                                   @"ManagerFinishRatio":self.artMonthSummary.textFiled3.text,
                                   @"BrandMission":self.artMonthSummary.textFiled4.text,
                                   @"PracticalCargo":self.artMonthSummary.textFiled5.text,
                                   @"FinishRatio":self.artMonthSummary.textFiled6.text,
                                   @"PerformRatio":self.artMonthSummary.textFiled7.text,
                                   @"SCA":self.string1,
                                   @"Experience":self.string2,
                                   @"Problem":self.string3,
                                   @"Others":self.string4,
                                   @"Hint":hint,
                                   @"Name":[USER_DEFAULTS valueForKey:@"name"]};
            [ZXDNetworking POST:urlStr parameters:dict success:^(id responseObject) {
                NSString *code = [responseObject valueForKey:@"status"];
                if ([code isEqualToString:@"0000"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }
                if ([code isEqualToString:@"1001"]) {
                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
                    return;
                }
                if ([code isEqualToString:@"4444"]) {
                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1.0];
                    return;
                }
                if ([code isEqualToString:@"0001"]) {
                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常" andInterval:1.0];
                    return;
                }
                if ([code isEqualToString:@"5000"]) {
                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据空" andInterval:1.0];
                    return;
                }
            } failure:^(NSError *error) {
                
            } view:self.view];
        }else
        {
        
    if ([self.artMonthPlan.buttonDate.titleLabel.text isEqualToString:@"选择日期"]||
        self.artMonthPlan.textFiled1.text.length==0||
        self.artMonthPlan.textFiled2.text.length==0||
        self.artMonthPlan.textFiled3.text.length==0||
        self.artMonthPlan.textFiled4.text.length==0||
        [self.string1 isEqualToString:@""]||
        [self.string2 isEqualToString:@""]||
        [self.string3 isEqualToString:@""]||
        [self.string4 isEqualToString:@""]||
        [self.string5 isEqualToString:@""]
        )
    {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
        return;
    }
    }
    
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Num":[ShareModel shareModel].num,
                           @"DepartmentID":[ShareModel shareModel].departmentID,
                           @"code":@"1",
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"CompanyInfoId":compid,
                           @"Sort":[ShareModel shareModel].sort,
                           @"Months":[NSString stringWithFormat:@"%@-15",self.artMonthPlan.buttonDate.titleLabel.text],
                           @"TaskPlanMoney":self.artMonthPlan.textFiled1.text,
                           @"TaskSprintMoney":self.artMonthPlan.textFiled2.text,
                           @"PersonPlanMoney":self.artMonthPlan.textFiled3.text,
                           @"PersonSprintMoney":self.artMonthPlan.textFiled4.text,
                           @"Direction":self.string1,
                           @"ShopsArrange":self.string2,
                           @"RequestForProposal":self.string3,
                           @"PersonalGrowth":self.string4,
                           @"Others":self.string5,
                           @"Hint":hint,
                           @"Name":[USER_DEFAULTS valueForKey:@"name"]};
    [ZXDNetworking POST:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据空" andInterval:1.0];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view];
    }
}


#pragma -mark textView

-(void)textViewDidChange:(UITextView *)textView
{
    CellEditPlan *cell = (CellEditPlan *)[textView superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 0:
            self.string1 = textView.text;
            break;
        case 1:
            self.string2 = textView.text;
            break;
        case 2:
            self.string3 = textView.text;
            break;
        case 3:
            self.string4 = textView.text;
            break;
        case 4:
            self.string5 = textView.text;
            break;
        default:
            break;
    }
    
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }
    cell.textView.frame = CGRectMake(frame.origin.x, frame.origin.y,cell.contentView.frame.size.width, size.height);
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSelect) {
        return self.arryaTitle.count;
    }else
    {
        if (self.arraySummary.count!=0) {
            return self.arraySummary.count;
        }else
        {
            return self.arryaTitle.count;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelPostion.text = [ShareModel shareModel].postionName;
        cell.labelFilledTime.text = [dict[@"months"] substringToIndex:7];
        cell.labelUpTime.text = [dict[@"dates"] substringToIndex:16];
        cell.labelState = dict[@"updateTime"];
        [ZXDNetworking setExtraCellLineHidden:tableView];
        return cell;
    }else
    {
    
    CellEditPlan *cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.LabelTitle.text = self.arryaTitle[indexPath.row];
    cell.textView.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textView.placeholder = self.arrayContent[indexPath.row];
    [cell.buttonPostil addTarget:self action:@selector(gotoPositil:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.isSelect) {
            
        switch (indexPath.row) {
            case 0:
                if (self.string1.length!=0) {
                    cell.textView.text = self.string1;
                }
                
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"direction"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"direction"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                 break;
            case 1:
                if (self.string2.length!=0) {
                    cell.textView.text = self.string2;
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"shopsArrange"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"shopsArrange"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
            case 2:
                if (self.string3.length!=0) {
                    cell.textView.text = self.string3;
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"requestForProposal"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"requestForProposal"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
            case 3:
                if (self.string4.length!=0) {
                    cell.textView.text = self.string4;
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"personalGrowth"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"personalGrowth"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
            case 4:
                if (self.string5.length!=0) {
                    cell.textView.text = self.string5;
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"others"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"others"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
                
            default:
                break;
        }
        }else
        {
            cell.textView.placeholder = self.arrayContent[indexPath.row];
        }
    
    return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isSelect) {
        if (self.arraySummary.count!=0) {
            //跳转页面
            NSDictionary *dict = self.arraySummary[indexPath.row];
            VCArtMonthSummaryUnPassed *vc = [[VCArtMonthSummaryUnPassed alloc]init];
            
            vc.remark = [NSString stringWithFormat:@"%@",dict[@"remark"]];
            vc.tableID = dict[@"id"];
            vc.isSelect = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    [self getHttpData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
    self.arryaTitle = @[@"工作主线和方向",@"本月重点服务店家和行程目标安排",@"对公司要求和建议",@"本月个人成长管理",@"其他事项"];
    self.arrayContent = @[@"填写工作主线和方向",@"填写本月重点服务店家和行程目标安排",@"填写对公司要求和建议",@"填写本月个人成长管理",@"填写其他事项"];
    self.isSelect =  YES;
    self.dict = [NSMutableDictionary dictionary];
    
    self.arrayPostil = [NSArray array];
    self.arraySummary = [NSMutableArray array];
    
    self.rightItem = [[UIBarButtonItem alloc] initWithTitle:@"..." style:(UIBarButtonItemStyleDone) target:self action:@selector(showChooseEdit)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(31, 0, 25, 25)];
    [button2 setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.rightitem1 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    
    canEdit = NO;
    
    self.string1 = @"";
    self.string2 = @"";
    self.string3 = @"";
    self.string4 = @"";
    self.string5 = @"";
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
