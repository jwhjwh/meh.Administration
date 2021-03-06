//
//  VCArtWeekDrafts.m
//  Administration
//
//  Created by zhang on 2017/9/27.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCArtWeekSubmited.h"
#import "ViewArtWeekPlan.h"
#import "ViewArtWeekSummary.h"
#import "CellEditPlan.h"
#import "ViewChooseEdit.h"
#import "CellSummary.h"
#import "VCArtWeekSummarySubmited.h"
#import "VCPositil.h"
@interface VCArtWeekSubmited ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ViewChooseEditDelegate>
{
    BOOL isBack;
    BOOL isEditing;
    BOOL isDouble;
    ViewChooseEdit *chooseEdit;
}
@property (nonatomic,weak)UIButton *buttonPlan;
@property (nonatomic,weak)UIButton *buttopSummary;
@property (nonatomic,weak)UILabel *labelLine;
@property (nonatomic,weak)ViewArtWeekPlan *artWeekPlan;
@property (nonatomic,weak)ViewArtWeekSummary *artWeekSummary;
@property (nonatomic,strong)NSString *string1;
@property (nonatomic,strong)NSString *string2;
@property (nonatomic,strong)NSString *string3;
@property (nonatomic,strong)NSString *string4;
@property (nonatomic,strong)NSArray *arryaTitle;
@property (nonatomic,weak)UIView *viewPlan;
@property (nonatomic,weak)UIView *viewSummary;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)UIBarButtonItem *item;
@property (nonatomic,strong)NSMutableDictionary *dict;
@property (nonatomic,strong)NSArray *arraySummary;
@property (nonatomic,strong)UIBarButtonItem *rightitem1;
@property (nonatomic,strong)UIBarButtonItem *rightitem;
@property (nonatomic,strong)NSArray *arrayPostil;

@property (nonatomic,strong)NSString *startDate;
@property (nonatomic,strong)NSString *endDate;
@end

