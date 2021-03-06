//
//  VCBuessWeekDrafts.m
//  Administration
//
//  Created by zhang on 2017/9/28.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCBuessWeekSubmited.h"
#import "ViewBuessWeekSummary.h"
#import "ViewBuessWeekTable.h"
#import "CellEditPlan.h"
#import "ViewChooseEdit.h"
#import "CellSummary.h"
#import "VCBuessWeekSummarySubmited.h"
#import "VCPositil.h"
@interface VCBuessWeekSubmited ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ViewChooseEditDelegate>

{
    BOOL isBack;
    BOOL isEditing;
    BOOL isDouble;
    BOOL canEdit;
    ViewChooseEdit *chooseEdit;
}
@property (nonatomic,weak)UIButton *buttonPlan;
@property (nonatomic,weak)UIButton *buttopSummary;
@property (nonatomic,weak)UILabel *labelLine;
@property (nonatomic,weak)ViewBuessWeekTable *buessTable;
@property (nonatomic,weak)ViewBuessWeekSummary *buessSummary;
@property (nonatomic,strong)NSString *string1;
@property (nonatomic,strong)NSString *string2;
@property (nonatomic,strong)NSString *string3;
@property (nonatomic,strong)NSString *string4;
@property (nonatomic,strong)NSString *string5;
@property (nonatomic,strong)NSString *string6;
@property (nonatomic,strong)NSArray *arryaTitle;
@property (nonatomic,strong)NSArray *arrayContent;
@property (nonatomic,weak)UIView *viewPlan;
@property (nonatomic,weak)UIView *viewSummary;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableDictionary *dict;
@property (nonatomic,strong)NSArray *arraySummary;
@property (nonatomic,strong)UIBarButtonItem *rightitem1;
@property (nonatomic,strong)UIBarButtonItem *rightitem;
@property(nonatomic,strong) NSArray *arrayPostil;

@property (nonatomic,strong)NSString *startDate;
@property (nonatomic,strong)NSString *endDate;
@end

