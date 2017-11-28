//
//  VCInsideFillMonthTable.m
//  Administration
//
//  Created by zhang on 2017/9/26.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCInsideFillMonthTable.h"
#import "ViewInsideMonthTable.h"
#import "CellEditPlan.h"
#import "ViewDatePick.h"
@interface VCInsideFillMonthTable ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ViewDatePickerDelegate>
{
    BOOL isBack;
}
@property (nonatomic,weak)UIButton *buttonPlan;
@property (nonatomic,weak)UIButton *buttopSummary;
@property (nonatomic,weak)UILabel *labelLine;
@property (nonatomic,weak)ViewInsideMonthTable *insideMonth;
@property (nonatomic,weak)ViewInsideMonthTable *insideMonth1;
@property (nonatomic,weak)ViewDatePick *myDatePick;
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
@property (nonatomic)BOOL isSelect;
@property (nonatomic,strong)UIBarButtonItem *item;

@end

@implementation VCInsideFillMonthTable

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
    [insideMonth.buttonDate addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
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
    
    ViewInsideMonthTable *insideMonth1 = [[ViewInsideMonthTable alloc]initWithFrame:CGRectMake(0, 105, Scree_width,120)];
    [insideMonth1.buttonDate addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    insideMonth1.userInteractionEnabled = NO;
    [viewSummary addSubview:insideMonth1];
    self.insideMonth1 = insideMonth1;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.tableHeaderView = insideMonth1;
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
    
    if (button.tag==100) {
        self.viewPlan.hidden=  NO;
        self.viewSummary.hidden = YES;
        self.labelLine.frame = CGRectMake(0, 104, Scree_width/2, 1);
        [button setTitleColor:GetColor(152, 71, 187, 1) forState:UIControlStateNormal];
        [self.buttopSummary setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
        self.arryaTitle = @[@[@"填写本月主要工作规划"],@[@"第一周",@"第二周",@"第三周",@"第四周",@"补充备注"]];
        self.arrayContent = @[@[@"填写本月主要工作规划"],@[@"填写第一周的工作进度安排",@"填写第二周的工作进度安排",@"填写第三周的工作进度安排",@"填写第四周的工作进度安排",@"填写补充备注"]];
        self.isSelect = YES;
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
        self.arryaTitle = @[@"本月工作完成简述",@"本月工作进度及目标达成的分析",@"当前阶段工作方向，整改策略及建议",@"个人心得感悟",@"下阶段个人成长目标规划及方向预设"];
        self.arrayContent = @[@"填写本月工作完成简述",@"填写本月工作进度及目标达成的分析",@"填写签单阶段工作方向，整改策略及建议",@"填写个人心得感悟",@"填写下阶段个人成长目标规划及方向预设"];
        self.isSelect = NO;
        self.navigationItem.rightBarButtonItem = nil;
    }
    [self.tableView reloadData];
    
}

-(void)showAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要提交此项内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    isBack = NO;
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
        if ([self.insideMonth.buttonDate.titleLabel.text isEqualToString:@"选择日期"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请选择日期" andInterval:1];
            return;
        }
    }else
    {
    
    if ([self.insideMonth.buttonDate.titleLabel.text isEqualToString:@"选择日期"]||
        [self.string1 isEqualToString:@""]||
        [self.string2 isEqualToString:@""]||
        [self.string3 isEqualToString:@""]||
        [self.string4 isEqualToString:@""]||
        [self.string5 isEqualToString:@""]||
        [self.string6 isEqualToString:@""]
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
                           @"Months":[NSString stringWithFormat:@"%@-15",self.insideMonth.buttonDate.titleLabel.text],
                           @"WorkPlan":self.string1,
                           @"FirstWeek":self.string2,
                           @"SecondWeek":self.string3,
                           @"ThirdWeek":self.string4,
                           @"FourthWeek":self.string5,
                           @"Comment":self.string6,
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

-(void)showDatePicker
{
    ViewDatePick *myDatePick=  [[ViewDatePick alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    [self.view endEditing:YES];
    myDatePick.delegate = self;
    [self.view.window addSubview:myDatePick];
    self.myDatePick = myDatePick;
}

-(void)getDate
{
    NSDate *date = self.myDatePick.datePick.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringDate = [[formatter stringFromDate:date] substringToIndex:7];
    [self.insideMonth.buttonDate setTitle:stringDate forState:UIControlStateNormal];
}

#pragma -mark alertView
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
        if (self.isSelect) {
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
    cell.textView.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.isSelect==NO) {
        cell.textView.userInteractionEnabled = NO;
        cell.LabelTitle.text = self.arryaTitle[indexPath.row];
        cell.textView.placeholder = self.arrayContent[indexPath.row];
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
        }else{
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
                break;
            case 3:
                if (self.string5.length!=0) {
                    cell.textView.text = self.string5;
                }
                break;
            case 4:
                if (self.string6.length!=0) {
                    cell.textView.text = self.string6;
                }
                break;
                
            default:
                break;
        }
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
    self.arryaTitle = @[@[@"填写本月主要工作规划"],@[@"第一周",@"第二周",@"第三周",@"第四周",@"补充备注"]];
    self.arrayContent = @[@[@"填写本月主要工作规划"],@[@"填写第一周的工作进度安排",@"填写第二周的工作进度安排",@"填写第三周的工作进度安排",@"填写第四周的工作进度安排",@"填写补充备注"]];
    self.isSelect =  YES;
    
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [submit setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    self.item = [[UIBarButtonItem alloc]initWithCustomView:submit];
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
