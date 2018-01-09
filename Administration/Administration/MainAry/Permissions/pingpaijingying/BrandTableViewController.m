//
//  BrandTableViewController.m
//  Administration
//
//  Created by 九尾狐 on 2018/1/8.
//  Copyright © 2018年 九尾狐. All rights reserved.
//

#import "BrandTableViewController.h"

@interface BrandTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    
}
@property (nonatomic,retain)NSMutableArray *arr;
@property (nonatomic,assign)int pagenum;
@end

@implementation BrandTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"品牌设置";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(butLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    [self BrandUI];
}
-(void)BrandUI{
    NSString* phoneModel = [UIDevice devicePlatForm];
    UILabel *toplabel = [[UILabel alloc]init];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        toplabel.frame =CGRectMake(0, 94, self.view.frame.size.width, 30);
    }else{
         toplabel.frame =CGRectMake(0, 88, self.view.frame.size.width, 30);
    }
    toplabel.font = [UIFont systemFontOfSize:14];
    toplabel.text = @"      品牌列表";
    [self.view addSubview:toplabel];
    
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,toplabel.bottom+10,self.view.bounds.size.width,self.view.bounds.size.height-toplabel.bottom+10) style:UITableViewStylePlain];
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    infonTableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.view addSubview:infonTableview];
    
    
     [self getNetworkData:YES];
    __weak typeof(self) weakSelf = self;
    //默认【下拉刷新】
    infonTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _arr = [NSMutableArray array];
        [weakSelf getNetworkData:YES];
        [infonTableview reloadData];
    }];
    
    //默认【上拉加载】
    infonTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [weakSelf getNetworkData:NO];
        //[self.tableView reloadData];
    }];
    
}
-(void)endRefresh{
    if (_pagenum == 1) {
        [infonTableview.mj_header endRefreshing];
    }else{
        [infonTableview.mj_footer endRefreshing];
    }
    
}
-(void)getNetworkData:(BOOL)isRefresh{
    if (isRefresh) {
        _pagenum = 1;
    }else{
        _pagenum++;
    }
      NSString *pageStr=[NSString stringWithFormat:@"%d",_pagenum];
    NSString *uStr =[NSString stringWithFormat:@"%@brand/querybrand.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"nu":pageStr};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array =[responseObject valueForKey:@"list"];
            for (NSDictionary *dict in array) {
                [_arr addObject:dict];
            }
            [infonTableview reloadData];
            //[self.tableView.footer endRefreshing];
            
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            
            if (self.arr.count>0) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"这已经是全部的部门了" andInterval:1.0];
                [infonTableview.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                [infonTableview addEmptyViewWithImageName:@"" title:@"暂无部门" Size:20.0];
                infonTableview.emptyView.hidden = NO;
            }
            
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"这已经是全部的部门了" andInterval:1.0];
            [infonTableview.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        [self endRefresh];

    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.textLabel.text = _arr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _arr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)butLiftItem{
     [self.navigationController popViewControllerAnimated:YES];
}
@end
