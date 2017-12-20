//
//  TrackAddMajordomo.m
//  Administration
//
//  Created by zhang on 2017/12/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TrackAddMajordomo.h"
#import "ViewDatePick.h"
#import "CellTrack2.h"
#import "TrackAddArea.h"
@interface TrackAddMajordomo ()<ViewDatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSString *startDate;
@property (nonatomic,strong)NSString *endDate;
@property (nonatomic,strong)NSString *string1;
@property (nonatomic,strong)NSString *string2;
@property (nonatomic,strong)NSString *string3;
@property (nonatomic,strong)NSString *string4;
@property (nonatomic,strong)NSString *string5;
@property (nonatomic,strong)NSString *string6;
@property (nonatomic,strong)NSString *string7;
@property (nonatomic,strong)NSString *string8;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSArray *arrayPlace;
@property (nonatomic,assign)NSUInteger buttonTag;
@property (nonatomic,weak)UIButton *buttonStart;
@property (nonatomic,weak)UIButton *buttonEnd;
@property (nonatomic,weak)ViewDatePick *datePick;
@end

@implementation TrackAddMajordomo

-(void)setUI
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitDate) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 45)];
    viewTop.backgroundColor = GetColor(234, 235, 236, 1);
    [self.view addSubview:viewTop];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"  日期";
    [viewTop addSubview:label];
    
    UIButton *buttonStart = [[UIButton alloc]initWithFrame:CGRectMake(80, 0, 120, 44)];
    buttonStart.tag = 10;
    [buttonStart setBackgroundColor:[UIColor whiteColor]];
    [buttonStart setTitle:@"选择开始日期" forState:UIControlStateNormal];
    [buttonStart setTitleColor:GetColor(234, 235, 236, 1) forState:UIControlStateNormal];
    [buttonStart addTarget:self action:@selector(showDatePick:) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:buttonStart];
    self.buttonStart = buttonStart;
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 20, 44)];
    label2.text = @"至";
    label2.backgroundColor = [UIColor whiteColor];
    [viewTop addSubview:label2];
    
    UIButton *buttonEnd = [[UIButton alloc]initWithFrame:CGRectMake(220, 0, 170, 44)];
    buttonEnd.tag = 20;
    [buttonEnd setBackgroundColor:[UIColor whiteColor]];
    [buttonEnd setTitle:@"选择结束日期" forState:UIControlStateNormal];
    [buttonEnd setTitleColor:GetColor(234, 235, 236, 1) forState:UIControlStateNormal];
    [buttonEnd addTarget:self action:@selector(showDatePick:) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:buttonEnd];
    self.buttonEnd = buttonEnd;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    tableView.tableHeaderView = viewTop;
    [tableView registerClass:[CellTrack2 class] forCellReuseIdentifier:@"cell1"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


-(void)submitDate
{
    NSString *urlStr =[NSString stringWithFormat:@"%@tracking/insertDMStoreTracking.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[ShareModel shareModel].arrayArea
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    
    if (
        [self.startDate isEqualToString:@"选择开始日期"]||
        [self.endDate isEqualToString:@"选择结束日期"]||
        [ShareModel shareModel].arrayArea.count==0||
        [self.string1 isEqualToString:@""]||
        [self.string2 isEqualToString:@""]||
        [self.string3 isEqualToString:@""]||
        [self.string4 isEqualToString:@""]||
        [self.string5 isEqualToString:@""]||
        [self.string6 isEqualToString:@""]||
        [self.string7 isEqualToString:@""]||
        [self.string8 isEqualToString:@""]) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1.0f];
        return;
    }
    
    NSMutableArray *arrayName = [NSMutableArray array];
    for (NSDictionary *dictionary in [ShareModel shareModel].arrayData) {
        [arrayName addObject:dictionary[@"name"]];
    }
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Starttime":self.startDate,
                           @"Endtime":self.endDate,
                           @"UsersName":self.string1,
                           @"Executivebrand":self.string2,
                           @"TimePlanning":self.string3,
                           @"ExpectedTime":self.string4,
                           @"Question":self.string5,
                           @"Performance":self.string6,
                           @"Special":self.string7,
                           @"Summary":self.string8,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"CompanyInfoId":compid,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"string":string
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)showDatePick:(UIButton *)button
{
    ViewDatePick *datePick = [[ViewDatePick alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    datePick.delegate = self;
    [self.view endEditing:YES];
    self.buttonTag = button.tag;
    [self.view addSubview:datePick];
    self.datePick = datePick;
}

#pragma -mark viewdatePick

-(void)getDate
{
    NSDate *date = self.datePick.datePick.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringDate = [formatter stringFromDate:date];
    if (self.buttonTag==10) {
        self.startDate = stringDate;
        [self.buttonStart setTitle:stringDate forState:UIControlStateNormal];
    }else
    {
        self.endDate = stringDate;
        [self.buttonEnd setTitle:stringDate forState:UIControlStateNormal];
    }
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.arrayTitle[indexPath.row];
        return cell;
    }else
    {
        CellTrack2 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[CellTrack2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.delegate = self;
        cell.labelTitle.text = self.arrayTitle[indexPath.row];
        cell.textView.placeholder = self.arrayPlace[indexPath.row];
        
        switch (indexPath.row) {
            case 0:
                cell.textView.text = self.string1;
                break;
            case 1:
                cell.textView.text = self.string2;
                break;
            case 3:
                cell.textView.text = self.string3;
                break;
            case 4:
                cell.textView.text = self.string4;
                break;
            case 5:
                cell.textView.text = self.string5;
                break;
            case 6:
                cell.textView.text = self.string6;
                break;
            case 7:
                cell.textView.text = self.string7;
                break;
            case 8:
                cell.textView.text = self.string8;
                break;
                
            default:
                break;
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        TrackAddArea *vc = [[TrackAddArea alloc]init];
        vc.showRightItem = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma -mark textView

-(void)textViewDidChange:(UITextView *)textView
{
    CellTrack2 *cell = (CellTrack2 *)[textView superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 0:
            self.string1 = textView.text;
            break;
        case 1:
            self.string2 = textView.text;
            break;
        case 3:
            self.string3 = textView.text;
            break;
        case 4:
            self.string4 = textView.text;
            break;
        case 5:
            self.string5 = textView.text;
            break;
        case 6:
            self.string6 = textView.text;
            break;
        case 7:
            self.string7 = textView.text;
            break;
        case 8:
            self.string8= textView.text;
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
    self.title = @"添加店家跟踪";
    [self setUI];
    
    self.startDate = @"选择开始日期";
    self.endDate = @"选择开始日期";
    self.string1 = @"";
    self.string2 = @"";
    self.string3 = @"";
    self.string4 = @"";
    self.string5 = @"";
    self.string6 = @"";
    self.string7 = @"";
    self.string8 = @"";
    self.arrayTitle = @[@"执行人",@"执行品牌",@"执行区域",@"具体的事件规划",@"预期达成的时间",@"可能遇到的问题与困难",@"销售业绩",@"特殊情况",@"总结结论"];
    self.arrayPlace = @[@"填写执行人",@"填写执行品牌",@"",@"填写具体的事件规划",@"填写预期达成的时间",@"填写可能遇到的问题与困难",@"填写销售业绩",@"填写特殊情况",@"填写总结结论"];
    
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
