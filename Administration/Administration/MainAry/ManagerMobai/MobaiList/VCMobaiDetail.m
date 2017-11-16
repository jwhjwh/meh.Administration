//
//  VCMobaiDetail.m
//  Administration
//
//  Created by zhang on 2017/11/10.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCMobaiDetail.h"
#import "CellMobaiDetail.h"
#import "VCMobaiShopDetail.h"
#import "VCMobaiRemark.h"
@interface VCMobaiDetail ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSDictionary *dictInfo;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong) NSArray *arrayTitle;
@property (nonatomic,strong) NSMutableArray *arrayContent;

@end

@implementation VCMobaiDetail

#pragma -mark custem

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/selectWorshipRecords.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"RoleIds":[ShareModel shareModel].roleID,
                           @"WorshipRecordId":self.mobaiID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            NSArray *array = [responseObject valueForKey:@"recordInfo"];
            self.dictInfo = array[0];
            
            [self.arrayContent insertObject:[self.dictInfo[@"dates"] substringToIndex:10] atIndex:0];
            if (![self.dictInfo[@"usersName"] isKindOfClass:[NSNull class]]) {
                [self.arrayContent insertObject:self.dictInfo[@"usersName"] atIndex:self.arrayContent.count];
            }else
            {
                [self.arrayContent insertObject:@"   " atIndex:self.arrayContent.count];
            }
            [self.arrayContent insertObject:@"   " atIndex:self.arrayContent.count];
            if (![self.dictInfo[@"storeName"] isKindOfClass:[NSNull class]]) {
                [self.arrayContent insertObject:self.dictInfo[@"storeName"] atIndex:self.arrayContent.count];
            }else
            {
                [self.arrayContent insertObject:@"   " atIndex:self.arrayContent.count];
            }
            if (![self.dictInfo[@"address"] isKindOfClass:[NSNull class]]) {
                [self.arrayContent insertObject:self.dictInfo[@"address"] atIndex:self.arrayContent.count];
            }else
            {
                [self.arrayContent insertObject:@"   " atIndex:self.arrayContent.count];
            }
            if (![self.dictInfo[@"shopName"] isKindOfClass:[NSNull class]]) {
                [self.arrayContent insertObject:self.dictInfo[@"shopName"] atIndex:self.arrayContent.count];
            }else
            {
                [self.arrayContent insertObject:@"   " atIndex:self.arrayContent.count];
            }
            if (![self.dictInfo[@"iphone"] isKindOfClass:[NSNull class]]) {
                [self.arrayContent insertObject:self.dictInfo[@"iphone"] atIndex:self.arrayContent.count];
            }else
            {
                [self.arrayContent insertObject:@"   " atIndex:self.arrayContent.count];
            }
            
            if (![self.dictInfo[@"wcode"] isKindOfClass:[NSNull class]]) {
                [self.arrayContent insertObject:self.dictInfo[@"wcode"] atIndex:self.arrayContent.count];
            }else
            {
                [self.arrayContent insertObject:@"   " atIndex:self.arrayContent.count];
            }
            [self.arrayContent insertObject:@" " atIndex:self.arrayContent.count];
            if (![self.dictInfo[@"storeLevel"] isKindOfClass:[NSNull class]]) {
                [self.arrayContent insertObject:self.dictInfo[@"storeLevel"] atIndex:self.arrayContent.count];
            }else
            {
                [self.arrayContent insertObject:@"   " atIndex:self.arrayContent.count];
            }
            [self.arrayContent insertObject:@"   " atIndex:self.arrayContent.count];
            [self.arrayContent insertObject:@"   " atIndex:self.arrayContent.count];
            [self.arrayContent insertObject:@"   " atIndex:self.arrayContent.count];
            [self.arrayContent insertObject:@"   " atIndex:self.arrayContent.count];
            
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
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)deleteMobai
{
    NSString *urlStr =[NSString stringWithFormat:@"%@shop/deleteShop.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Types":@"1",
                           @"shopId":@"239",
                           @"Draft":@"3",
                           @"id":@"231"
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
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
        if ([code isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"失败" andInterval:1.0];
            return;
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[CellMobaiDetail class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayContent.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellMobaiDetail *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellMobaiDetail alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.labelTitle.text = self.arrayTitle[indexPath.row];
    cell.labelContent.text=  self.arrayContent[indexPath.row];
    
    if (indexPath.row==2||indexPath.row==8||indexPath.row>9) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==10) {
        VCMobaiShopDetail *vc = [[VCMobaiShopDetail alloc]init];
        vc.stringType = self.dictInfo[@"storeType"];
        vc.stringLimit = [NSString stringWithFormat:@"%@",self.dictInfo[@"plantingDuration"]];
        vc.stringPerson = [NSString stringWithFormat:@"%@",self.dictInfo[@"beauticianNU"]];
        vc.stringBed = [NSString stringWithFormat:@"%@",self.dictInfo[@"berths"]];
        vc.stringTitle = self.arrayTitle[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
       
        if (indexPath.row==2) {
            VCMobaiRemark *vc = [[VCMobaiRemark alloc]init];
            vc.stringTitle = self.arrayTitle[indexPath.row];
            vc.string = [NSString stringWithFormat:@"%@%@%@",self.dictInfo[@"province"],self.dictInfo[@"city"],self.dictInfo[@"county"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==8) {
            VCMobaiRemark *vc = [[VCMobaiRemark alloc]init];
            vc.stringTitle = self.arrayTitle[indexPath.row];
            vc.string = self.dictInfo[@"brandBusiness"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==11) {
            VCMobaiRemark *vc = [[VCMobaiRemark alloc]init];
            vc.stringTitle = self.arrayTitle[indexPath.row];
            vc.string = self.dictInfo[@"projectBrief"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==12) {
            VCMobaiRemark *vc = [[VCMobaiRemark alloc]init];
            vc.stringTitle = self.arrayTitle[indexPath.row];
             vc.string = self.dictInfo[@"meetingTime"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==13) {
            VCMobaiRemark *vc = [[VCMobaiRemark alloc]init];
            vc.stringTitle = self.arrayTitle[indexPath.row];
             vc.string = self.dictInfo[@"modified"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    
    }
}

#pragma  -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.arrayContent removeAllObjects];
    [self getHttpData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    
    [self setUI];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteMobai)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.dictInfo = [NSDictionary dictionary];
    self.arrayContent = [NSMutableArray array];
    self.arrayTitle = @[@"日期",@"业务人员",@"地区",@"店名",@"店铺地址",@"负责人",@"手机",@"微信",@"主要经营品牌",@"店面评估档次分类",@"店面情况简介",@"关注项目及所需要信息简要",@"会谈气质时间概要说明（必填）",@"备注"];
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