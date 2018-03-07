//
//  VCShopInfo.m
//  Administration
//
//  Created by zhang on 2017/12/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCShopInfoManager.h"
#import "CellTrack1.h"
#import "VCActiveManager.h"
#import "VCProblemManager.h"
#import "VCShopAddress.h"
#import "UIViewChooseNumber.h"
@interface VCShopInfoManager ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIViewChooseNumberDelegate>
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSMutableDictionary *dictInfo;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)NSArray *arrayChooseTitle;
@property (nonatomic,weak)UIViewChooseNumber *viewChooseNumber;
@property (nonatomic,strong)NSString *string1;
@property (nonatomic,strong)NSString *string3;
@property (nonatomic,strong)NSString *string4;
@property (nonatomic,strong)NSString *string5;
@property (nonatomic,strong)NSString *string6;
@property (nonatomic,strong)NSString *string7;
@property (nonatomic,strong)NSString *string8;
@property (nonatomic,strong)NSString *string9;
@property (nonatomic,strong)NSString *string10;
@property (nonatomic)BOOL canEdit;
@end

@implementation VCShopInfoManager

#pragma -mark custem
      
-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/selectstore.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Storeid":[ShareModel shareModel].shopID,
                           @"store":@"1",
                           @"type":@"2"
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            
            NSDictionary *dictinfo = [responseObject valueForKey:@"list"];
            
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
                
                [self.dictInfo setValue:obj forKey:key];
                
            }];
            
        
            self.string1 = self.dictInfo[@"storeName"];
            self.string3 = self.dictInfo[@"rideInfo"];
            self.string4 = self.dictInfo[@"area"];
            self.string5 = self.dictInfo[@"brandBusiness"];
            self.string6 = self.dictInfo[@"intentionBrand"];
            self.string7 = self.dictInfo[@"berths"];
            self.string8 = self.dictInfo[@"validNumber"];
            self.string9 = self.dictInfo[@"staffNumber"];
            self.string10 = self.dictInfo[@"jobExpires"];

            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)submitData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/updateStore1.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"Storeid":[ShareModel shareModel].shopID,
                           @"StoreName":self.string1,
                           @"Province":[ShareModel shareModel].stringProvince,
                           @"City":[ShareModel shareModel].stringCity,
                           @"County":[ShareModel shareModel].stringCountry,
                           @"Address":[ShareModel shareModel].addressDetil,
                           @"RideInfo":self.string3,
                           @"Area":self.string4,
                           @"BrandBusiness":self.string5,
                           @"IntentionBrand":self.string6,
                           @"Berths":self.string7,
                           @"ValidNumber":self.string8,
                           @"StaffNumber":self.string9,
                           @"JobExpires":self.string10,
                           @"Problems":[ShareModel shareModel].wenti,
                           @"RunStatus":[ShareModel shareModel].jingying,
                           @"Oftencustomers":[ShareModel shareModel].chaodao,
                           @"TooKeenPlan":[ShareModel shareModel].tuoke,
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1.0];
            return;
        }
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)gotoChooseArea
{
    VCShopAddress *vc = [[VCShopAddress alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setUI
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightItem)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 44; //初始值应尽量设置准确，否则会出问题
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:[CellTrack1 class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(void)rightItem
{
    self.canEdit = YES;
    [ShareModel shareModel].showRightItem = YES;
    [self.tableView reloadData];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)showChooseView:(UITapGestureRecognizer *)tapGes
{
    [self.view endEditing:YES];
    
    CGPoint point = [tapGes locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    self.indexPath = indexPath;
    
    BOOL showYear;
    if (indexPath.row!=10) {
        showYear = NO;
    }else
    {
        showYear = YES;
    }
    UIViewChooseNumber *view = [[UIViewChooseNumber alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)Title:self.arrayChooseTitle[indexPath.row-6] ShowYear:showYear];
    view.delegate = self;
    [self.view addSubview:view];
    self.viewChooseNumber = view;
}

#pragma -mark uiviewChooseNumber

-(void)getChoosed:(UIPickerView *)pickView
{
    NSString *string = self.viewChooseNumber.selected;
    switch (self.indexPath.row) {
        case 6:
            self.string7 = string;
            break;
        case 7:
            self.string8 = string;
            break;
        case 8:
            self.string9 = string;
            break;
        case 9:
            self.string10 = string;
            break;
            
        default:
            break;
    }
    [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:NO];
}

#pragma -mark textView
-(void)textViewDidChange:(UITextView *)textView
{
    CellTrack1 *cell = (CellTrack1 *)[textView superview].superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 0:
            self.string1 = textView.text;
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
            
        default:
            break;
    }
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseident = @"cell";
    CellTrack1 *cell = [[CellTrack1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseident];
    if (!cell) {
        cell = [[CellTrack1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseident];
    }
    
    cell.labelTitle.text = self.arrayTitle[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textView.delegate = self;
    if (indexPath.row>9) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textView removeFromSuperview];
    }else
    {
        if (self.canEdit) {
            cell.userInteractionEnabled = YES;
        }
        else
        {
            cell.userInteractionEnabled = NO;
        }
    }
    
    if (indexPath.row>5&&indexPath.row<10) {
        cell.textView.editable = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showChooseView:)];
        [cell.textView addGestureRecognizer:tap];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textView.text = self.string1;
            break;
        case 1:
        {
            cell.textView.text = [NSString stringWithFormat:@"%@%@%@%@",self.dictInfo[@"province"],self.dictInfo[@"city"],self.dictInfo[@"county"],self.dictInfo[@"address"]];
            cell.textView.editable = NO;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoChooseArea)];
            [cell.textView addGestureRecognizer:tap];
        }
            break;
        case 2:
            cell.textView.text = self.string3;
            break;
        case 3:
            cell.textView.text = self.string4;
            break;
        case 4:
            cell.textView.text = self.string5;
            break;
        case 5:
            cell.textView.text = self.string6;
            break;
        case 6:
            cell.textView.text = self.string7;
            break;
        case 7:
            cell.textView.text = self.string8;
            break;
        case 8:
            cell.textView.text = self.string9;
            break;
        case 9:
            cell.textView.text = self.string10;
            break;
            
            default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VCProblemManager *vc = [[VCProblemManager alloc]init];
    
    switch (indexPath.row) {
        case 10:
            vc.Content = self.dictInfo[@"runStatus"];
            vc.state = @"1";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case 11:
            vc.Content = self.dictInfo[@"oftencustomers"];
            vc.state = @"2";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case 12:
            vc.Content = self.dictInfo[@"tooKeenPlan"];
            vc.state = @"3";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case 13:
            vc.Content = self.dictInfo[@"problems"];
            vc.state = @"4";
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case 14:
        {
            VCActiveManager *vc = [[VCActiveManager alloc]init];
            vc.shopID = self.shopID;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
   
    
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"门店信息";
    
    self.arrayTitle = @[@"店名",@"门店地址",@"乘车信息",@"面积",@"其他经营品牌",@"意向品牌",@"床位数",@"有效顾客数量",@"员工人数",@"员工从业年限",@"经营状况",@"常到顾客",@"拓客计划",@"存在优势及问题",@"活动概要"];
    
    self.arrayChooseTitle = @[@"床位数",@"有效顾客数量",@"员工人数",@"员工从业年限"];
    
    self.dictInfo = [NSMutableDictionary dictionary];
    [self setUI];
    [self getHttpData];
    [ShareModel shareModel].showRightItem = NO;
    self.canEdit = NO;
    
    self.string1 = @"";
    self.string3 = @"";
    self.string4 = @"";
    self.string5 = @"";
    self.string6 = @"";
    self.string7 = @"";
    self.string8 = @"";
    self.string9 = @"";
    self.string10 = @"";
    
    [ShareModel shareModel].stringProvince=  @"";
    [ShareModel shareModel].stringCity = @"";
    [ShareModel shareModel].stringCountry = @"";
    [ShareModel shareModel].addressDetil = @"";
    [ShareModel shareModel].wenti = @"";
    [ShareModel shareModel].tuoke = @"";
    [ShareModel shareModel].chaodao = @"";
    [ShareModel shareModel].jingying = @"";
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
