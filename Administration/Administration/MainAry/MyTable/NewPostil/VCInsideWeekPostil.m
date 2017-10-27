//
//  VCInsideWeekDrafts.m
//  Administration
//
//  Created by zhang on 2017/9/28.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCInsideWeekPostil.h"
#import "CellEditPlan.h"
#import "ViewDatePick.h"
#import "ViewChooseEdit.h"
#import "VCInsideWeekSummaryUnPassed.h"
#import "CellSummary.h"
#import "VCPositil.h"
@interface VCInsideWeekPostil ()<UITableViewDelegate,UITableViewDataSource,ViewDatePickerDelegate,UITextViewDelegate,UIAlertViewDelegate,ViewChooseEditDelegate>
{
    BOOL isBack;
    ViewChooseEdit *chooseEdit;
    BOOL isEditing;
    BOOL canEdit;
}
@property (nonatomic,weak)UIButton *buttonPlan;
@property (nonatomic,weak)UIButton *buttopSummary;
@property (nonatomic,weak)UILabel *labelLine;
@property (nonatomic,strong)NSString *string1;
@property (nonatomic,strong)NSString *string2;
@property (nonatomic,strong)NSString *string3;
@property (nonatomic,strong)NSString *string4;
@property (nonatomic,strong)NSString *string5;
@property (nonatomic,strong)NSString *string6;
@property (nonatomic,strong)NSString *string7;
@property (nonatomic,strong)NSString *string8;
@property (nonatomic,strong)NSString *string9;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSArray *arrayContent;
@property (nonatomic,weak)UIView *viewPlan;
@property (nonatomic,weak)UIView *viewSummary;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)ViewDatePick *myDatePick;
@property (nonatomic,assign)NSUInteger buttonTAag;
@property (nonatomic,weak)UIButton *endDate;
@property (nonatomic,weak)UIButton *startDate;
@property (nonatomic,strong)NSArray *arraySummary;
@property (nonatomic,strong)NSMutableDictionary *dict;
@property (nonatomic,strong)UIBarButtonItem *rightItem;
@property(nonatomic,strong) NSArray *arrayPostil;
@end

@implementation VCInsideWeekPostil

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
            }else
            {
                [self setSummaryUI];
            }

            [self.tableView reloadData];
        }else
        {
            [self setSummaryUI];
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
            self.dict = [responseObject valueForKey:@"tableInfo"];
            
            self.startDate.titleLabel.text = [self.dict[@"startDate"] substringToIndex:10];
            self.endDate.titleLabel.text = [self.dict[@"endDate"] substringToIndex:10];
            self.string1 = self.dict[@"monday"];
            self.string2 = self.dict[@"tuesday"];
            self.string3 = self.dict[@"wednesday"];
            self.string4 = self.dict[@"thursday"];
            self.string5 = self.dict[@"friday"];
            self.string6 = self.dict[@"saturday"];
            self.string7 = self.dict[@"sunday"];
            self.string8 = self.dict[@"important"];
            self.string9 = self.dict[@"growthPlans"];
            
            if ([[responseObject valueForKey:@"owner"] length]!=0) {
                if (![[responseObject valueForKey:@"owner"] isEqualToString:@""]) {
                    NSString *string = [responseObject valueForKey:@"owner"];
                    self.arrayPostil = [string componentsSeparatedByString:@","];
                }
                
            }
            
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1];
            return;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1];
            return;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据为空" andInterval:1];
            return;
        }

        
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}

