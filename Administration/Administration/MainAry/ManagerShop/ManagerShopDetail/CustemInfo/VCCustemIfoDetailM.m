//
//  VCPersonInfoDetail.m
//  Administration
//
//  Created by zhang on 2017/12/8.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCCustemIfoDetailM.h"
#import "CellTrack1.h"
#import "VCSpecialityManager.h"
#import "VCAddBrithday.h"
#import "VCBrithdayDetail.h"
#import "UIViewDatePicker.h"
@interface VCCustemIfoDetailM ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIViewDatePickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)NSMutableDictionary *dictInfo;
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UIViewDatePicker *datePick;
@property (nonatomic)BOOL canEdit;

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *age;
@property (nonatomic,strong)NSString *flag;
@property (nonatomic,strong)NSString *brithdayChinese;
@property (nonatomic,strong)NSString *brithdayGer;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *qq;
@property (nonatomic,strong)NSString *wx;
@property (nonatomic,strong)NSString *hobby;
@property (nonatomic,strong)NSString *character;
@property (nonatomic,strong)NSString *brand;
@end

@implementation VCCustemIfoDetailM
#pragma -mark custem
-(void)setUI
{
    
    UIBarButtonItem *rightItem;
    if (self.isAddInfo) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [button setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
        rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
       
    }else
    {
        rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightItem)];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    }
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

