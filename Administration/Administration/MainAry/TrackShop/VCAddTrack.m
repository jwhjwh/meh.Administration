//
//  VCAddTrack.m
//  Administration
//
//  Created by zhang on 2017/12/5.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCAddTrack.h"
#import "ViewDatePick.h"
#import "CellTrack1.h"
#import "CellTrack2.h"
#import "VCChooseShop.h"
@interface VCAddTrack ()<UITableViewDelegate,UITableViewDataSource,ViewDatePickerDelegate,UITextViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)ViewDatePick *datePick;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSArray *arrayPlacehold;

@property (nonatomic,strong)NSString *stringDate;
@property (nonatomic,strong)NSString *stringPerson;
@property (nonatomic,strong)NSString *shopName;
@property (nonatomic,strong)NSString *string1;
@property (nonatomic,strong)NSString *string2;
@property (nonatomic,strong)NSString *string3;
@property (nonatomic,strong)NSString *string4;
@end

@implementation VCAddTrack

#pragma -mark custem

-(void)submitDate
{
    NSString *urlStr =[NSString stringWithFormat:@"%@tracking/insertStoreTracking.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    if (self.stringDate.length==0||self.string1.length==0||self.string2.length==0||self.string3.length==0||self.string4.length==0) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写完整内容" andInterval:1.0];
        return;
    }
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Times":self.stringDate,
                           @"StoreId": [NSString stringWithFormat:@"%@",[ShareModel shareModel].dictShop[@"id"]],
                           @"UsersName":[USER_DEFAULTS valueForKey:@"name"],
                           @"Content":self.string1,
                           @"Proposal":self.string2,
                           @"Sales":self.string3,
                           @"Summary":self.string4,
                           @"CompanyInfoId":compid,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"RoleId":[ShareModel shareModel].roleID
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

-(void)showDatePick
{
    ViewDatePick *datePick = [[ViewDatePick alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    datePick.delegate = self;
    [self.view addSubview:datePick];
    self.datePick = datePick;
}

-(void)gotoChooseShop
{
    VCChooseShop *vc = [[VCChooseShop alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setUI
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitDate) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
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
        cell.textView.placeholder = self.arrayPlacehold[indexPath.row];
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
            
        }
        
        if (indexPath.row==1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textView.editable = NO;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoChooseShop)];
            [cell.textView addGestureRecognizer:tap];
            cell.textView.text = self.shopName;
            
        }
        if (indexPath.row==2) {
            cell.textView.text = [USER_DEFAULTS valueForKey:@"name"];
            cell.textView.editable = NO;
        }
        
        
        return cell;
    }else
    {
        CellTrack2 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell = [[CellTrack2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell.labelTitle.text = self.arrayTitle[indexPath.row];
        cell.textView.placeholder = self.arrayPlacehold[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.delegate = self;
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
    self.shopName = [ShareModel shareModel].dictShop[@"storeName"];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加店家跟踪";
    
    self.string1 = @"";
    self.string2 = @"";
    self.string3 = @"";
    self.string4 = @"";
    self.stringPerson = @"";
    self.stringDate = @"";
    self.shopName = @"";
    
    self.arrayTitle = @[@"日期",@"店家",@"执行人",@"主要内容",@"遇到问题及建议",@"销售额（万元）",@"总结结论"];
    self.arrayPlacehold = @[@"选择日期",@"选择店家",@"填写执行人",@"填写主要内容",@"填写遇到问题及建议",@"填写销售额",@"填写总结结论"];
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
