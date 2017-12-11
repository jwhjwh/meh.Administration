//
//  VCEditTrack.m
//  Administration
//
//  Created by zhang on 2017/12/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCEditTrack.h"
#import "ViewDatePick.h"
#import "CellTrack1.h"
#import "CellTrack2.h"
@interface VCEditTrack ()<UITableViewDelegate,UITableViewDataSource,ViewDatePickerDelegate,UITextViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)ViewDatePick *datePick;

@property (nonatomic,strong)NSArray *arrayTitle;

@property (nonatomic,strong)NSString *stringDate;
@property (nonatomic,strong)NSString *stringPerson;
@property (nonatomic,strong)NSString *string1;
@property (nonatomic,strong)NSString *string2;
@property (nonatomic,strong)NSString *string3;
@property (nonatomic,strong)NSString *string4;
@property (nonatomic)BOOL canEdit;
@end

@implementation VCEditTrack

#pragma -mark custem

-(void)submitDate
{
    NSString *urlStr =[NSString stringWithFormat:@"%@tracking/updateStoreTracking.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    if (self.string1.length==0||self.string2.length==0||self.string3.length==0||self.string4.length==0) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1.0];
        return;
    }
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Times":self.stringDate,
                           @"StoreId": self.shopID,
                           @"UsersName":[USER_DEFAULTS valueForKey:@"name"],
                           @"Content":self.string1,
                           @"Proposal":self.string2,
                           @"Sales":self.string3,
                           @"Summary":self.string4,
                           @"CompanyInfoId":compid,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"id":self.trackID
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
                           @"Storeid":self.shopID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"id":self.trackID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            NSDictionary *dictTrack = [responseObject valueForKey:@"storeTracking"];
            self.stringDate = dictTrack[@"times"];
            self.stringPerson = dictTrack[@"UsersName"];
            self.string1 = dictTrack[@"content"];
            self.string2 = dictTrack[@"proposal"];
            self.string3 = [NSString stringWithFormat:@"%@",dictTrack[@"sales"]];
            self.string4 = dictTrack[@"summary"];
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editTrack)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:[CellTrack1 class] forCellReuseIdentifier:@"cell1"];
    [tableView registerClass:[CellTrack2 class] forCellReuseIdentifier:@"cell2"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(void)editTrack
{
    self.canEdit = YES;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitDate) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.canEdit = YES;
    [self.tableView reloadData];
}

-(void)showDatePick
{
    ViewDatePick *datePick = [[ViewDatePick alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    datePick.delegate = self;
    [self.view addSubview:datePick];
    self.datePick = datePick;
}

#pragma -mark datePickDelegate
-(void)getDate
{
    NSDate *date = self.datePick.datePick.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.stringDate = [formatter stringFromDate:date];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma -mark textView

-(void)textViewDidChange:(UITextView *)textView
{
    CellTrack2 *cell = (CellTrack2 *)[textView superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 3:
            self.string1 = textView.text;
            break;
        case 4:
            self.string2 = textView.text;
            break;
        case 5:
            self.string3 = textView.text;
            break;
        case 6:
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
    return self.arrayTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<3) {
        CellTrack1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[CellTrack1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        
        cell.labelTitle.text = self.arrayTitle[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.delegate = self;
        
        if (indexPath.row==0) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePick)];
            [cell.textView addGestureRecognizer:tap];
            cell.textView.editable = NO;
            if (self.stringDate.length!=0) {
                cell.textView.text  = [self.stringDate substringWithRange:NSMakeRange(5, 5)];
            }else
            {
                cell.textView.text = self.stringDate;
            }
            
            if (self.canEdit ) {
                cell.userInteractionEnabled = YES;
            }else
            {
                cell.userInteractionEnabled = NO;
            }
            
        }
        
        if (indexPath.row==1) {
            cell.textView.text = [ShareModel shareModel].storeName;
            cell.userInteractionEnabled = NO;
            
        }
        if (indexPath.row==2) {
            cell.textView.text = [USER_DEFAULTS valueForKey:@"name"];
            cell.userInteractionEnabled = NO;
        }
        
        
        return cell;
    }else
    {
        CellTrack2 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell = [[CellTrack2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell.labelTitle.text = self.arrayTitle[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.delegate = self;
        if (self.canEdit ) {
            cell.userInteractionEnabled = YES;
        }else
        {
            cell.userInteractionEnabled = NO;
        }
        switch (indexPath.row) {
            case 3:
                cell.textView.text= self.string1;
                break;
            case 4:
                cell.textView.text= self.string2;
                break;
            case 5:
                cell.textView.text= self.string3;
                break;
            case 6:
                cell.textView.text= self.string4;
                break;
                
            default:
                break;
        }
        return cell;
    }
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
    
    self.title = @"店家跟踪";
    
    self.canEdit = NO;
    
    self.string1 = @"";
    self.string2 = @"";
    self.string3 = @"";
    self.string4 = @"";
    self.stringPerson = @"";
    self.stringDate = @"";
    
    self.arrayTitle = @[@"日期",@"店家",@"执行人",@"主要内容",@"遇到问题及建议",@"销售额（万元）",@"总结结论"];
    [self setUI];
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