-(UIView *)chooseDate
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight, Scree_width, 108)];
    view.backgroundColor = GetColor(192, 192, 192, 1);
    //    [self.view addSubview:view];
    
    
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor whiteColor];
    [view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left);
        make.right.mas_equalTo(view.mas_right);
        make.top.mas_equalTo(view.mas_top);
        make.height.mas_equalTo(35);
    }];
    
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor whiteColor];
    [view addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left);
        make.top.mas_equalTo(view1.mas_bottom).offset(1);
        make.right.mas_equalTo(view.mas_right);
        make.height.mas_equalTo(35);
    }];
    
    UIView *view3 = [[UIView alloc]init];
    view3.backgroundColor = [UIColor whiteColor];
    [view addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left);
        make.top.mas_equalTo(view2.mas_bottom).offset(1);
        make.right.mas_equalTo(view.mas_right);
        make.height.mas_equalTo(35);
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"  日期";
    label1.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view1.mas_left);
        make.top.mas_equalTo(view1.mas_top);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(70);
    }];
    
    UIButton *startDate = [[UIButton alloc]init];
    startDate.userInteractionEnabled = NO;
    [startDate setTitle:@"选择日期" forState:UIControlStateNormal];
    startDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    startDate.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    startDate.tag = 400;
    [startDate addTarget:self action:@selector(showMydatePick:) forControlEvents:UIControlEventTouchUpInside];
    [startDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [startDate setBackgroundColor:[UIColor whiteColor]];
    [view1 addSubview:startDate];
    [startDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right);
        make.top.mas_equalTo(view1.mas_top);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(130);
    }];
    self.startDate = startDate;
    //
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"至";
    label2.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(startDate.mas_right);
        make.top.mas_equalTo(view1.mas_top);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(30);
    }];
    //
    UIButton *endDate = [[UIButton alloc]init];
    endDate.userInteractionEnabled = NO;
    endDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    endDate.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [endDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [endDate setTitle:@"选择日期" forState:UIControlStateNormal];
    [endDate setBackgroundColor:[UIColor whiteColor]];
    [endDate addTarget:self action:@selector(showMydatePick:) forControlEvents:UIControlEventTouchUpInside];
    endDate.tag = 500;
    [view1 addSubview:endDate];
    [endDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view1.mas_top);
        make.height.mas_equalTo(35);
        make.left.mas_equalTo(label2.mas_right);
        make.width.mas_equalTo(130);
    }];
    self.endDate = endDate;
    //
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"  职位";
    label3.backgroundColor = [UIColor whiteColor];
    [view2 addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view2.mas_left);
        make.top.mas_equalTo(label1.mas_bottom).offset(1);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(70);
    }];
    
    UILabel *labelPostion = [[UILabel alloc]init];
    labelPostion.text = [ShareModel shareModel].postionName;
    labelPostion.backgroundColor = [UIColor whiteColor];
    [view2 addSubview:labelPostion];
    [labelPostion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label3.mas_right);
        make.top.mas_equalTo(view2.mas_top);
        make.height.mas_equalTo(35);
    }];
    //
    UILabel *label4 = [[UILabel alloc]init];
    label4.backgroundColor = [UIColor whiteColor];
    label4.text = @"  姓名";
    [view3 addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view3.mas_left);
        make.top.mas_equalTo(view3.mas_top);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(70);
    }];
    
    UILabel *labelName = [[UILabel alloc]init];
    labelName.text = [USER_DEFAULTS valueForKey:@"name"];
    labelName.backgroundColor = [UIColor whiteColor];
    [view3 addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label4.mas_right);
        make.top.mas_equalTo(view3.mas_top);
        make.height.mas_equalTo(35);
    }];
    return view;
}

