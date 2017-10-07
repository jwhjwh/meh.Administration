//
//  VCArtShopNewPostil.m
//  Administration
//
//  Created by zhang on 2017/9/28.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCArtShopNewPostil.h"
#import "CellEditPlan.h"
#import "ViewDatePick.h"
@interface VCArtShopNewPostil ()
<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,ViewDatePickerDelegate,UIAlertViewDelegate>

{
    UIButton *button;
    NSArray *arrayTitle;
    UITableView *tableView1;
    ViewDatePick *myDatePick;
    BOOL isBack;
}

@property(nonatomic,strong) NSString *string1;
@property(nonatomic,strong) NSString *string2;
@property(nonatomic,strong) NSString *string3;
@property(nonatomic,strong) NSString *string4;
@property(nonatomic,strong) NSString *string5;
@property(nonatomic,strong) NSString *string6;
@property(nonatomic,strong) NSString *string7;
@property(nonatomic,strong) NSString *string8;
@property(nonatomic,strong) NSString *string9;
@property(nonatomic,strong) NSString *summary;

@end

@implementation VCArtShopNewPostil

-(void)setUI
{
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = GetColor(188, 189, 190, 1);
    [self.view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(-1);
        make.right.mas_equalTo (self.view.mas_right).offset(1);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.mas_equalTo(66);
    }];
    
    UILabel *labelDate = [[UILabel alloc]init];
    labelDate.text = @"  日期";
    labelDate.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:labelDate];
    [labelDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view1.mas_left);
        make.top.mas_equalTo(view1.mas_top);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(50);
    }];
    
    button = [[UIButton alloc]init];
    [button setTitle:@"选择日期" forState:UIControlStateNormal];
    [button setTitleColor:GetColor(188, 189, 190, 1) forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button setBackgroundColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelDate.mas_right);
        make.top.mas_equalTo(view1.mas_top);
        make.right.mas_equalTo(view1.mas_right);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labelPistion = [[UILabel alloc]init];
    labelPistion.text = @"  职位";
    labelPistion.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:labelPistion];
    [labelPistion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view1.mas_left);
        make.top.mas_equalTo(labelDate.mas_bottom).offset(1);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(50);
    }];
    
    UILabel *labelPistionName = [[UILabel alloc]init];
    labelPistionName.text = [NSString stringWithFormat:@"  %@",[ShareModel shareModel].postionName];
    labelPistionName.backgroundColor = [UIColor whiteColor];
    labelPistionName.textColor= GetColor(188, 189, 190, 1);
    [view1 addSubview:labelPistionName];
    [labelPistionName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelPistion.mas_right);
        make.top.mas_equalTo(button.mas_bottom).offset(1);
        make.right.mas_equalTo(view1.mas_right);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *labelName = [[UILabel alloc]init];
    labelName.text = @"  姓名";
    labelName.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view1.mas_left);
        make.top.mas_equalTo(labelPistion.mas_bottom).offset(1);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(50);
    }];
    
    UILabel *labelName2 = [[UILabel alloc]init];
    labelName2.text = [NSString stringWithFormat:@"  %@",[USER_DEFAULTS valueForKey:@"name"]];
    labelName2.textColor = GetColor(188, 189, 190, 1);
    labelName2.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:labelName2];
    [labelName2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelName.mas_right);
        make.top.mas_equalTo(labelPistionName.mas_bottom).offset(1);
        make.right.mas_equalTo(view1.mas_right);
        make.height.mas_equalTo(21);
    }];
    
    tableView1 = [[UITableView alloc]init];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView1.rowHeight = UITableViewAutomaticDimension;
    tableView1.estimatedRowHeight = 100;
    [tableView1 registerClass:[CellEditPlan class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView1];
    [tableView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view1.mas_bottom).offset(1);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [self.view addSubview:tableView1];
    
}