@implementation VCBuessWeekSubmited

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
        
        if ([code isEqualToString:@"0000"]) {
            self.arraySummary = [[responseObject valueForKey:@"lists"]mutableCopy];
            if (self.arraySummary.count!=0) {
                self.navigationItem.rightBarButtonItem = nil;
                [self setSummaryList];
            }else
            {
                [self setSummaryUI];
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无内容,可以填写" andInterval:1.0];
                self.navigationItem.rightBarButtonItem = self.rightitem;
                [self.buessSummary.startDate setTitle:self.startDate forState:UIControlStateNormal];
                [self.buessSummary.endDate setTitle:self.endDate forState:UIControlStateNormal];
                return ;
            }

            [self.tableView reloadData];
        }else
        {
            [self setSummaryUI];
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无内容,可以填写" andInterval:1.0];
            self.navigationItem.rightBarButtonItem = self.rightitem;
            [self.buessSummary.startDate setTitle:self.startDate forState:UIControlStateNormal];
             [self.buessSummary.endDate setTitle:self.endDate forState:UIControlStateNormal];
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
            [self.buessTable.startDate setTitle:[self.dict[@"startDate"]substringToIndex:10] forState:UIControlStateNormal];
            [self.buessTable.endDate setTitle:[self.dict[@"endDate"]substringToIndex:10] forState:UIControlStateNormal];
            
            self.startDate = [self.dict[@"startDate"]substringToIndex:10];
            self.endDate = [self.dict[@"startDate"]substringToIndex:10];
            
            if (![self.dict[@"planStore"] isKindOfClass:[NSNull class]]) {
               self.buessTable.textFiled1.text = [NSString stringWithFormat:@"%@",self.dict[@"planStore"]];
            }else
            {
                self.buessTable.textFiled1.text = @"";
            }
            
            if (![self.dict[@"callbackStore"] isKindOfClass:[NSNull class]]) {
                self.buessTable.textFiled2.text = [NSString stringWithFormat:@"%@",self.dict[@"callbackStore"]];
            }else
            {
                self.buessTable.textFiled2.text = @"";
            }
            
            if (![self.dict[@"estimateStore"] isKindOfClass:[NSNull class]]) {
                self.buessTable.textFiled3.text = [NSString stringWithFormat:@"%@",self.dict[@"estimateStore"]];
            }else
            {
                self.buessTable.textFiled3.text = @"";
            }
            
            if (![self.dict[@"estimateMoneyStore"] isKindOfClass:[NSNull class]]) {
                self.buessTable.textFiled4.text = [NSString stringWithFormat:@"%@",self.dict[@"estimateMoneyStore"]];
            }else
            {
                self.buessTable.textFiled4.text = @"";
            }
            
            
            self.string1 = self.dict[@"strategy"];
            self.string2 = self.dict[@"preset"];
            self.string3 = self.dict[@"content"];
            self.string4 = self.dict[@"presetDirection"];
            self.string5 = self.dict[@"planningManagement"];
            self.string6 = self.dict[@"others"];
            
            
            if ([[responseObject valueForKey:@"owner"] length]!=0) {
                if (![[responseObject valueForKey:@"owner"] isEqualToString:@""]) {
                    NSString *string = [responseObject valueForKey:@"owner"];
                    self.arrayPostil = [string componentsSeparatedByString:@","];
                }
                
            }
            
            [self.tableView reloadData];
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
    
    ViewBuessWeekTable *buessTable = [[ViewBuessWeekTable alloc]initWithFrame:CGRectMake(0, 105, Scree_width,200)];
    buessTable.userInteractionEnabled = NO;
    [viewPlan addSubview:buessTable];
    self.buessTable = buessTable;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.tableHeaderView = buessTable;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    [tableView registerClass:[CellEditPlan class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[CellSummary class] forCellReuseIdentifier:@"cell1"];
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
    
    self.string1 = @"";
    self.string2 = @"";
    self.string3 = @"";
    self.string4 = @"";
    self.string5 = @"";
    self.string6 = @"";
    
    UIView *viewSummary = [[UIView alloc]init];
    [self.view addSubview:viewSummary];
    [viewSummary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.labelLine.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.bottom);
    }];
    self.viewSummary = viewSummary;
    
    ViewBuessWeekSummary *buessSummary = [[ViewBuessWeekSummary alloc]initWithFrame:CGRectMake(0, 105, Scree_width,250)];
    [viewSummary addSubview:buessSummary];
    self.buessSummary = buessSummary;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.tableHeaderView = buessSummary;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    [tableView registerClass:[CellEditPlan class] forCellReuseIdentifier:@"cell"];
    [viewSummary addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(105);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView = tableView;
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
    [buttonPlan setTitle:@"周计划" forState:UIControlStateNormal];
    [buttonPlan addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventTouchUpInside];
    buttonPlan.tag = 100;
    [self.view addSubview:buttonPlan];
    self.buttonPlan  = buttonPlan;
    
    UIButton *buttonSummary = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width/2, 64, Scree_width/2, 40)];
    [buttonSummary setTitle:@"周总结" forState:UIControlStateNormal];
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
    if (button.tag==100) {
        self.viewPlan.hidden=  NO;
        self.viewSummary.hidden = YES;
        self.labelLine.frame = CGRectMake(0, 104, Scree_width/2, 1);
        [button setTitleColor:GetColor(152, 71, 187, 1) forState:UIControlStateNormal];
        [self.buttopSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arryaTitle = @[@"本周行程安排、目标与销售分解及策略",@"本周其他工作跟进目标预设以及善后工作",@"本周重要事项备注及补充说明",@"下阶段工作预设及方向",@"个人成长规划安排及自我奖惩管理",@"其他事项"];
        self.arrayContent = @[@"填写本周行程安排、目标与销售分解及策略",@"填写本周其他工作跟进目标预设以及善后工作",@"填写本周重要事项备注及补充说明",@"填写下阶段工作预设及方向",@"填写个人成长规划安排及自我奖惩管理",@"填写其他事项"];
        self.isSelect = YES;
        self.title = @"填写周计划";
        self.navigationItem.rightBarButtonItem = self.rightitem1;
        [self getHttpData];
    }
    else
    {
        self.isSelect = NO;
        self.labelLine.frame = CGRectMake(Scree_width/2, 104, Scree_width/2, 1);
        [button setTitleColor:GetColor(152, 71, 187, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        [self.viewSummary removeFromSuperview];
        [self setSummaryUI];
        [self.buessSummary.startDate setTitle:self.startDate forState:UIControlStateNormal];
        [self.buessSummary.endDate setTitle:self.endDate forState:UIControlStateNormal];
        self.buessSummary.startDate.userInteractionEnabled = NO;
        self.buessSummary.endDate.userInteractionEnabled = NO;
        self.viewPlan.hidden = YES;
        self.arryaTitle = @[@"工作目标达成进展简述",@"工作进度及目标达成的分析和评估",@"出现的问题及解决方案或建议",@"自我心得体会及总结",@"本周市场手机的案例、模式及市场营销策略分享",@"其他事项"];
        self.arrayContent = @[@"填写工作目标达成进展简述",@"填写工作进度及目标达成的分析和评估",@"填写出现的问题及解决方案或建议",@"填写自我心得体会及总结",@"填写本周市场手机的案例、模式及市场营销策略分享",@"填写其他事项"];
        
        self.title = @"填写周总结";
        self.navigationItem.rightBarButtonItem = self.rightitem;
        [self getSummary];
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



-(void)getState
{
    NSIndexPath *indexPath = [chooseEdit.tableView indexPathForSelectedRow];
    if (indexPath.row==0) {
        
//        UIToolbar*tools=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 100, 39)];
//        //解决出现的那条线
//        tools.clipsToBounds = YES;
//        //解决tools背景颜色的问题
//        [tools setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//        [tools setShadowImage:[UIImage new]forToolbarPosition:UIToolbarPositionAny];
//        //添加两个button
//        NSMutableArray*buttons=[[NSMutableArray alloc]initWithCapacity:2];
//        
//        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
//        [button1 setImage:[UIImage imageNamed:@"bc_ico01"] forState:UIControlStateNormal];
//        [button1 addTarget:self action:@selector(showSave) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(31, 0, 25, 25)];
//        [button2 setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
//        [button2 addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:button1];
//        UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
//        
//        [buttons addObject:item1];
//        [buttons addObject:item2];
//        [tools setItems:buttons animated:NO];
//        UIBarButtonItem *btn=[[UIBarButtonItem  alloc]initWithCustomView:tools];
//        
//        self.navigationItem.rightBarButtonItem = btn;
        
       UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(31, 0, 25, 25)];
        [button2 setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button2];
        self.navigationItem.rightBarButtonItem = rightItem;
       
        self.buessTable.userInteractionEnabled = YES;
        
        isEditing = YES;
        canEdit = YES;;
        
        [self.tableView reloadData];
    }else
    {
        [chooseEdit removeFromSuperview];
    }
    
}

//删除草稿
-(void)deleteDrafts
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/delReport",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Num":[ShareModel shareModel].num,
                           @"Sort":[ShareModel shareModel].sort,
                           @"code":@"2",
                           @"id":self.tableID,
                           @"Hint":@"3"};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return ;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
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


-(void)showSave
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要保存此项内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 300;
    [alertView show];
}

-(void)showAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要提交此项内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
}

