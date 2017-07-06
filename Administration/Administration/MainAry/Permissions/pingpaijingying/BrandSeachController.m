//
//  BrandSeachController.m
//  Administration
//
//  Created by zhang on 2017/3/7.
//  Copyright © 2017年 九尾狐. All rights reserved.
#import "BrandSeachController.h"
#import "EditbrandController.h"
#import "brandTableViewCell.h"
#import "Brandmodle.h"
@interface BrandSeachController ()<UITextViewDelegate, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) NSMutableArray *searchDataArray;
@property (nonatomic, retain) UITableView *searchTableView;
@property (nonatomic, retain) UISearchBar *searchBar;

@end

@implementation BrandSeachController
- (void) viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void) viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor RGBNav];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSubViewS];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
}
-(void)buttLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addSubViewS{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width, 50*kHeight)];
    self.searchBar.placeholder=@"搜索";
     placeholder(self.searchBar);
    self.searchBar.searchBarStyle=UISearchBarStyleMinimal;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    self.searchTableView .showsVerticalScrollIndicator = NO;
    self.searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight-64) style:UITableViewStylePlain];
    //分割线无
    // self.searchTableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    [self.view addSubview: self.searchTableView];

    [ZXDNetworking setExtraCellLineHidden:self.searchTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    self.searchDataArray = [NSMutableArray array];
    [self.searchTableView  reloadData];
    [self upDataSearchSpecialOffe];
    [searchBar resignFirstResponder];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchDataArray.count;
}

//row 高
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 74;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    brandTableViewCell *cell = [[brandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[brandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.modle=self.searchDataArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Brandmodle *model=self.searchDataArray[indexPath.row];
}
-(void)upDataSearchSpecialOffe{
    NSString *uStr =[NSString stringWithFormat:@"%@brand/querybrand.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"key":self.searchBar.text};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        _searchDataArray=[NSMutableArray array];
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *resuAry = responseObject[@"brandlist"];
            for (NSDictionary *newDict in resuAry) {
                Brandmodle *model=[[Brandmodle alloc]init];
                [model setValuesForKeysWithDictionary:newDict];
                [self.searchDataArray addObject:model];
            }
            [self.searchTableView reloadData];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索产品信息" andInterval:1.0];
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
        }
        
        
    }failure:^(NSError *error) {
        }view:self.view MBPro:YES];
    
}
@end
