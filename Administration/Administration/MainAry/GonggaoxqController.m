//
//  GonggaoxqController.m
//  Administration
//
//  Created by zhang on 2017/2/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "GonggaoxqController.h"
#import "AmentxqController.h"
#import "GongTableViewCell.h"
#import "GongModel.h"
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
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    NSString *urlStr =[NSString stringWithFormat:@"%@adminNotice/queryNotice.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"pageNo":pageStr,@"comId":[USER_DEFAULTS objectForKey:@"companyinfoid"]};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString *str =[[responseObject valueForKey:@"data" ] valueForKey:@"count"];
        NSArray *array=[responseObject valueForKey:@"nlist"];
        // NSLog(@"%@",str);
        totalPage = [str intValue];
        if (page <= totalPage||totalPage==0) {
            [self endRefresh];
            if (page==1) {
                [self.tableView.footer  setTitle:@"" forState:MJRefreshFooterStateIdle];
                
            }
            
        }
        for (NSDictionary *dic in array) {
            GongModel *model=[[GongModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
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
    return self.dataArray.count;
    
    
    
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
            cell.gongModel = self.dataArray[indexPath.row];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AmentxqController *amentVC=[[AmentxqController alloc]init];
    amentVC.gonModel=self.dataArray[indexPath.row];
    [self.navigationController pushViewController:amentVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