-(void)back
{
    if (isEditing==YES) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"离开后编辑的内容将要消失" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"存到草稿箱",@"确定" ,nil];
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
        if ([self.buessTable.startDate.titleLabel.text isEqualToString:@"选择日期"]||[self.buessTable.endDate.titleLabel.text isEqualToString:@"选择日期"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
            return;
        }
    }else
    {
    
    
    
    if (self.isSelect) {
        
        if (
            self.buessTable.textFiled1.text.length ==0||
            self.buessTable.textFiled2.text.length ==0||
            self.buessTable.textFiled3.text.length ==0||
            self.buessTable.textFiled4.text.length ==0||
            [self.string1 isEqualToString:@""]||
            [self.string2 isEqualToString:@""]||
            [self.string3 isEqualToString:@""]||
            [self.string4 isEqualToString:@""]||
            [self.string5 isEqualToString:@""]||
            [self.string6 isEqualToString:@""]||
            [self.buessTable.startDate.titleLabel.text isEqualToString:@"选择日期"]||
            [self.buessTable.endDate.titleLabel.text isEqualToString:@"选择日期"]
            )
        {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
            return;
        }
        
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"DepartmentID":[ShareModel shareModel].departmentID,
                           @"Num":[ShareModel shareModel].num,
                           @"Sort":[ShareModel shareModel].sort,                                          
                           @"code":@"1",
                           @"Hint":hint,
                           @"StartDate":self.buessTable.startDate.titleLabel.text,
                           @"EndDate":self.buessTable.startDate.titleLabel.text,
                           @"PlanStore":self.buessTable.textFiled1.text,
                           @"CallbackStore":self.buessTable.textFiled2.text,
                           @"EstimateStore":self.buessTable.textFiled3.text,
                           @"EstimateMoneyStore":self.buessTable.textFiled4.text,
                           @"Strategy":self.string1,
                           @"Preset":self.string2,
                           @"Content":self.string3,
                           @"PresetDirection":self.string4,
                           @"PlanningManagement":self.string5,
                           @"others":self.string6,
                           @"Name":[USER_DEFAULTS valueForKey:@"name"]
                           };
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
        
        if (
            self.buessSummary.textFiled1.text.length ==0||
            self.buessSummary.textFiled2.text.length ==0||
            self.buessSummary.textFiled3.text.length ==0||
            self.buessSummary.textFiled4.text.length ==0||
            self.buessSummary.textFiled5.text.length ==0||
            self.buessSummary.textFiled6.text.length ==0||
            self.buessSummary.textFiled7.text.length ==0||
            [self.string1 isEqualToString:@""]||
            [self.string2 isEqualToString:@""]||
            [self.string3 isEqualToString:@""]||
            [self.string4 isEqualToString:@""]||
            [self.string5 isEqualToString:@""]||
            [self.string6 isEqualToString:@""]||
            [self.buessTable.startDate.titleLabel.text isEqualToString:@"选择日期"]||
            [self.buessTable.endDate.titleLabel.text isEqualToString:@"选择日期"]
            )
        {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
            return;
        }
        
        NSDictionary *dict = @{
                               @"appkey":appKeyStr,
                               @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                               @"CompanyInfoId":compid,
                               @"RoleId":[ShareModel shareModel].roleID,
                               @"DepartmentID":[ShareModel shareModel].departmentID,
                               @"Num":[ShareModel shareModel].num,
                               @"Sort":[ShareModel shareModel].sort,
                               @"code":@"2",
                               @"Hint":hint,
                               @"PlanId":self.tableID,
                               @"StartDate":self.buessSummary.startDate.titleLabel.text,
                               @"EndDate":self.buessSummary.endDate.titleLabel.text,
                               @"PlanStore":self.buessSummary.textFiled1.text,
                               @"ActualStore":self.buessSummary.textFiled2.text,
                               @"SpecialtyStore":self.buessSummary.textFiled3.text,
                               @"FrontBackStore":self.buessSummary.textFiled4.text,
                               @"ConfirmStore":self.buessSummary.textFiled5.text,
                               @"CooperationStore":self.buessSummary.textFiled6.text,
                               @"RealityMoney":self.buessSummary.textFiled7.text,
                               @"WorkProgress":self.string1,
                               @"WorkAnalyzeAssess":self.string2,
                               @"ProblemSolution":self.string3,
                               @"SelfSummary":self.string4,
                               @"CaseStrategyShare":self.string5,
                               @"others":self.string6,
                               @"Name":[USER_DEFAULTS valueForKey:@"name"]
                               };
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
}

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
        case 5:
            self.string6 = textView.text;
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
        cell.labelPostion.text = [ShareModel shareModel].postionName;
        cell.dictInfo = dict;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [ZXDNetworking setExtraCellLineHidden:tableView];
        return cell;
    }else
    {
    
    CellEditPlan *cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
        [cell.buttonPostil addTarget:self action:@selector(gotoPositil:) forControlEvents:UIControlEventTouchUpInside];
    cell.LabelTitle.text = self.arryaTitle[indexPath.row];
    cell.textView.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textView.placeholder = self.arrayContent[indexPath.row];
    
        switch (indexPath.row) {
                
            case 0:
                if (![self.string1 isKindOfClass:[NSNull class]]) {
                    cell.textView.text = self.string1;
                }
                
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"strategy"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"strategy"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                
                break;
            case 1:
                if (![self.string2 isKindOfClass:[NSNull class]]) {
                    cell.textView.text = self.string2;
                }
                
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"preset"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"preset"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                
                break;
            case 2:
                if (![self.string3 isKindOfClass:[NSNull class]]) {
                    cell.textView.text = self.string3;
                }
                
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"content"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"content"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }

                break;
            case 3:
                if (![self.string4 isKindOfClass:[NSNull class]]) {
                    cell.textView.text = self.string4;
                }
                
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"presetDirection"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"presetDirection"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
            case 4:
                if (![self.string5 isKindOfClass:[NSNull class]]) {
                    cell.textView.text = self.string5;
                }
                
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"planningManagement"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"planningManagement"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
            case 5:
                if (![self.string6 isKindOfClass:[NSNull class]]) {
                    cell.textView.text = self.string6;
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
    return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isSelect) {
        if (self.arraySummary.count!=0) {
            //跳转页面
            NSDictionary *dict = self.arraySummary[indexPath.row];
            VCBuessWeekSummarySubmited *vc = [[VCBuessWeekSummarySubmited alloc]init];
            vc.remark = [NSString stringWithFormat:@"%@",dict[@"remark"]];;
            vc.isSelect = NO;
            vc.tableID =  dict[@"id"];
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
    
    self.arryaTitle = @[@"本周行程安排、目标与销售分解及策略",@"本周其他工作跟进目标预设以及善后工作",@"本周重要事项备注及补充说明",@"下阶段工作预设及方向",@"个人成长规划安排及自我奖惩管理",@"其他事项"];
    self.arrayContent = @[@"填写本周行程安排、目标与销售分解及策略",@"填写本周其他工作跟进目标预设以及善后工作",@"填写本周重要事项备注及补充说明",@"填写下阶段工作预设及方向",@"填写个人成长规划安排及自我奖惩管理",@"填写其他事项"];
    
    self.arraySummary = [NSArray array];
    self.dict = [NSMutableDictionary dictionary];
    canEdit = NO;
    
    self.string1 = @"";
    self.string2 = @"";
    self.string3 = @"";
    self.string4 = @"";
    self.string5 = @"";
    self.string6 = @"";
    
    self.arrayPostil = [NSArray array];
    
    self.rightitem1 = [[UIBarButtonItem alloc] initWithTitle:@"..." style:(UIBarButtonItemStyleDone) target:self action:@selector(showChooseEdit)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.rightitem1 setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = self.rightitem1;
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(31, 0, 25, 25)];
    [button2 setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    self.rightitem = [[UIBarButtonItem alloc]initWithCustomView:button2];
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
