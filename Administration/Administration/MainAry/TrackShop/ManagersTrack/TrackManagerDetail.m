//
//  TrackManagerDetail.m
//  Administration
//
//  Created by zhang on 2017/12/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TrackManagerDetail.h"
#import "CellTrack2.h"
#import "ViewDatePick.h"
#import "TrackAddArea.h"
#import "TrackSelectShop.h"
@interface TrackManagerDetail ()<UITableViewDataSource,UITableViewDelegate,ViewDatePickerDelegate,UITextViewDelegate>
@property (nonatomic,strong)NSString *string1;
@property (nonatomic,strong)NSString *string2;
@property (nonatomic,strong)NSString *string3;
@property (nonatomic,strong)NSString *string4;
@property (nonatomic,strong)NSString *string5;
@property (nonatomic,strong)NSString *string6;
@property (nonatomic,strong)NSString *startDate;
@property (nonatomic,strong)NSString *endDate;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSArray *arrayPlace;
@property (nonatomic,assign)NSUInteger buttonTag;

@property (nonatomic,weak)UIButton *buttonStart;
@property (nonatomic,weak)UIButton *buttonEnd;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)ViewDatePick *datePick;
@property (nonatomic,weak)UITextField *textF;
@property (nonatomic,weak)UIView *viewTop;
@property (nonatomic)BOOL canEdit;
@end