-(void)showMydatePick:(UIButton *)button
{
    self.buttonTAag = button.tag;
    ViewDatePick *myDatePick = [[ViewDatePick alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    myDatePick.delegate = self;
    [self.view addSubview:myDatePick];
    self.myDatePick = myDatePick;
}

-(void)getDate
{
    NSDate *date = self.myDatePick.datePick.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringDate = [formatter stringFromDate:date];
    
    if (self.buttonTAag==400) {
        [self.startDate setTitle:stringDate forState:UIControlStateNormal];
        [self.startDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    }else if(self.buttonTAag==500)
    {
        [self.endDate setTitle:stringDate forState:UIControlStateNormal];
        [self.endDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    }
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
    
    UIView *viewChooseDate = [self chooseDate];
    [viewPlan addSubview:viewChooseDate];
    
    self.isSelect = YES;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.tableHeaderView = viewChooseDate;
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
    
    UIView *viewChoose = [self chooseDate];
    [viewSummary addSubview:viewChoose];
    self.startDate.userInteractionEnabled= NO;
    self.endDate.userInteractionEnabled = NO;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.tableHeaderView = viewChoose;
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
    buttonPlan.tag = 1000;
    [self.view addSubview:buttonPlan];
    self.buttonPlan  = buttonPlan;
    
    UIButton *buttonSummary = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width/2, 64, Scree_width/2, 40)];
    [buttonSummary setTitle:@"周总结" forState:UIControlStateNormal];
    [buttonSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [buttonSummary addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventTouchUpInside];
    buttonSummary.tag = 2000;
    [self.view addSubview:buttonSummary];
    self.buttopSummary = buttonSummary;
    
    UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(0,104, Scree_width/2, 1)];
    labelLine.backgroundColor = GetColor(152, 71, 187, 1);
    [self.view addSubview:labelLine];
    self.labelLine = labelLine;
    
    self.startDate.userInteractionEnabled = NO;
    self.endDate.userInteractionEnabled = NO;
    [self setPlanUI];
}


-(void)changeData:(UIButton *)button
{
    
    if (button.tag==1000) {
        self.viewPlan.hidden=  NO;
        self.viewSummary.hidden = YES;
        self.labelLine.frame = CGRectMake(0, 104, Scree_width/2, 1);
        [button setTitleColor:GetColor(152, 71, 187, 1) forState:UIControlStateNormal];
        [self.buttopSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arrayTitle = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日",@"重要事项及补充说明",@"本周个人成长规划及自我奖罚管理"];
        self.arrayContent = @[@"填写周一的主要工作",@"填写周二的主要工作",@"填写周三的主要工作",@"填写周四的主要工作",@"填写周五的主要工作",@"填写周六的主要工作",@"填写周日的主要工作",@"填写重要事项补充说明",@"填写本周个人成长规划及自我奖罚管理"];
        self.isSelect = YES;
        self.title = @"填写周计划";
        self.navigationItem.rightBarButtonItem = self.rightItem;
        [self getHttpData];
    }
    else
    {
        self.labelLine.frame = CGRectMake(Scree_width/2, 104, Scree_width/2, 1);
        [button setTitleColor:GetColor(152, 71, 187, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        [self.viewSummary removeFromSuperview];
        [self setSummaryUI];
        self.viewPlan.hidden = YES;
        self.arrayTitle = @[@"本周工作落实进展简述",@"本周工作进展及目标达成的分析与评估",@"当前阶段工作方向，整改策略及建议",@"个人心得感悟",@"个人成长目标及方向预设"];
        self.arrayContent = @[@"填写本周工作落实进展简述",@"填写本周工作进展及目标达成的分析与评估",@"填写当前阶段工作方向，整改策略及建议",@"填写个人心得感悟",@"填写个人成长目标及方向预设"];
        self.isSelect = NO;
        self.title = @"填写周总结";
        self.navigationItem.rightBarButtonItem = nil;
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
       
        self.startDate.userInteractionEnabled = YES;
        self.endDate.userInteractionEnabled = YES;
        canEdit = YES;
        isEditing = YES;
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
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"离开后编辑的内容将要消失" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" ,nil];
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
        if ([self.startDate.titleLabel.text isEqualToString:@"选择日期"]||
            [self.endDate.titleLabel.text isEqualToString:@"选择日期"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请选择日期" andInterval:1];
            return;
        }
    }
    else
    {
    if ([self.string1 isEqualToString:@""]||
        [self.string1 isEqualToString:@""]||
        [self.string1 isEqualToString:@""]||
        [self.string1 isEqualToString:@""]||
        [self.string1 isEqualToString:@""]||
        [self.string1 isEqualToString:@""]||
        [self.string1 isEqualToString:@""]||
        [self.string1 isEqualToString:@""]||
        [self.string1 isEqualToString:@""]||
        [self.startDate.titleLabel.text isEqualToString:@"选择日期"]||
        [self.endDate.titleLabel.text isEqualToString:@"选择日期"]
        )
    {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
        return;
    }
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
                           @"StartDate":self.startDate.titleLabel.text,
                           @"EndDate":self.endDate.titleLabel.text,
                           @"Monday":self.string1,
                           @"Tuesday":self.string2,
                           @"Wednesday":self.string3,
                           @"Thursday":self.string4,
                           @"Friday":self.string5,
                           @"Saturday":self.string6,
                           @"Sunday":self.string7,
                           @"Important":self.string8,
                           @"GrowthPlans":self.string9,
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


#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arraySummary.count!=0&&!self.isSelect) {
        CellSummary *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell==nil) {
            cell = [[CellSummary alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        NSDictionary *dict = self.arraySummary[indexPath.row];
        cell.labelPostion.text = [ShareModel shareModel].postionName;
        cell.dictInfo = dict;
        [ZXDNetworking setExtraCellLineHidden:tableView];
        return cell;
    }else
    {
    CellEditPlan *cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (canEdit) {
        cell.userInteractionEnabled = YES;
    }else
    {
        cell.userInteractionEnabled = NO;
    }
    [cell.buttonPostil addTarget:self action:@selector(gotoPositil:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.LabelTitle.text = self.arrayContent[indexPath.row];
    cell.textView.delegate = self;
    cell.textView.placeholder = self.arrayContent[indexPath.row];
    if (self.isSelect) {
        switch (indexPath.row) {
            case 0:
                if (self.string1.length!=0) {
                    cell.textView.text = self.string1;
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"monday"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"monday"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                
                break;
            case 1:
                if (self.string2.length!=0) {
                    cell.textView.text = self.string2;
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"tuesday"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"tuesday"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
            case 2:
                if (self.string3.length!=0) {
                    cell.textView.text = self.string3;
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"wednesday"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"wednesday"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
            case 3:
                if (self.string4.length!=0) {
                    cell.textView.text = self.string4;
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"thursday"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"thursday"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
            case 4:
                if (self.string5.length!=0) {
                    cell.textView.text = self.string5;
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"friday"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"friday"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
            case 5:
                if (self.string6.length!=0) {
                    cell.textView.text = self.string6;
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"saturday"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"saturday"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
            case 6:
                if (self.string7.length!=0) {
                    cell.textView.text = self.string7;
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"sunday"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"sunday"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
            case 7:
                if (self.string8.length!=0) {
                    cell.textView.text = self.string8;
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"important"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"important"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
            case 8:
                if (self.string9.length!=0) {
                    cell.textView.text = self.string9;
                }
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"growthPlans"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"growthPlans"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                break;
                
            default:
                break;
        }
    }else
    {
        cell.textView.userInteractionEnabled = NO;
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
            VCInsideWeekSummaryUnPassed *vc = [[VCInsideWeekSummaryUnPassed alloc]init];
            vc.remark = [NSString stringWithFormat:@"%@",dict[@"remark"]];
            vc.isSelect = NO;
            vc.tableID =  dict[@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
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
        case 5:
            self.string6 = textView.text;
            break;
        case 6:
            self.string7 = textView.text;
            break;
        case 7:
            self.string8 = textView.text;
            break;
        case 8:
            self.string9 = textView.text;
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


#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getHttpData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrayTitle = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日",@"重要事项及补充说明",@"本周个人成长规划及自我奖罚管理"];
    self.arrayContent = @[@"填写周一的主要工作",@"填写周二的主要工作",@"填写周三的主要工作",@"填写周四的主要工作",@"填写周五的主要工作",@"填写周六的主要工作",@"填写周日的主要工作",@"填写重要事项补充说明",@"填写本周个人成长规划及自我奖罚管理"];
    
    [self setUI];
    self.title = @"填写周计划";
    
    self.arraySummary = [NSArray array];
    self.dict = [NSMutableDictionary dictionary];
    self.arrayPostil = [NSArray array];
    
    self.isSelect = YES;
    canEdit = NO;

    self.rightItem = [[UIBarButtonItem alloc] initWithTitle:@"..." style:(UIBarButtonItemStyleDone) target:self action:@selector(showChooseEdit)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = self.rightItem;
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
