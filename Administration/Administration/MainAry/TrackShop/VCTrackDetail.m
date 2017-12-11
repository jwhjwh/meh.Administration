//
//  VCTrackDetail.m
//  Administration
//
//  Created by zhang on 2017/12/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCTrackDetail.h"
#import "CellTrackShop.h"
#import "VCEditTrack.h"
#import "VCAddTrackDetil.h"
#import "VCShopDetail.h"
@interface VCTrackDetail ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,weak)UILabel *labelTip;
@property (nonatomic,weak)UITableView *tableView;

@end

@implementation VCTrackDetail

#pragma -mark custem
-(void)getHttpData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@tracking/selectStoreTracking.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{
                           @"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"DepartmentId":[ShareModel shareModel].departmentID,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"Storeid":self.storeID
                           };
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.arrayData = [[responseObject valueForKey:@"list"]mutableCopy];
            self.labelTip.hidden = YES;
            [self.tableView reloadData];
            return ;
        }
        
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return;
        }
        
        if ([code isEqualToString:@"5000"]) {
                UILabel *labelTip = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
                labelTip.text = @"暂无内容";
                labelTip.center = self.view.center;
                [self.view addSubview:labelTip];
                self.labelTip = labelTip;
            return;
        }
        
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)gotoShopDetail
{
    VCShopDetail *vc = [[VCShopDetail alloc]init];
    vc.stringTitle = self.stringTitle;
    vc.shopID = self.storeID;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoAddTrackDetil
{
    VCAddTrackDetil *vc = [[VCAddTrackDetil alloc]init];
    vc.storeID = self.storeID;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setUI
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(gotoAddTrackDetil)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, kTopHeight, Scree_width, 25)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button setTitle:@"店家信息" forState:UIControlStateNormal];
    [button setTitleColor:GetColor(167,	117,193,1) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoShopDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(button.frame.size.width-20, 5, 15, 15)];
    imageView.image = [UIImage imageNamed:@"jiantou_03"];
    [button addSubview:imageView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight+25, Scree_width, 50)];
    view.backgroundColor = GetColor(237,238,239,1);
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, Scree_width, 20)];
    label.text = @"店家跟踪列表";
    label.backgroundColor = [UIColor whiteColor];
    [view addSubview:label];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight+75, Scree_width, Scree_height-75-kTopHeight)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

#pragma -mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellTrackShop *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellTrackShop alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.dict = self.arrayData[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayData[indexPath.row];
    VCEditTrack *vc = [[VCEditTrack alloc]init];
    vc.shopID = self.storeID;
    vc.trackID = [NSString stringWithFormat:@"%@",dict[@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.arrayData removeAllObjects];
    [self getHttpData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.stringTitle;
    
    self.arrayData = [NSMutableArray array];
    
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
