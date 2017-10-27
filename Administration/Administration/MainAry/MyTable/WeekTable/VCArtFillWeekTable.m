//
//  VCArtFillWeekTable.m
//  Administration
//
//  Created by zhang on 2017/9/20.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCArtFillWeekTable.h"
#import "ViewArtWeekPlan.h"
#import "ViewArtWeekSummary.h"
#import "CellEditPlan.h"
@interface VCArtFillWeekTable ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    BOOL isBack;
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
@property (nonatomic)BOOL isSelect;
@property (nonatomic,strong)UIBarButtonItem *item;
@end

@implementation VCArtFillWeekTable

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
    UIView *viewSummary = [[UIView alloc]init];
    [self.view addSubview:viewSummary];
    [viewSummary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.labelLine.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.bottom);
    }];
    self.viewSummary = viewSummary;
    
    ViewArtWeekSummary *artWeekSummary =  [[ViewArtWeekSummary alloc]initWithFrame:CGRectMake(0, 105, Scree_width,700)];
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
        self.arryaTitle = @[@"本周主要目标与销售分解及策略",@"本周重要事项备注",@"个人成长规划安排",@"其他事项"];
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
        self.arryaTitle = @[@"工作分析和工作整改建议",@"出现问题及解决方案和建议",@"自我心得体会及总结",@"其他事项"];
        self.isSelect = NO;
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
    
    if (isBack==NO) {
        
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
    }else
    {
        if ([self.artWeekPlan.startDate.titleLabel.text isEqualToString:@"选择日期"]||
            [self.artWeekPlan.endDate.titleLabel.text isEqualToString:@"选择日期"]) {
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
//            if (self.string1.length==0) {
//                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请选择日期" andInterval:1];
//                return;
//            }
//            if (self.string2.length==0) {
//                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写服务店家" andInterval:1];
//                return;
//            }
            [self submitData:@"3"];
        }
        if (buttonIndex==2) {
            [self.navigationController popViewControllerAnimated:YES];
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
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellEditPlan *cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.LabelTitle.text = self.arryaTitle[indexPath.row];
    cell.textView.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.isSelect==NO) {
        cell.textView.placeholder = @"暂无";
        cell.textView.userInteractionEnabled = NO;
    }
    else
    {
    switch (indexPath.row) {
        case 0:
            if (self.string1.length!=0) {
                cell.textView.text = self.string1;
            }else
            {
                cell.textView.placeholder = @"填写本周主要目标与销售分解及策略";
            }
            break;
        case 1:
            if (self.string2.length!=0) {
                cell.textView.text = self.string2;
            }else
            {
                cell.textView.placeholder = @"填写本周重要事项备注";
            }
            break;
        case 2:
            if (self.string3.length!=0) {
                cell.textView.text = self.string3;
            }else
            {
                cell.textView.placeholder = @"填写本周个人成长规划安排";
            }
            break;
        case 3:
            if (self.string4.length!=0) {
                cell.textView.text = self.string4;
            }else
            {
                cell.textView.placeholder = @"填写其他事项";
            }
            break;
            
        default:
            break;
    }
    }
    return cell;
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
    
    self.arryaTitle = @[@"本周主要目标与销售分解及策略",@"本周重要事项备注",@"个人成长规划安排",@"其他事项"];
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