@implementation VCArtWeekSubmited

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
                [self.artWeekSummary.startDate setTitle:self.startDate forState:UIControlStateNormal];
                [self.artWeekSummary.endDate setTitle:self.startDate forState:UIControlStateNormal];
                [self.artWeekSummary.startDate setTitle:self.startDate forState:UIControlStateNormal];
                [self.artWeekSummary.endDate setTitle:self.endDate forState:UIControlStateNormal];
                self.artWeekSummary.startDate.userInteractionEnabled = NO;
                self.artWeekSummary.endDate.userInteractionEnabled = NO;
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无内容,可以填写" andInterval:1.0];
                return ;
            }
            [self.tableView reloadData];
        }else
        {
            [self setSummaryUI];
            [self.artWeekSummary.startDate setTitle:self.startDate forState:UIControlStateNormal];
            [self.artWeekSummary.endDate setTitle:self.endDate forState:UIControlStateNormal];
            self.artWeekSummary.startDate.userInteractionEnabled = NO;
            self.artWeekSummary.endDate.userInteractionEnabled = NO;
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
            [self.artWeekPlan.startDate setTitle:[self.dict[@"startDate"]substringToIndex:10] forState:UIControlStateNormal];
            [self.artWeekPlan.endDate setTitle:[self.dict[@"endDate"] substringToIndex:10] forState:UIControlStateNormal];
            
            self.startDate = [self.dict[@"startDate"]substringToIndex:10];
            self.endDate = [self.dict[@"endDate"] substringToIndex:10];
            
            self.artWeekPlan.textFiled1.text = [NSString stringWithFormat:@"%@",self.dict[@"managerTask"]];
            self.artWeekPlan.textFiled2.text = [NSString stringWithFormat:@"%@",self.dict[@"managerBalance"]];
            self.artWeekPlan.textFiled3.text = [NSString stringWithFormat:@"%@",self.dict[@"managerAccumulateGoods"]];
            self.artWeekPlan.textFiled4.text = [NSString stringWithFormat:@"%@",self.dict[@"managerReturnedMoney"]];
            self.artWeekPlan.textFiled5.text = [NSString stringWithFormat:@"%@",self.dict[@"managerPredictGoods"]];
            self.artWeekPlan.textFiled6.text = [NSString stringWithFormat:@"%@",self.dict[@"personTask"]];
            self.artWeekPlan.textFiled7.text = [NSString stringWithFormat:@"%@",self.dict[@"personBalance"]];
            self.artWeekPlan.textFiled8.text = [NSString stringWithFormat:@"%@",self.dict[@"personAccumulateGoods"]];
            self.artWeekPlan.textFiled9.text = [NSString stringWithFormat:@"%@",self.dict[@"personReturnedMoney"]];
            self.artWeekPlan.textFiledL.text = [NSString stringWithFormat:@"%@",self.dict[@"personPredictGoods"]];
            self.string1 = self.dict[@"ovas"];
            self.string2 = self.dict[@"important"];
            self.string3 = self.dict[@"personalProject"];
            self.string4 = self.dict[@"others"];
            [self.dict setValue:@"1" forKey:@"canEdit"];
            
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
    
    ViewArtWeekPlan *artWeekPlan = [[ViewArtWeekPlan alloc]initWithFrame:CGRectMake(0, 0, Scree_width,530)];
    [viewPlan addSubview:artWeekPlan];
    artWeekPlan.userInteractionEnabled = NO;
    self.artWeekPlan = artWeekPlan;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.tableHeaderView = artWeekPlan;
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
    self.string1 = @"";
    self.string2 = @"";
    self.string3 = @"";
    self.string4 = @"";
    UIView *viewSummary = [[UIView alloc]init];
    [self.view addSubview:viewSummary];
    [viewSummary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.labelLine.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.bottom);
    }];
    self.viewSummary = viewSummary;
    
    ViewArtWeekSummary *artWeekSummary  = [[ViewArtWeekSummary alloc]initWithFrame:CGRectMake(0, 105, Scree_width,700)];
    [viewSummary addSubview:artWeekSummary];
    self.artWeekSummary = artWeekSummary;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.tableHeaderView = artWeekSummary;
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
   // }
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
   
    [buttonPlan setTitle:@"周计划" forState:UIControlStateNormal];
    [buttonPlan addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventTouchUpInside];
    buttonPlan.tag = 100;
    [self.view addSubview:buttonPlan];
    self.buttonPlan  = buttonPlan;
    
    UIButton *buttonSummary = [[UIButton alloc]initWithFrame:CGRectMake(Scree_width/2, 64, Scree_width/2, 40)];
    [buttonSummary setTitle:@"周总结" forState:UIControlStateNormal];
    
    [buttonSummary addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventTouchUpInside];
    buttonSummary.tag = 200;
    [self.view addSubview:buttonSummary];
    self.buttopSummary = buttonSummary;
    
    UILabel *labelLine = [[UILabel alloc]init];
    labelLine.backgroundColor = GetColor(152, 71, 187, 1);
    [self.view addSubview:labelLine];
    self.labelLine = labelLine;
    
    if (self.isSelect) {
         [buttonPlan setTitleColor:GetColor(152, 71, 187, 1) forState:UIControlStateNormal];
        [buttonSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        labelLine.frame = CGRectMake(0, 104, Scree_width/2, 1);
        [self setPlanUI];
    }else
    {
        [buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        [buttonSummary setTitleColor:GetColor(152, 71, 187, 1) forState:UIControlStateNormal];
        labelLine.frame = CGRectMake(Scree_width/2, 104, Scree_width/2, 1);
        [self setSummaryUI];
    }
}

-(void)changeData:(UIButton *)button
{
    if (button.tag==100) {
        self.viewPlan.hidden=  NO;
        self.viewSummary.hidden = YES;
        self.labelLine.frame = CGRectMake(0, 104, Scree_width/2, 1);
        [button setTitleColor:GetColor(152, 71, 187, 1) forState:UIControlStateNormal];
        [self.buttopSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arryaTitle = @[@"本周主要目标与销售分解及策略",@"本周重要事项备注",@"个人成长规划安排",@"其他事项"];
        self.isSelect = YES;
        self.navigationItem.rightBarButtonItem = self.rightitem1;
        [self getHttpData];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = self.rightitem;
        self.labelLine.frame = CGRectMake(Scree_width/2, 104, Scree_width/2, 1);
        [button setTitleColor:GetColor(152, 71, 187, 1) forState:UIControlStateNormal];
        [self.buttonPlan setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arryaTitle = @[@"工作分析和工作整改建议",@"出现问题及解决方案和建议",@"自我心得体会及总结",@"其他事项"];
        self.isSelect = NO;
        self.viewPlan.hidden = YES;
        [self getSummary];

        
        
//        if (self.arraySummary.count!=0) {
//            [self setSummaryList];
//        }else
//        {
//            [self.viewSummary removeFromSuperview];
//            [self setSummaryUI];
//        }
       
        
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
        
        isDouble = YES;
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
//            self.navigationItem.rightBarButtonItem = btn;
        UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(31, 0, 25, 25)];
        [button2 setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button2];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        
            self.artWeekPlan.userInteractionEnabled = YES;
            [self.dict setValue:@"2" forKey:@"canEdit"];
        
        
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

-(void)submitData:(NSString *)hint
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/insert",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    if ([self.artWeekPlan.startDate.titleLabel.text isEqualToString:@"选择日期"]||
        [self.artWeekPlan.endDate.titleLabel.text isEqualToString:@"选择日期"]||
        self.artWeekPlan.textFiled1.text.length==0||
        self.artWeekPlan.textFiled2.text.length==0||
        self.artWeekPlan.textFiled3.text.length==0||
        self.artWeekPlan.textFiled4.text.length==0||
        self.artWeekPlan.textFiled5.text.length==0||
        self.artWeekPlan.textFiled6.text.length==0||
        self.artWeekPlan.textFiled7.text.length==0||
        self.artWeekPlan.textFiled8.text.length==0||
        self.artWeekPlan.textFiled9.text.length==0||
        self.artWeekPlan.textFiledL.text.length==0||
        [self.string1 isEqualToString:@""]||
        [self.string2 isEqualToString:@""]||
        [self.string3 isEqualToString:@""]||
        [self.string4 isEqualToString:@""])
    {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
        return;
    }
    if (self.isSelect) {
    
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Num":[ShareModel shareModel].num,
                           @"DepartmentID":[ShareModel shareModel].departmentID,
                           @"code":@"1",
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"CompanyInfoId":compid,
                           @"Sort":[ShareModel shareModel].sort,
                           @"StartDate":self.artWeekPlan.startDate.titleLabel.text,
                           @"EndDate":self.artWeekPlan.endDate.titleLabel.text,
                           @"managerTask":self.artWeekPlan.textFiled1.text,
                           @"managerBalance":self.artWeekPlan.textFiled2.text,
                           @"managerAccumulateGoods":self.artWeekPlan.textFiled3.text,
                           @"managerReturnedMoney":self.artWeekPlan.textFiled4.text,
                           @"managerPredictGoods":self.artWeekPlan.textFiled5.text,
                           @"personTask":self.artWeekPlan.textFiled6.text,
                           @"personBalance":self.artWeekPlan.textFiled7.text,
                           @"personAccumulateGoods":self.artWeekPlan.textFiled8.text,
                           @"personReturnedMoney":self.artWeekPlan.textFiled9.text,
                           @"personPredictGoods":self.artWeekPlan.textFiledL.text,
                           @"OVAS":self.string1,
                           @"Important":self.string2,
                           @"PersonalProject":self.string3,
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
        if ([self.artWeekSummary.startDate.titleLabel.text isEqualToString:@"选择日期"]||
            [self.artWeekSummary.endDate.titleLabel.text isEqualToString:@"选择日期"]||
            self.artWeekSummary.textFiled1.text.length==0||
            self.artWeekSummary.textFiled2.text.length==0||
            self.artWeekSummary.textFiled3.text.length==0||
            self.artWeekSummary.textFiled4.text.length==0||
            self.artWeekSummary.textFiled5.text.length==0||
            self.artWeekSummary.textFiled6.text.length==0||
            self.artWeekSummary.textFiled7.text.length==0||
            self.artWeekSummary.textFiled8.text.length==0||
            self.artWeekSummary.textFiled9.text.length==0||
            self.artWeekSummary.textFiledA.text.length==0||
            self.artWeekSummary.textFiledB.text.length==0||
            self.artWeekSummary.textFiledC.text.length==0||
            self.artWeekSummary.textFiledD.text.length==0||
            self.artWeekSummary.textFiledE.text.length==0||
            self.artWeekSummary.textFiledF.text.length==0||
            self.artWeekSummary.textFiledG.text.length==0||
            [self.string1 isEqualToString:@""]||
            [self.string2 isEqualToString:@""]||
            [self.string3 isEqualToString:@""]||
            [self.string4 isEqualToString:@""])
        {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
            return;
        }
        
        NSMutableDictionary *dictl = [NSMutableDictionary dictionary];
        [dictl setValue:appKeyStr forKey:@"appkey"];
        [dictl setValue:[USER_DEFAULTS valueForKey:@"userid"] forKey:@"usersid"];
        [dictl setValue:[ShareModel shareModel].num forKey:@"Num"];
        [dictl setValue:[ShareModel shareModel].departmentID forKey:@"DepartmentID"];
        [dictl setValue:@"2" forKey:@"code"];
        [dictl setValue:[ShareModel shareModel].roleID forKey:@"RoleId"];
        [dictl setValue:compid forKey:@"CompanyInfoId"];
        [dictl setValue:[ShareModel shareModel].sort forKey:@"Sort"];
        [dictl setValue:self.tableID forKey:@"PlanId"];
        [dictl setValue:hint forKey:@"Hint"];
        [dictl setValue:[USER_DEFAULTS valueForKey:@"name"] forKey:@"Name"];
        [dictl setValue:self.artWeekSummary.startDate.titleLabel.text forKey:@"StartDate"];
        [dictl setValue:self.artWeekSummary.endDate.titleLabel.text forKey:@"EndDate"];
        [dictl setValue:self.artWeekSummary.textFiled1.text forKey:@"managerTask"];
        [dictl setValue:self.artWeekSummary.textFiled2.text forKey:@"managerPredictMoney"];
        [dictl setValue:self.artWeekSummary.textFiled3.text forKey:@"managerPracticalMoney"];
        [dictl setValue:self.artWeekSummary.textFiled4.text forKey:@"managerPredictCargo"];
        [dictl setValue:self.artWeekSummary.textFiled5.text forKey:@"managerPracticalCargo"];
        [dictl setValue:self.artWeekSummary.textFiled6.text forKey:@"managerAccumulateCargo"];
        [dictl setValue:self.artWeekSummary.textFiled7.text forKey:@"managerWeeklyMoney"];
        [dictl setValue:self.artWeekSummary.textFiled8.text forKey:@"managerWeekendMoney"];
        [dictl setValue:self.artWeekSummary.textFiled9.text forKey:@"task"];
        [dictl setValue:self.artWeekSummary.textFiledA.text forKey:@"predictMoney"];
        [dictl setValue:self.artWeekSummary.textFiledB.text forKey:@"practicalMoney"];
        [dictl setValue:self.artWeekSummary.textFiledC.text forKey:@"predictCargo"];
        [dictl setValue:self.artWeekSummary.textFiledD.text forKey:@"practicalCargo"];
        [dictl setValue:self.artWeekSummary.textFiledE.text forKey:@"accumulateCargo"];
        [dictl setValue:self.artWeekSummary.textFiledF.text forKey:@"weeklyMoney"];
        [dictl setValue:self.artWeekSummary.textFiledG.text forKey:@"weekendMoney"];
        
        if (self.string1.length!=0) {
            [dictl setValue:self.string1 forKey:@"JAATS"];
        }else
        {
            [dictl setValue:@"" forKey:@"JAATS"];
        }
        
        if (self.string2.length!=0) {
            [dictl setValue:self.string2 forKey:@"PSP"];
        }else
        {
            [dictl setValue:@"" forKey:@"PSP"];
        }
        
        if (self.string3.length!=0) {
            [dictl setValue:self.string3 forKey:@"comments"];
        }else
        {
            [dictl setValue:@"" forKey:@"comments"];
        }
        
        if (self.string4.length!=0) {
            [dictl setValue:self.string4 forKey:@"others"];
        }else
        {
            [dictl setValue:@"" forKey:@"others"];
        }
        
        [ZXDNetworking POST:urlStr parameters:dictl success:^(id responseObject) {
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
        CellSummary *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell==nil) {
            cell = [[CellSummary alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        }
        NSDictionary *dict = self.arraySummary[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        [cell.buttonPostil addTarget:self action:@selector(gotoPositil:) forControlEvents:UIControlEventTouchUpInside];
    cell.LabelTitle.text = self.arryaTitle[indexPath.row];
    cell.textView.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    if (self.isSelect==NO) {
        cell.textView.placeholder = @"暂无";
        switch (indexPath.row)  {
        case 0:
            if (self.string1.length!=0) {
                cell.textView.text = self.string1;
            }
            
            for (NSString *string in self.arrayPostil) {
                if ([string containsString:@"jaats"]) {
                    cell.buttonPostil.hidden = NO;
                    cell.labelNumber.hidden = NO;
                    cell.buttonPostil.userInteractionEnabled  =YES;
                    NSRange rang = [string rangeOfString:@"jaats"];
                    cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                }
            }
            
            break;
        case 1:
            if (self.string2.length!=0) {
                cell.textView.text = self.string2;
            }
            
            for (NSString *string in self.arrayPostil) {
                if ([string containsString:@"psp"]) {
                    cell.buttonPostil.hidden = NO;
                    cell.labelNumber.hidden = NO;
                    cell.buttonPostil.userInteractionEnabled = YES;
                    NSRange rang = [string rangeOfString:@"psp"];
                    cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                }
            }
            
            break;
        case 2:
            if (self.string3.length!=0) {
                cell.textView.text = self.string3;
            }
            
            for (NSString *string in self.arrayPostil) {
                if ([string containsString:@"comments"]) {
                    cell.buttonPostil.hidden = NO;
                    cell.labelNumber.hidden = NO;
                    cell.buttonPostil.userInteractionEnabled = YES;
                    NSRange rang = [string rangeOfString:@"comments"];
                    cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                }
            }
            
            break;
        case 3:
            if (self.string4.length!=0) {
                cell.textView.text = self.string4;
            }
            for (NSString *string in self.arrayPostil) {
                if ([string containsString:@"others"]) {
                    cell.buttonPostil.hidden = NO;
                    cell.labelNumber.hidden = NO;
                    cell.buttonPostil.userInteractionEnabled = YES;
                    NSRange rang = [string rangeOfString:@"others"];
                    cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                }
            }
            
            break;
            
        default:
            break;
        }
    }
    else
    {
        if ([self.dict[@"canEdit"]isEqualToString:@"2"]) {
            cell.textView.userInteractionEnabled = YES;
        }else
        {
            cell.textView.userInteractionEnabled = NO;
        }
        
        switch (indexPath.row) {
            case 0:
                if (self.string1.length!=0) {
                    cell.textView.text = self.string1;
                }else
                {
                    cell.textView.placeholder = @"填写本周主要目标与销售分解及策略";
                }
            
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"OVAS"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled  =YES;
                        NSRange rang = [string rangeOfString:@"OVAS"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                
                break;
            case 1:
                if (self.string2.length!=0) {
                    cell.textView.text = self.string2;
                }else
                {
                    cell.textView.placeholder = @"本周重要事项备注";
                }
                
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"important"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled = YES;
                        NSRange rang = [string rangeOfString:@"important"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                
                break;
            case 2:
                if (self.string3.length!=0) {
                    cell.textView.text = self.string3;
                }else
                {
                    cell.textView.placeholder = @"个人成长规划安排";
                }
                
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"personalProject"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled = YES;
                        NSRange rang = [string rangeOfString:@"personalProject"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                
                break;
            case 3:
                if (self.string4.length!=0) {
                    cell.textView.text = self.string4;
                }else
                {
                    cell.textView.placeholder = @"其他事项";
                }
                
                for (NSString *string in self.arrayPostil) {
                    if ([string containsString:@"others"]) {
                        cell.buttonPostil.hidden = NO;
                        cell.labelNumber.hidden = NO;
                        cell.buttonPostil.userInteractionEnabled = YES;
                        NSRange rang = [string rangeOfString:@"others"];
                        cell.labelNumber.text = [string substringWithRange:NSMakeRange(rang.length+1, string.length-rang.length-1)];
                    }
                }
                
                break;
                
            default:
                break;
        }
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
            VCArtWeekSummarySubmited *vc = [[VCArtWeekSummarySubmited alloc]init];
            vc.remark = [NSString stringWithFormat:@"%@",dict[@"remark"]];
            vc.isSelect = NO;
            vc.tableID =  [NSString stringWithFormat:@"%@",dict[@"id"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
    [self getHttpData];
    
    self.arryaTitle = @[@"本周主要目标与销售分解及策略",@"本周重要事项备注",@"个人成长规划安排",@"其他事项"];
    self.dict = [NSMutableDictionary dictionary];
    self.arraySummary = [NSArray array];
    
        self.rightitem1 = [[UIBarButtonItem alloc] initWithTitle:@"..." style:(UIBarButtonItemStyleDone) target:self action:@selector(showChooseEdit)];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [self.rightitem1 setTitleTextAttributes:dict forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = self.rightitem1;
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(31, 0, 25, 25)];
    [button2 setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.rightitem = [[UIBarButtonItem alloc]initWithCustomView:button2];
    
    self.string1 = @"";
    self.string2 = @"";
    self.string3 = @"";
    self.string4 = @"";
    
    self.arrayPostil = [NSArray array];
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
