//
//  BrandTableViewController.m
//  Administration
//
//  Created by 九尾狐 on 2018/1/8.
//  Copyright © 2018年 九尾狐. All rights reserved.
//

#import "BrandTableViewController.h"
#import "AddBrandViewController.h"
#import "DateBrandViewController.h"

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
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30,30)];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setTitle:@"+" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoAdd) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
-(void)gotoAdd{
     AddBrandViewController *addBrandVC=[[AddBrandViewController alloc]init];
     [self.navigationController pushViewController:addBrandVC animated:YES];
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
            _arr = [NSMutableArray array];
            NSArray *array =[responseObject valueForKey:@"list"];
            for (NSDictionary *dict in array) {
                [_arr addObject:dict];
            }
            [infonTableview reloadData];
            
            
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

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = _arr[indexPath.row];
    NSLog(@"-----%@------%@",dic,_arr);
    NSString *imageStr = [NSString stringWithFormat:@"%@%@",KURLImage,dic[@"brandLogo"]];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
    [image sd_setImageWithURL:[NSURL URLWithString:imageStr]placeholderImage:[UIImage imageNamed:@"head_icon"]];
    [cell addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, cell.width-60, 40)];
    label.text = dic[@"finsk"];
    [cell addSubview:label];
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler: ^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //self.indexPath = indexPath;
        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"真的要删除此品牌么" sureBtn:@"确认" cancleBtn:@"取消"];
        alertView.resultIndex = ^(NSInteger index){
            if (index==2) {
                
            }
        };
        [alertView showMKPAlertView];
        
    }];
    //删除按钮颜色
    deleteAction.backgroundColor = GetColor(137,52,167,1);
    //添加一个编辑按钮
    UITableViewRowAction *topRowAction =[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"编辑" handler:^ (UITableViewRowAction *action, NSIndexPath *indexPath) {
       // [self gotoEdit:indexPath];
        NSDictionary *dic =_arr[indexPath.row];
        DateBrandViewController *date = [[DateBrandViewController alloc]init];
        date.dateDic = dic;
        date.yesorno = @"1";
        [self.navigationController pushViewController:date animated:YES];
        
    }];
    //置顶按钮颜色
    topRowAction.backgroundColor = GetColor(0, 124, 248, 1);
    //将设置好的按钮方到数组中返回
    return @[deleteAction,topRowAction];
    // return @[deleteAction,topRowAction,collectRowAction];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic =_arr[indexPath.row];
    DateBrandViewController *date = [[DateBrandViewController alloc]init];
    date.dateDic = dic;
    date.yesorno = @"2";
    [self.navigationController pushViewController:date animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _arr.count;
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
