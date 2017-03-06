//
//  brandViewController.m
//  Administration
//
//  Created by zhang on 2017/3/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "brandViewController.h"
#import "brandTableViewCell.h"
#import "LGUIView.h"
#import "Brandmodle.h"
@interface brandViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    LGUIView * lgView;
    UITableView * _tableView;
    int page;
    int totalPage;//总页数
}
@property (nonatomic,strong)NSMutableArray *array;
@property (strong,nonatomic) UIButton *sousuoBtn;
@end

@implementation brandViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.title=@"经营品牌";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(butLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIButton *bton = [UIButton buttonWithType:UIButtonTypeCustom];
    bton.frame =CGRectMake(0, 0, 28,28);
    [bton setBackgroundImage:[UIImage imageNamed:@"fj_ico"] forState:UIControlStateNormal];
    [bton addTarget: self action: @selector(buttonrightItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *btonItem=[[UIBarButtonItem alloc]initWithCustomView:bton];
    self.navigationItem.rightBarButtonItem=btonItem;
  
  
    _sousuoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *imageBtn = [UIImage imageNamed:@"ss_ico01"];
    [_sousuoBtn setBackgroundImage:imageBtn forState:UIControlStateNormal];
    _sousuoBtn.frame=CGRectMake(10, 70, Scree_width-20, 40);
    _sousuoBtn.layer.masksToBounds = YES;
    _sousuoBtn.layer.cornerRadius = 8.0;
    [_sousuoBtn addTarget:self action:@selector(Touchsearch)forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:_sousuoBtn];
    [self creatTableView];
    [self creatLGView];
}

-(void)creatTableView
{    _tableView.showsVerticalScrollIndicator = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120,Scree_width - 40, Scree_height - 120) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
     [ZXDNetworking setExtraCellLineHidden:_tableView];
    self.array = [NSMutableArray array];
    [self getNetworkData:NO];
    page = 1;
    __weak typeof(self) weakSelf = self;
    //默认【下拉刷新】
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        _array = [NSMutableArray array];
        [weakSelf getNetworkData:YES];
    }];
    //默认【上拉加载】
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getNetworkData:NO];
    }];
}
-(void)creatLGView
{
    NSMutableArray * arr = [NSMutableArray new];
    for (int i = 0; i < 26; i ++)
    {
        unichar ch = 65 + i;
        NSString * str = [NSString stringWithUTF8String:(char *)&ch];
        [arr addObject:str];
    }
    
    lgView = [[LGUIView alloc]initWithFrame:CGRectMake(Scree_width - 40, 100, 40, Scree_height - 140) indexArray:arr];
    [self.view addSubview:lgView];
    
    [lgView selectIndexBlock:^(NSInteger section)
     {
         [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                                 animated:NO
                           scrollPosition:UITableViewScrollPositionTop];
     }];
}
/**
 *  停止刷新
 */
-(void)endRefresh{
    
    if (page == 1) {
        [_tableView.header endRefreshing];
    }
    [_tableView.footer endRefreshing];
}
-(void)buttonrightItem{
    
}
-(void)butLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    unichar ch = 65 + section;
    NSString * str = [NSString stringWithUTF8String:(char *)&ch];
    return str;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 26;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    brandTableViewCell *cell = [[brandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[brandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.modle=_array[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(void)getNetworkData:(BOOL)isRefresh{
    if (isRefresh) {
        page = 1;
    }else{
        page++;
    }
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    NSString *uStr =[NSString stringWithFormat:@"%@brand/querybrand.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"nu":pageStr};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        NSArray *array=[responseObject valueForKey:@"brandlist"];
        [self endRefresh];
        if (page==1) {
            [_tableView.footer  setTitle:@"" forState:MJRefreshFooterStateIdle];
        }
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            for (NSDictionary *dic in array) {
                Brandmodle *model=[[Brandmodle alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.array addObject:model];
            }
            [_tableView reloadData];
            if (array.count==0) {
         _tableView.footer.state = MJRefreshFooterStateNoMoreData;
                return;
            }
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到品牌信息" andInterval:1.0];
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]||[[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登陆超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }
        
    }failure:^(NSError *error) {
        
    }view:self.view MBPro:YES];
    
}

@end
