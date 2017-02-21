//
//  GonggaoxqController.m
//  Administration
//
//  Created by zhang on 2017/2/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "GonggaoxqController.h"
#import "GongTableViewCell.h"
@interface GonggaoxqController ()<UITableViewDataSource,UITableViewDelegate>
{
    int page;
    
    int totalPage;//总页数
    
}
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation GonggaoxqController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
 
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"最新公告";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+49)];
    self.tableView .delegate = self;
    self.tableView .dataSource = self;
    [self.view addSubview: self.tableView ];
  
    
    self.dataArray = [NSMutableArray array];
    [self getNetworkData:NO];
    page = 1;
    
    __weak typeof(self) weakSelf = self;
    //默认【下拉刷新】
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        _dataArray = [NSMutableArray array];
        [weakSelf getNetworkData:YES];
    }];
    
    //默认【上拉加载】
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getNetworkData:NO];
    }];
    

}
/**
 *  停止刷新
 */
-(void)endRefresh{
    
    if (page == 1) {
        [self.tableView.header endRefreshing];
    }
    [self.tableView.footer endRefreshing];
}
-(void)getNetworkData:(BOOL)isRefresh{
    if (isRefresh) {
        page = 1;
    }else{
        page++;
    }
    NSString *urlStr =[NSString stringWithFormat:@"%@adminNotice/queryNotice.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"]};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString *str =[[responseObject valueForKey:@"data" ] valueForKey:@"count"];
        // NSLog(@"%@",str);
        totalPage = [str intValue];
        if (page <= totalPage||totalPage==0) {
            [self endRefresh];
            if (page==1) {
                [self.tableView.footer  setTitle:@"" forState:MJRefreshFooterStateIdle];
                
            }
            
        }
        
        
        [self.tableView reloadData];
        if (page>=totalPage) {
            [self.tableView.footer endRefreshing];
            
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
    
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GongTableViewCell *cell = [[GongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[GongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    if (self.dataArray.count > 0) {
        cell = [[GongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        //        cell.coModel = self.BidCouponDataArray[indexPath.row];
        //        cell.view.image =[UIImage imageNamed:@"daishiyon@2x"];
        //        cell.priceLabel.textColor=[UIColor colorWithRed:58/256.0 green:147/256.0 blue:223.0/256.0 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
