//
//  VCShopInfo.m
//  Administration
//
//  Created by zhang on 2017/12/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCShopInfo.h"
#import "CellShopInfo.h"
#import "VCActive.h"
#import "VCProblem.h"
@interface VCShopInfo ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray *arrayTitle;
@property (nonatomic,strong)NSMutableDictionary *dictInfo;

@property (nonatomic,weak)UITableView *tableView;
@end

@implementation VCShopInfo

#pragma -mark custem

-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@stores/selectstore.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"Storeid":self.shopID,
                           @"store":@"1"
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
-(void)setUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 44; //初始值应尽量设置准确，否则会出问题
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:[CellShopInfo class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseident = @"cell";
    CellShopInfo *cell = [tableView dequeueReusableCellWithIdentifier:reuseident];
    if (!cell) {
        cell = [[CellShopInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseident];
    }
    
    cell.labelTitle.text = self.arrayTitle[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row>9) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.labelContent.text = self.dictInfo[@"storeName"];
            break;
        case 1:
            cell.labelContent.text = [NSString stringWithFormat:@"%@%@%@%@",self.dictInfo[@"province"],self.dictInfo[@"city"],self.dictInfo[@"county"],self.dictInfo[@"address"]];
            break;
        case 2:
            cell.labelContent.text = self.dictInfo[@"rideInfo"];
            break;
        case 3:
            cell.labelContent.text = self.dictInfo[@"area"];
            break;
        case 4:
            cell.labelContent.text = self.dictInfo[@"brandBusiness"];
            break;
        case 5:
            cell.labelContent.text = self.dictInfo[@"intentionBrand"];
            break;
        case 6:
            cell.labelContent.text = self.dictInfo[@"berths"];
            break;
        case 7:
            cell.labelContent.text = self.dictInfo[@"validNumber"];
            break;
        case 8:
            cell.labelContent.text = self.dictInfo[@"staffNumber"];
            break;
        case 9:
            cell.labelContent.text = self.dictInfo[@"jobExpires"];
            break;
        case 10:
            cell.labelContent.text = self.dictInfo[@"problems"];
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==10) {
        VCProblem *vc = [[VCProblem alloc]init];
        vc.Content = self.dictInfo[@"problems"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==11) {
        VCActive *vc = [[VCActive alloc]init];
        vc.shopID = self.shopID;
        [self.navigationController pushViewController:vc animated:YES];
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
    
    self.arrayTitle = @[@"店名",@"门店地址",@"乘车信息",@"面积",@"其他经营品牌",@"意向品牌",@"床位数",@"有效顾客数量",@"员工人数",@"员工从业年限",@"存在优势及问题",@"活动概要"];
    self.dictInfo = [NSMutableDictionary dictionary];
    [self setUI];
    [self getHttpData];
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