@implementation TrackManagerDetail
-(void)setUI
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editTrack)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 135)];
    viewTop.backgroundColor = GetColor(234, 235, 236, 1);
    viewTop.userInteractionEnabled = NO;
    [self.view addSubview:viewTop];
    self.viewTop = viewTop;
    
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
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, Scree_width, 44)];
    label3.text = @"  执行人";
    label3.backgroundColor = [UIColor whiteColor];
    [viewTop addSubview:label3];
    
    UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(0, 89, Scree_width, 44)];
    textF.placeholder = @"  填写执行人";
    textF.backgroundColor = [UIColor whiteColor];
    [viewTop addSubview:textF];
    self.textF = textF;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = viewTop;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    [tableView registerClass:[CellTrack2 class] forCellReuseIdentifier:@"cell1"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(void)editTrack
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitDate) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.viewTop.userInteractionEnabled = YES;
    self.canEdit = YES;
    [self.tableView reloadData];
    
}

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@tracking/selectStoreTrackingid.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"id":self.TrackID,
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            NSDictionary *dictinfo = [responseObject valueForKey:@"dmstoreTracking"];
            
            NSMutableDictionary *dictTrack = [NSMutableDictionary dictionary];
            [dictinfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    if ([obj isKindOfClass:[NSNumber class]]) {
                        obj = [NSString stringWithFormat:@"%@",obj];
                    }else
                    {
                        obj = @"";
                    }
                }else
                {
                    obj = [NSString stringWithFormat:@"%@",obj];
                }
                [dictTrack setObject:obj forKey:key];
            }];
            
            self.string1 = dictTrack[@"timePlanning"];
            self.string2 = dictTrack[@"expectedTime"];
            self.string3 = dictTrack[@"question"];
            self.string4 = dictTrack[@"performance"];
            self.string5 = dictTrack[@"special"];
            self.string6 = dictTrack[@"summary"];
            
            
            
            NSData *jsonData = [dictTrack[@"address"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError *err;
            
            [ShareModel shareModel].arrayArea = [NSJSONSerialization JSONObjectWithData:jsonData
                                 
                                                                options:NSJSONReadingMutableContainers
                                 
                                                                  error:&err];
            
            [ShareModel shareModel].arrayData = [[dictTrack[@"storeId"] componentsSeparatedByString:@","]mutableCopy];
            
            [self.buttonStart setTitle:[dictTrack[@"starttime"] substringToIndex:10] forState:UIControlStateNormal];
            [self.buttonEnd setTitle:[dictTrack[@"endtime"] substringToIndex:10] forState:UIControlStateNormal];
            self.textF.text = dictinfo[@"usersName"];
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)submitDate
{
    NSString *urlStr =[NSString stringWithFormat:@"%@tracking/updateDMStoreTracking.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[ShareModel shareModel].arrayArea
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    
    if ([self.buttonStart.titleLabel.text isEqualToString:@"选择开始日期"]||
        [self.buttonEnd.titleLabel.text isEqualToString:@"选择结束日期"]||
        self.textF.text.length==0||
        [ShareModel shareModel].arrayArea.count==0||
        [ShareModel shareModel].arrayData.count==0||
        [self.string1 isEqualToString:@""]||
        [self.string2 isEqualToString:@""]||
        [self.string3 isEqualToString:@""]||
        [self.string4 isEqualToString:@""]||
        [self.string5 isEqualToString:@""]||
        [self.string6 isEqualToString:@""]) {
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
                           @"Starttime":self.buttonStart.titleLabel.text,
                           @"Endtime":self.buttonEnd.titleLabel.text,
                           @"UsersName":self.textF.text,
                           @"StoreId":[arrayName componentsJoinedByString:@","],
                           @"TimePlanning":self.string1,
                           @"ExpectedTime":self.string2,
                           @"Question":self.string3,
                           @"Performance":self.string4,
                           @"Special":self.string5,
                           @"Summary":self.string6,
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
        [self.buttonStart setTitle:stringDate forState:UIControlStateNormal];
    }else
    {
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
    if (indexPath.row<2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = self.arrayTitle[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (self.canEdit) {
            cell.userInteractionEnabled = YES;
        }else
        {
            cell.userInteractionEnabled = NO;
        }
        
        return cell;
    }else
    {
        CellTrack2 *cell = [[CellTrack2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        if (!cell) {
            cell = [[CellTrack2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.labelTitle.text = self.arrayTitle[indexPath.row];
        cell.textView.placeholder = self.arrayPlace[indexPath.row];
        cell.textView.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.canEdit) {
            cell.userInteractionEnabled = YES;
        }else
        {
            cell.userInteractionEnabled = NO;
        }
        switch (indexPath.row) {
            case 2:
                cell.textView.text = self.string1;
                break;
            case 3:
                cell.textView.text = self.string2;
                break;
            case 4:
                cell.textView.text = self.string3;
                break;
            case 5:
                cell.textView.text = self.string4;
                break;
            case 6:
                cell.textView.text = self.string5;
                break;
            case 7:
                cell.textView.text = self.string6;
                break;
                
            default:
                break;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        TrackAddArea *vc = [[TrackAddArea alloc]init];
        vc.showRightItem = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==1) {
        if ([ShareModel shareModel].arrayArea.count==0) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无区域" andInterval:1.0];
            return;
        }else
        {
            TrackSelectShop *vc = [[TrackSelectShop alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma -mark textView

-(void)textViewDidChange:(UITextView *)textView
{
    CellTrack2 *cell = (CellTrack2 *)[textView superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 2:
            self.string1 = textView.text;
            break;
        case 3:
            self.string2 = textView.text;
            break;
        case 4:
            self.string3 = textView.text;
            break;
        case 5:
            self.string4 = textView.text;
            break;
        case 6:
            self.string5 = textView.text;
            break;
        case 7:
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
#pragma -mark system

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加店家";
    [self setUI];
    [self getHttpData];
    self.arrayTitle = @[@"执行区域",@"执行店家",@"具体的时间规划",@"预期达成的时间",@"可能遇到的问题与困难",@"销售业绩",@"特殊情况",@"总结结论"];
    self.arrayPlace = @[@"",@"",@"填写具体的时间规划",@"填写预期达成的时间",@"填写可能遇到的问题与困难",@"填写销售业绩",@"填写特殊情况",@"填写总结结论"];
    self.string1 = @"";
    self.string2 = @"";
    self.string3 = @"";
    self.string4 = @"";
    self.string5 = @"";
    self.string6 = @"";
    self.canEdit = NO;
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
