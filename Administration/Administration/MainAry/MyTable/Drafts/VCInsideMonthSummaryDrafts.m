//
//  VCInsideMonthSummaryDrafts.m
//  Administration
//
//  Created by zhang on 2017/9/28.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCInsideMonthSummaryDrafts.h"
#import "ViewInsideMonthTable.h"
#import "CellEditPlan.h"
#import "ViewChooseEdit.h"
@interface VCInsideMonthSummaryDrafts ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ViewChooseEditDelegate>
{
    BOOL isBack;
    BOOL isEditing;
    ViewChooseEdit *chooseEdit;
    BOOL canEdit;
}
@property (nonatomic,weak)UIButton *buttonPlan;
@property (nonatomic,weak)UIButton *buttopSummary;
@property (nonatomic,weak)UILabel *labelLine;
@property (nonatomic,weak)ViewInsideMonthTable *insideMonth;
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
@property (nonatomic,strong)UIBarButtonItem *item;
@property (nonatomic,strong)NSMutableDictionary *dict;

@end

@implementation VCInsideMonthSummaryDrafts
-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryReportInfo",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = [NSDictionary dictionary];
    if (self.isSelect) {
        dict = @{@"appkey":appKeyStr,
                 @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                 @"CompanyInfoId":compid,
                 @"RoleId":[ShareModel shareModel].roleID,
                 @"DepartmentID":[ShareModel shareModel].departmentID,
                 @"remark":self.remark,
                 @"id":self.planID};
    }else
    {
        dict = @{@"appkey":appKeyStr,
                 @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                 @"CompanyInfoId":compid,
                 @"RoleId":[ShareModel shareModel].roleID,
                 @"DepartmentID":[ShareModel shareModel].departmentID,
                 @"remark":self.remark,
                 @"id":self.tableID};
    }
    
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.dict = [[responseObject valueForKey:@"tableInfo"]mutableCopy];
            if (self.isSelect) {
                self.insideMonth.buttonDate.titleLabel.text = [self.dict[@"dates"]substringToIndex:10];
                self.string1 = self.dict[@"workPlan"];
                self.string2 = self.dict[@"firstWeek"];
                self.string3 = self.dict[@"secondWeek"];
                self.string4 = self.dict[@"thirdWeek"];
                self.string5 = self.dict[@"fourthWeek"];
                self.string6 = self.dict[@"comment"];
            }else
            {
            self.planID = self.dict[@"planId"];
            self.insideMonth.buttonDate.titleLabel.text = [self.dict[@"dates"]substringToIndex:10];
            self.string1 = self.dict[@"completeProgressBriefly"];
            self.string2 = self.dict[@"progressEvaluation"];
            self.string3 = self.dict[@"strategy"];
            self.string4 = self.dict[@"experience"];
            self.string5 = self.dict[@"directionPreset"];
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
    
    ViewInsideMonthTable *insideMonth = [[ViewInsideMonthTable alloc]initWithFrame:CGRectMake(0, 105, Scree_width,120)];
    [viewPlan addSubview:insideMonth];
    self.insideMonth = insideMonth;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.tableHeaderView = insideMonth;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 130;
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
    
    ViewInsideMonthTable *insideMonth = [[ViewInsideMonthTable alloc]initWithFrame:CGRectMake(0, 105, Scree_width,120)];
    insideMonth.userInteractionEnabled = NO;
    [viewSummary addSubview:insideMonth];
    self.insideMonth = insideMonth;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.tableHeaderView = insideMonth;
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

-(void)setUI
{
    UIButton *buttonPlan = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, Scree_width/2, 40)];
    [buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [buttonPlan setTitle:@"月计划" forState:UIControlStateNormal];
    [buttonPlan addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventTouchUpInside];
    buttonPlan.tag = 100;
    [self.view addSubview:buttonPlan];
    self.buttonPlan  = buttonPlan;
    
    UIButton *buttonSummary = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width/2, 64, Scree_width/2, 40)];
    [buttonSummary setTitle:@"月总结" forState:UIControlStateNormal];
    [buttonSummary setTitleColor:GetColor(152, 71, 187, 1) forState:UIControlStateNormal];
    [buttonSummary addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventTouchUpInside];
    buttonSummary.tag = 200;
    [self.view addSubview:buttonSummary];
    self.buttopSummary = buttonSummary;
    
    UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(Scree_width/2,104, Scree_width/2, 1)];
    labelLine.backgroundColor = GetColor(152, 71, 187, 1);
    [self.view addSubview:labelLine];
    self.labelLine = labelLine;
    
    [self setSummaryUI];
    
    
}
-(void)changeData:(UIButton *)button
{
    if (button.tag==100) {
        self.viewPlan.hidden=  NO;
        self.viewSummary.hidden = YES;
        self.labelLine.frame = CGRectMake(0, 104, Scree_width/2, 1);
        [button setTitleColor:GetColor(152, 71, 187, 1) forState:UIControlStateNormal];
        [self.buttopSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arryaTitle = @[@[@"填写本月主要工作规划"],@[@"第一周",@"第二周",@"第三周",@"第四周",@"补充备注"]];
        self.arrayContent = @[@[@"填写本月主要工作规划"],@[@"填写第一周的工作进度安排",@"填写第二周的工作进度安排",@"填写第三周的工作进度安排",@"填写第四周的工作进度安排",@"填写补充备注"]];
        self.isSelect = YES;
        self.navigationItem.rightBarButtonItem = nil;
        [self setPlanUI];
        self.remark = @"12";
        
    }
    else
    {
        self.labelLine.frame = CGRectMake(Scree_width/2, 104, Scree_width/2, 1);
        [button setTitleColor:GetColor(152, 71, 187, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        [self.viewSummary removeFromSuperview];
        [self setSummaryUI];
        self.viewPlan.hidden = YES;
        self.arryaTitle = @[@"本月工作完成简述",@"本月工作进度及目标达成的分析",@"当前阶段工作方向，整改策略及建议",@"个人心得感悟",@"写阶段个人成长目标规划及方向预设"];
        self.arrayContent = @[@"填写本月工作完成简述",@"填写本月工作进度及目标达成的分析",@"填写签单阶段工作方向，整改策略及建议",@"填写个人心得感悟",@"填写下阶段个人成长目标规划及方向预设"];
        self.isSelect = NO;
        canEdit = NO;
        self.navigationItem.rightBarButtonItem = self.item;
        self.remark = @"13";
    }
    [self getHttpData];
    [self.tableView reloadData];
    
}

-(void)showChooseEdit
{
    chooseEdit  = [[ViewChooseEdit alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    chooseEdit.delegate = self;
    chooseEdit.arrayButton = @[@"编辑",@"删除",@"取消"];
    [self.view addSubview:chooseEdit];
}



-(void)getState
{
    NSIndexPath *indexPath = [chooseEdit.tableView indexPathForSelectedRow];
    if (indexPath.row==0) {
        
        UIToolbar*tools=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 100, 39)];
        //解决出现的那条线
        tools.clipsToBounds = YES;
        //解决tools背景颜色的问题
        [tools setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [tools setShadowImage:[UIImage new]forToolbarPosition:UIToolbarPositionAny];
        //添加两个button
        NSMutableArray*buttons=[[NSMutableArray alloc]initWithCapacity:2];
        
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [button1 setImage:[UIImage imageNamed:@"bc_ico01"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(showSave) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(31, 0, 25, 25)];
        [button2 setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:button1];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
        
        [buttons addObject:item1];
        [buttons addObject:item2];
        [tools setItems:buttons animated:NO];
        UIBarButtonItem *btn=[[UIBarButtonItem  alloc]initWithCustomView:tools];
        
        self.navigationItem.rightBarButtonItem = btn;
        self.insideMonth.userInteractionEnabled = YES;
        isEditing = YES;
        canEdit = YES;
        [self.tableView reloadData];
    }else if(indexPath.row==1)
    {
        [self deleteDrafts];
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
                           @"code":self.code,
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
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else
    {
        if (buttonIndex==1) {
            isBack = YES;
            [self submitData:@"3"];
        }
    }
}
-(void)submitData:(NSString *)hint
{
    NSString *urlStr;
    if ([hint isEqualToString:@"3"]) {
        urlStr = [NSString stringWithFormat:@"%@report/updateReport",KURLHeader];
    }else
    {
        urlStr =[NSString stringWithFormat:@"%@report/insert",KURLHeader];
    }
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    if ([self.insideMonth.buttonDate.titleLabel.text isEqualToString:@"选择日期"]||
        [self.string1 isEqualToString:@""]||
        [self.string2 isEqualToString:@""]||
        [self.string3 isEqualToString:@""]||
        [self.string4 isEqualToString:@""]||
        [self.string5 isEqualToString:@""]||
        [self.string5 isEqualToString:@""]||
        [self.string5 isEqualToString:@""]
        )
    {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
        return;
    }
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Num":[ShareModel shareModel].num,
                           @"DepartmentID":[ShareModel shareModel].departmentID,
                           @"code":@"1",
                           @"id":[NSString stringWithFormat:@"%@",self.dict[@"id"]],
                           @"PlanId":self.planID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"CompanyInfoId":compid,
                           @"Sort":[ShareModel shareModel].sort,
                           @"Months":[NSString stringWithFormat:@"%@-15",self.insideMonth.buttonDate.titleLabel.text],
                           @"completeProgressBriefly":self.string1,
                           @"progressEvaluation":self.string2,
                           @"strategy":self.string3,
                           @"experience":self.string4,
                           @"directionPreset":self.string5,
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

#pragma -mark textView

-(void)textViewDidChange:(UITextView *)textView
{
    CellEditPlan *cell = (CellEditPlan *)[textView superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            self.string1 = textView.text;
        }
    }else
    {
        switch (indexPath.row) {
            case 0:
                self.string2 = textView.text;
                break;
            case 1:
                self.string3 = textView.text;
                break;
            case 2:
                self.string4 = textView.text;
                break;
            case 3:
                self.string5 = textView.text;
                break;
            case 4:
                self.string6 = textView.text;
                break;
                
            default:
                break;
        }
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isSelect) {
        return 2;
    }
    else
    {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSelect) {
        if (section==0) {
            return 1;
        }else
        {
            return 5;
        }
    }else
    {
        return self.arryaTitle.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellEditPlan *cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (self.isSelect) {
        cell.textView.userInteractionEnabled = NO;;
    }else
    {
        if (canEdit==YES) {
            cell.textView.userInteractionEnabled = YES;;
        }else
        {
            cell.textView.userInteractionEnabled = NO;;
        }
    }
    
    cell.textView.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.isSelect==NO) {
        cell.LabelTitle.text = self.arryaTitle[indexPath.row];
        cell.textView.placeholder = self.arrayContent[indexPath.row];
        switch (indexPath.row) {
            case 0:
                cell.textView.text = self.string1;
                break;
            case 1:
                cell.textView.text = self.string2;
                break;
            case 2:
                cell.textView.text = self.string3;
                break;
            case 3:
                cell.textView.text = self.string4;
                break;
            case 4:
                cell.textView.text = self.string5;
                break;
                
            default:
                break;
        }
    }
    else
    {
        NSArray *arrayt = self.arryaTitle[indexPath.section];
        cell.LabelTitle.text = arrayt[indexPath.row];
        NSArray *arrayc = self.arrayContent[indexPath.section];
        cell.textView.placeholder = arrayc[indexPath.row];
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                if (self.string1.length!=0) {
                    cell.textView.text = self.string1;
                }
            }
        }
        switch (indexPath.row) {
            case 0:
                if (self.string2.length!=0) {
                    cell.textView.text = self.string2;
                }
                break;
            case 1:
                if (self.string3.length!=0) {
                    cell.textView.text = self.string3;
                }
                break;
            case 2:
                if (self.string4.length!=0) {
                    cell.textView.text = self.string4;
                }
            case 3:
                if (self.string5.length!=0) {
                    cell.textView.text = self.string5;
                }
            case 4:
                if (self.string6.length!=0) {
                    cell.textView.text = self.string6;
                }
                break;
                
            default:
                break;
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isSelect) {
        
        if (section==0)
        {
            return 0.1f;
        }
        else
        {
            return 14.0f;
        }
    }else
    {
        return 0.1f;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 14)];
        view.backgroundColor = GetColor(230, 231, 232, 1);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, Scree_width, 14)];
        label.text = @"相应周具体工作及时间进度安排";
        label.font = [UIFont systemFontOfSize:12];
        [view addSubview:label];
        return view;
    }else
    {
        return nil;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
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
    
    self.arryaTitle = @[@"本月工作完成简述",@"本月工作进度及目标达成的分析",@"当前阶段工作方向，整改策略及建议",@"个人心得感悟",@"写阶段个人成长目标规划及方向预设"];
    self.arrayContent = @[@"填写本月工作完成简述",@"填写本月工作进度及目标达成的分析",@"填写签单阶段工作方向，整改策略及建议",@"填写个人心得感悟",@"填写下阶段个人成长目标规划及方向预设"];
    
    self.dict = [NSMutableDictionary dictionary];
    canEdit = NO;
    self.item = [[UIBarButtonItem alloc] initWithTitle:@"..." style:(UIBarButtonItemStyleDone) target:self action:@selector(showChooseEdit)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.item setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = self.item;
    
    self.string1 = @"";
    self.string2 = @"";
    self.string3 = @"";
    self.string4 = @"";
    self.string5 = @"";
    self.string6 = @"";
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