-(void)showDatePicker
{
    myDatePick = [[ViewDatePick alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    myDatePick.delegate = self;
    [self.view addSubview:myDatePick];
}

-(void)submitData:(NSString *)hint
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/insert",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    if (isBack==NO) {
        if (self.string9.length==0||self.string8.length==0||self.string7.length==0||self.string6.length==0||self.string5.length==0||self.string4.length==0||self.string3.length==0||self.string2.length==0||self.string1.length==0||self.summary.length==0||[button.titleLabel.text isEqualToString:@"选择日期"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1];
            return;
        }
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:appKeyStr forKey:@"appkey"];
    [dict setValue:[USER_DEFAULTS valueForKey:@"userid"] forKey:@"usersid"];
    [dict setValue:compid forKey:@"CompanyInfoId"];
    [dict setValue:[ShareModel shareModel].roleID forKey:@"RoleId"];
    [dict setValue:[ShareModel shareModel].departmentID forKey:@"DepartmentID"];
    [dict setValue:[ShareModel shareModel].num forKey:@"Num"];
    [dict setValue:@"1" forKey:@"Sort"];
    [dict setValue:@"2" forKey:@"code"];
    if (self.string1.length!=0) {
        [dict setValue:self.string1 forKey:@"Store"];
    }else
    {
        [dict setValue:@"" forKey:@"Store"];
    }
    
    if (self.string2.length!=0) {
        [dict setValue:self.string2 forKey:@"Aim"];
    }else
    {
        [dict setValue:@"" forKey:@"Aim"];
    }
    if (self.string3.length!=0) {
        [dict setValue:self.string3 forKey:@"Achievement"];
    }else
    {
        [dict setValue:@"" forKey:@"Achievement"];
    }
    if (self.string4.length!=0) {
        [dict setValue:self.string4 forKey:@"Shipment"];
    }else
    {
        [dict setValue:@"" forKey:@"Shipment"];
    }
    if (self.string5.length!=0) {
        [dict setValue:self.string4 forKey:@"Question"];
    }else
    {
        [dict setValue:@"" forKey:@"Question"];
    }
    if (self.string6.length!=0) {
        [dict setValue:self.string4 forKey:@"Solution"];
    }else
    {
        [dict setValue:@"" forKey:@"Solution"];
    }
    if (self.string7.length!=0) {
        [dict setValue:self.string4 forKey:@"Apperception"];
    }else
    {
        [dict setValue:@"" forKey:@"Apperception"];
    }
    if (self.string8.length!=0) {
        [dict setValue:self.string4 forKey:@"MorgenPlan"];
    }else
    {
        [dict setValue:@"" forKey:@"MorgenPlan"];
    }
    if (self.string9.length!=0) {
        [dict setValue:self.string4 forKey:@"MorgenAim"];
    }else
    {
        [dict setValue:@"" forKey:@"MorgenAim"];
    }
    if (self.summary.length!=0) {
        [dict setValue:self.string4 forKey:@"Summery"];
    }else
    {
        [dict setValue:@"" forKey:@"Summery"];
    }
    if ([button.titleLabel.text isEqualToString:@"选择日期"]) {
        [dict setValue:@"" forKey:@"DateLine"];
    }
    else
    {
        [dict setValue:button.titleLabel.text forKey:@"DateLine"];
    }
    
    [dict setValue:hint forKey:@"Hint"];
    [dict setValue:[USER_DEFAULTS valueForKey:@"name"] forKey:@"Name"];
    
    [ZXDNetworking POST:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
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
    } failure:^(NSError *error) {
        
    } view:self.view];
}

-(void)showAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否要提交此项内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
}

-(void)back
{
    isBack = YES;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"离开后编辑的内容将要消失" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存草稿箱",@"确定" ,nil];
    alertView.tag = 200;
    [alertView show];
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
            if ([button.titleLabel.text isEqualToString:@"选择日期"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请选择日期" andInterval:1.0];
                return;
            }else
            {
                [self submitData:@"3"];
            }
            
        }
        if (buttonIndex==2) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma -mark viewDatePickDelegate
-(void)getDate
{
    NSDate *date = myDatePick.datePick.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringDate = [formatter stringFromDate:date];
    [button setTitle:stringDate forState:UIControlStateNormal];
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellEditPlan *cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellEditPlan alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.LabelTitle.text = arrayTitle[indexPath.row];
    cell.textView.delegate = self;
    switch (indexPath.row) {
        case 0:
            if (self.string1.length!=0) {
                cell.textView.text = self.string1;
            }else
            {
                cell.textView.placeholder = @"填写地区店名老板";
            }
            break;
        case 1:
            if (self.string2.length!=0) {
                cell.textView.text = self.string2;
            }else
            {
                cell.textView.placeholder = @"填写目标";
            }
            break;
        case 2:
            if (self.string3.length!=0) {
                cell.textView.text = self.string3;
            }else
            {
                cell.textView.placeholder = @"填写业绩";
            }
            break;
        case 3:
            if (self.string4.length!=0) {
                cell.textView.text = self.string4;
            }else
            {
                cell.textView.placeholder = @"填写出货";
            }
            break;
        case 4:
            if (self.string5.length!=0) {
                cell.textView.text = self.string5;
            }else
            {
                cell.textView.placeholder = @"填写发现的问题";
            }
            break;
        case 5:
            if (self.string6.length!=0) {
                cell.textView.text = self.string6;
            }else
            {
                cell.textView.placeholder = @"填写解决的方案";
            }
            break;
        case 6:
            if (self.string7.length!=0) {
                cell.textView.text = self.string7;
            }else
            {
                cell.textView.placeholder = @"填写感悟分享";
            }
            break;
        case 7:
            if (self.string8.length!=0) {
                cell.textView.text =self.string8;
            }else
            {
                cell.textView.placeholder = @"填写明日计划";
            }
            break;
        case 8:
            
            if (self.string9.length!=0) {
                cell.textView.text = self.string9;
            }else
            {
                cell.textView.placeholder = @"填写明日目标";
            }
            break;
        case 9:
            if (self.summary.length!=0) {
                cell.textView.text = self.summary;
            }else
            {
                cell.textView.placeholder = @"填写总结";
            }
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma -mark textView
-(void)textViewDidChange:(UITextView *)textView
{
    CellEditPlan *cell = (CellEditPlan *)[textView superview].superview;
    NSIndexPath *indexPath = [tableView1 indexPathForCell:cell];
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
        case 9:
            self.summary = textView.text;
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
    
    [tableView1 beginUpdates];
    [tableView1 endUpdates];
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=  @"填写店报表";
    [self setUI];
    arrayTitle = @[@"地区店名老板",@"目标",@"业绩",@"出货",@"发现问题",@"解决方案",@"感悟分享",@"明日计划",@"明日目标",@"总结"];
    isBack = NO;
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [submit setImage:[UIImage imageNamed:@"up_ico02"] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:submit];
    self.navigationItem.rightBarButtonItem = item;
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
