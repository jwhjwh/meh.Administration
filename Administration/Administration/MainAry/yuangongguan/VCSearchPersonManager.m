//
//  VCSearchPersonManager.m
//  Administration
//
//  Created by zhang on 2018/1/16.
//  Copyright © 2018年 九尾狐. All rights reserved.
//

#import "VCSearchPersonManager.h"
#import "CellPersonManager.h"
#import "inftionxqController.h"
@interface VCSearchPersonManager ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *searchDataArray;
@property (nonatomic, weak) UITableView *searchTableView;
@property (nonatomic, weak) UISearchBar *searchBar;

@end

@implementation VCSearchPersonManager

#pragma -mark custem

-(void)getHttpData:(NSString *)string
{
    NSString *uStr =[NSString stringWithFormat:@"%@user/selectlike",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSArray *roleIDs = [USER_DEFAULTS valueForKey:@"myRole"];
    NSDictionary *dict = @{
                           @"appkey":apKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"RoleId":[roleIDs componentsJoinedByString:@","],
                           @"CompanyInfoId":compid,
                           @"name":string
                           };
    [self.searchDataArray removeAllObjects];
    [ZXDNetworking GET:uStr parameters:dict success:^(id responseObject) {
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            self.searchDataArray = [[responseObject valueForKey:@"list"]mutableCopy];
            [self.searchTableView reloadData];
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
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width, 50*kHeight)];
//    UIView *searchBarTextField = [[_searchBar.subviews.firstObject subviews] firstObject];
//    
//    searchBarTextField.tintColor = [UIColor redColor];
    searchBar.placeholder=@"搜索";
    //placeholder(self.searchBar);
    searchBar.searchBarStyle=UISearchBarStyleMinimal;
    searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
    
    
    UITableView *searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight-64) style:UITableViewStylePlain];
    //分割线无
    // self.searchTableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    [searchTableView registerClass:[CellPersonManager class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:searchTableView];
    [self.view addSubview: searchTableView];
    self.searchTableView = searchTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.searchDataArray[indexPath.row];
    CellPersonManager *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CellPersonManager alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.dict = dict;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.searchDataArray[indexPath.row];
    inftionxqController *vc = [[inftionxqController alloc]init];
    vc.IDStr = [NSString stringWithFormat:@"%@",dict[@"usersid"]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma -mark searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self getHttpData:searchBar.text];
    [searchBar resignFirstResponder];
    
}

#pragma  -mark system

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchDataArray = [NSMutableArray array];
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
