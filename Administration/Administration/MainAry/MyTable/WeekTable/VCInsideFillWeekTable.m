//
//  VCInsideFillWeekTable.m
//  Administration
//
//  Created by zhang on 2017/9/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCInsideFillWeekTable.h"
#import "CellEditPlan.h"
#import "ViewDatePick.h"
@interface VCInsideFillWeekTable ()<UITableViewDelegate,UITableViewDataSource,ViewDatePickerDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    BOOL isBack;
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
@property (nonatomic)BOOL isSelect;

@property (nonatomic,strong)UIBarButtonItem *item;
@property (nonatomic,weak)ViewDatePick *myDatePick;
@property (nonatomic,assign)NSUInteger buttonTAag;
@property (nonatomic,weak)UIButton *endDate;
@property (nonatomic,weak)UIButton *startDate;

@end

@implementation VCInsideFillWeekTable

-(UIView *)chooseDate
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 108)];
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
    [startDate setTitle:@"选择日期" forState:UIControlStateNormal];
    startDate.titleLabel.textAlignment = NSTextAlignmentLeft;
    startDate.tag = 400;
    [startDate addTarget:self action:@selector(showMydatePick:) forControlEvents:UIControlEventTouchUpInside];
    [startDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [startDate setBackgroundColor:[UIColor whiteColor]];
    [view1 addSubview:startDate];
    [startDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right);
        make.top.mas_equalTo(view1.mas_top);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(100);
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
        make.width.mas_equalTo(100);
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
        self.arrayTitle = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日",@"重要事项及补充说明",@"本周个人成长规划及自我奖罚管理"];
        self.arrayContent = @[@"填写周一的主要工作",@"填写周二的主要工作",@"填写周三的主要工作",@"填写周四的主要工作",@"填写周五的主要工作",@"填写周六的主要工作",@"填写周日的主要工作",@"填写重要事项补充说明",@"填写本周个人成长规划及自我奖罚管理"];
        self.isSelect = YES;
        self.title = @"填写周计划";
        self.navigationItem.rightBarButtonItem = self.item;
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

-(void)showAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要提交此项内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
}

-(void)back
{
    if (self.isSelect) {
        isBack = YES;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"离开后编辑的内容将要消失" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存草稿箱",@"确定" ,nil];
        alertView.tag = 200;
        [alertView show];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)submitData:(NSString *)hint
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/insert",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    if (isBack) {
        if ([self.startDate.titleLabel.text isEqualToString:@"选择日期"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请选择日期" andInterval:1];
            return;
        }
        if ([self.endDate.titleLabel.text isEqualToString:@"选择日期"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写服务店家" andInterval:1];
            return;
        }

    }else
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if (buttonIndex ==1) {
            [self submitData:@"1"];
        }
    }else
    {
        if (buttonIndex==1) {
                        [self submitData:@"3"];
        }
        if (buttonIndex==2) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellEditPlan *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.LabelTitle.text = self.arrayContent[indexPath.row];
    cell.textView.placeholder = self.arrayContent[indexPath.row];
    if (self.isSelect) {
        cell.textView.userInteractionEnabled = YES;
        switch (indexPath.row) {
            case 0:
                if (self.string1.length!=0) {
                    cell.textView.text = self.string1;
                }
                break;
            case 1:
                if (self.string2.length!=0) {
                    cell.textView.text = self.string2;
                }
                break;
            case 2:
                if (self.string3.length!=0) {
                    cell.textView.text = self.string3;
                }
                break;
            case 3:
                if (self.string4.length!=0) {
                    cell.textView.text = self.string4;
                }
                break;
            case 4:
                if (self.string5.length!=0) {
                    cell.textView.text = self.string5;
                }
                break;
            case 5:
                if (self.string6.length!=0) {
                    cell.textView.text = self.string6;
                }
                break;
            case 6:
                if (self.string7.length!=0) {
                    cell.textView.text = self.string7;
                }
                break;
            case 7:
                if (self.string8.length!=0) {
                    cell.textView.text = self.string8;
                }
                break;
            case 8:
                if (self.string9.length!=0) {
                    cell.textView.text = self.string9;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrayTitle = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日",@"重要事项及补充说明",@"本周个人成长规划及自我奖罚管理"];
    self.arrayContent = @[@"填写周一的主要工作",@"填写周二的主要工作",@"填写周三的主要工作",@"填写周四的主要工作",@"填写周五的主要工作",@"填写周六的主要工作",@"填写周日的主要工作",@"填写重要事项补充说明",@"填写本周个人成长规划及自我奖罚管理"];
    
    [self setUI];
    self.title = @"填写周计划";
    
    self.isSelect = YES;
    
    self.string1=  @"";
    self.string2=  @"";
    self.string3=  @"";
    self.string4=  @"";
    self.string5=  @"";
    self.string6=  @"";
    self.string7=  @"";
    self.string8=  @"";
    self.string9=  @"";
    
    
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [submit setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    self.item = [[UIBarButtonItem alloc]initWithCustomView:submit];
    self.navigationItem.rightBarButtonItem = self.item;
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