-(void)rightItem
{
    if (self.isAddInfo) {
        [self submitData];
    }else
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [button setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.canEdit = YES;
        [self.tableView reloadData];
    }
}

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@stores/selectstore.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Storeid":[ShareModel shareModel].shopID,
                           @"store":@"4",
                           @"StoreCustomerId":self.personID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            NSDictionary *dict = [responseObject valueForKey:@"list"][0];
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
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
                [self.dictInfo setObject:obj forKey:key];
            }];
            
            self.name = self.dictInfo[@"name"];
            self.age = self.dictInfo[@"age"];
            self.flag = self.dictInfo[@"flag"];
            self.brithdayChinese = self.dictInfo[@"lunarBirthday"];
            self.brithdayGer = self.dictInfo[@"solarBirthday"];
            self.phone = self.dictInfo[@"phone"];
            self.qq = self.dictInfo[@"qcode"];
            self.wx = self.dictInfo[@"wcode"];
            self.hobby = self.dictInfo[@"hobbies"];
            self.character = self.dictInfo[@"personality"];
            self.brand = self.dictInfo[@"salesBrand"];
            
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0f];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)submitData
{
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSString *urlStr;
    
    NSMutableArray *arrayKeys = [NSMutableArray arrayWithObjects:@"appkey",@"usersid",@"Storeid",@"Name",@"Age",@"SolarBirthday",@"LunarBirthday",@"flag",@"Phone",@"QCode",@"WCode",@"Hobbies",@"Personality",@"SalesBrand",@"CustomerHealth",@"OngoingItem",@"Heedful",@"Consumption",@"store", nil] ;
    
    NSMutableArray *arrayValues = [NSMutableArray arrayWithObjects:appKeyStr,[USER_DEFAULTS valueForKey:@"userid"],[ShareModel shareModel].shopID,self.name,self.age,self.brithdayGer,self.brithdayChinese,self.flag,self.phone,self.qq,self.wx,self.hobby,self.character,self.brand,[ShareModel shareModel].jiankeng,[ShareModel shareModel].zaizuo,[ShareModel shareModel].teshu,[ShareModel shareModel].xiaofei,@"4", nil];
    
    NSRange range = NSMakeRange(arrayKeys.count, 2);
    
    if (self.personID) {
        urlStr = [NSString stringWithFormat:@"%@shop/updateStoreCustomer1.action",KURLHeader];
       
        [arrayKeys insertObjects:@[@"RoleId",@"id"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        [arrayValues insertObjects:@[[ShareModel shareModel].roleID,self.personID] atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        
    }
    else
    {
        urlStr = [NSString stringWithFormat:@"%@shop/ insertStoreCustomer.action",KURLHeader];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:arrayValues forKeys:arrayKeys];
    
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

-(void)gotoAddBrithay
{
    if ([self.dictInfo[@"remind"]intValue] ==0) {
        VCAddBrithday *vc = [[VCAddBrithday alloc]init];
        vc.dictInfo = self.dictInfo;
        
        
        if ([self.dictInfo[@"solarBirthday"]isKindOfClass:[NSNull class]]&&[self.dictInfo[@"lunarBirthday"]isKindOfClass:[NSNull class]]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无生日" andInterval:1.0];
            return;
        }else
        {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else
    {
        VCBrithdayDetail *vc = [[VCBrithdayDetail alloc]init];
        vc.remind = [NSString stringWithFormat:@"%@",self.dictInfo[@"remind"]];
        vc.dictInfo = self.dictInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)showDatePick
{
    [self.view endEditing:YES];
    UIViewDatePicker *datePick = [[UIViewDatePicker alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    datePick.delegate = self;
    [self.view addSubview:datePick];
    self.datePick = datePick;
}

#pragma -mark alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
    if (buttonIndex==0) {
        imagePick.delegate = self;
        [self.navigationController presentViewController:imagePick animated:YES completion:nil];
    }else
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"设备不支持" andInterval:1.0];
            return;
        }else
        {
            imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
}
#pragma -mark UIViewDatePicker
-(void)getChooseDate
{
    self.flag = self.datePick.flagggg;
    self.brithdayChinese = self.datePick.stringChinese;
    self.brithdayGer = self.datePick.stringGregorian;
}


#pragma -mark textView
-(void)textViewDidChange:(UITextView *)textView
{
    
    CellTrack1 *cell = (CellTrack1 *)[textView superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }
    
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                self.name = textView.text;
                break;
            case 1:
                self.age = textView.text;
                break;
                
            default:
                break;
        }
    }else if (indexPath.section==1)
    {
        switch (indexPath.row) {
            case 0:
                self.phone = textView.text;
                
                break;
            
            case 2:
                self.qq = textView.text;
                break;
                
            case 3:
                self.wx = textView.text;
                break;
                
            case 4:
                self.hobby = textView.text;
                break;
                
            case 5:
                self.character = textView.text;
                break;
                
            case 6:
                self.brand = textView.text;
                break;
            default:
                break;
        }
    }
    
    
    cell.textView.frame = CGRectMake(frame.origin.x, frame.origin.y,cell.contentView.frame.size.width, size.height);
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
}

#pragma -mark tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayTitle.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayTitle[section]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellTrack1 *cell = [[CellTrack1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellTrack1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textView.scrollEnabled = NO;
    cell.labelTitle.text = self.arrayTitle[indexPath.section][indexPath.row];
    cell.textView.delegate = self;
    
    if (self.isAddInfo) {
        cell.userInteractionEnabled = YES;
    }else
    {
    if (self.canEdit ) {
        cell.userInteractionEnabled = YES;
    }else
    {
        cell.userInteractionEnabled = NO;
    }
    }
    
    if (indexPath.section==2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = YES;
        [cell.textView removeFromSuperview];
    }
    
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                cell.textView.text = self.name;
                break;
            case 1:
                cell.textView.text = self.age;
                break;
                
            default:
                break;
        }
    }else if (indexPath.section==1)
    {
        switch (indexPath.row) {
            case 0:
                cell.textView.text = self.phone;
               
                break;
            case 1:
            {
                if ([self.flag isEqualToString:@"1"]) {
                    cell.textView.text = self.brithdayChinese;
                }else
                {
                    cell.textView.text = self.brithdayGer;
                }
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePick)];
                cell.textView.editable = NO;
                [cell.textView addGestureRecognizer:tap];
                
                if (self.isAddInfo==NO) {
                    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-10, 15, 40, 20)];
                    [button setTitle:@"提醒" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(gotoAddBrithay) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:button];
                    
                    if (![self.dictInfo[@"remind"]isEqualToString:@"0"]) {
                        [button setTitleColor:GetColor(229, 126, 0, 1) forState:UIControlStateNormal];
                    }
                }
                
        }
                break;
            case 2:
                cell.textView.text = self.qq;
                break;

            case 3:
                cell.textView.text = self.wx;
                break;

            case 4:
                cell.textView.text = self.hobby;
                break;

            case 5:
                cell.textView.text = self.character;
                break;

            case 6:
                cell.textView.text = self.brand;
                break;

                
            default:
                break;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        VCSpecialityManager *vc = [[VCSpecialityManager alloc]init];
        vc.stringTitle = self.arrayTitle[indexPath.section][indexPath.row];
        [ShareModel shareModel].showRightItem = self.canEdit;
        switch (indexPath.row) {
            case 0:
                vc.content = self.dictInfo[@"customerHealth"];
                vc.state = @"1";
                break;
            case 1:
                vc.content = self.dictInfo[@"ongoingItem"];
                vc.state = @"2";
                break;
            case 2:
                vc.content = self.dictInfo[@"heedful"];
                vc.state = @"3";
                break;
            case 3:
                vc.content = self.dictInfo[@"consumption"];
                vc.state = @"4";
                break;
                
            default:
                break;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

#pragma -mark system

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"顾客信息";
    self.dictInfo = [NSMutableDictionary dictionary];
    self.arrayTitle = @[@[@"姓名",@"年龄"],@[@"电话",@"生日",@"QQ",@"微信",@"爱好",@"性格",@"所做品牌"],@[@"顾客身体情况简介",@"正在做的项目",@"特殊注意说明",
//                                                                                        @"经营状况",@"常到顾客",@"拓客计划",
                                                                                        @"消费分析"]];
    [self setUI];

    if (self.isAddInfo==NO) {
        [self getHttpData];
    }
    
    self.canEdit = NO;
    
    self.name = @"";
    self.age = @"";
    self.flag = @"";
    self.brithdayChinese = @"";
    self.brithdayGer = @"";
    self.phone = @"";
    self.qq = @"";
    self.wx = @"";
    self.hobby = @"";
    self.character = @"";
    self.brand = @"";
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
