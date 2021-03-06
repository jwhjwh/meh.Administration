//
//  SearchViewController.m
//  Administration
//  人员搜索页
//  Created by 九尾狐 on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "SearchViewController.h"
#import "PersonneTableViewCell.h"
#import "inftionxqController.h"
#import "PersonModel.h"
#import "LVModel.h"
#import "LVFmdbTool.h"
@interface SearchViewController ()<UITextViewDelegate, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) NSMutableArray *searchDataArray;
@property (nonatomic, retain) UITableView *searchTableView;
@property (nonatomic, retain) UISearchBar *searchBar;

@end

@implementation SearchViewController
- (void) viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
  
}
- (void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.tintColor = [UIColor RGBNav];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
   
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
    UIView *searchBarTextField = [[_searchBar.subviews.firstObject subviews] firstObject];
    
    searchBarTextField.tintColor = [UIColor redColor];
    self.searchBar.placeholder=@"搜索";
    //placeholder(self.searchBar);
    self.searchBar.searchBarStyle=UISearchBarStyleMinimal;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    self.searchTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,kScreenWidth,kScreenHeight-64) style:UITableViewStylePlain];
    //分割线无
   // self.searchTableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    [self.view addSubview: self.searchTableView];
    [self.searchTableView registerNib:[UINib nibWithNibName:@"PersonneTableViewCell" bundle:nil] forCellReuseIdentifier:@"CARRY"];
    [self setExtraCellLineHidden:self.searchTableView];
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
    return  55.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CARRY" forIndexPath:indexPath];
    PersonModel *model= _searchDataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    [cell loadDataFromModel:model];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonModel *pmodel =self.searchDataArray[indexPath.row];
    //首先,需要获取沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 拼接图片名为"currentImage.png"的路径
    NSString *imageFilePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"Image%ld.png",indexPath.row]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString: [NSString stringWithFormat:@"%@%@",KURLHeader,pmodel.icon]]];
    //转换为图片保存到以上的沙盒路径中
    UIImage * currentImage = [UIImage imageWithData:data];
    //其中参数0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
    [UIImageJPEGRepresentation(currentImage, 0.5) writeToFile:imageFilePath  atomically:YES];
    NSString * imgData = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"Image%ld.png",indexPath.row]];
    NSString *fuzzyQuerySql = [NSString stringWithFormat:@"SELECT * FROM t_modals WHERE ID_No = %@",pmodel.usersid];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSArray *modals = [LVFmdbTool queryData:fuzzyQuerySql];
    if (modals.count>0) {
        NSString *delesql = [NSString stringWithFormat:@"DELETE FROM t_modals WHERE ID_No = %@",pmodel.usersid];
        [LVFmdbTool deleteData:delesql];
    }
    LVModel *models = [LVModel modalWith:pmodel.name call:[NSString stringWithFormat:@"%ld",pmodel.account] no:pmodel.usersid image:imgData time:dateString roleld:pmodel.NewName];
    BOOL isInsert =  [LVFmdbTool insertModel:models];
    if (isInsert) {
        
        NSLog(@"插入数据成功");
        
    } else {
        NSLog(@"插入数据失败");
    }
    inftionxqController *imftionVC=[[inftionxqController alloc]init];
    imftionVC.IDStr=pmodel.usersid;
    [self.navigationController pushViewController:imftionVC animated:YES];
}
-(void)upDataSearchSpecialOffe{
    NSString *uStr =[NSString stringWithFormat:@"%@manager/fuzzyQueryEmployee.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
         NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Name":self.searchBar.text};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        _searchDataArray=[NSMutableArray array];
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *resuAry = responseObject[@"list"];
            for (NSDictionary *newDict in resuAry) {
                PersonModel *model = [[PersonModel alloc]init];
                [model setValuesForKeysWithDictionary:newDict];
                [self.searchDataArray addObject:model];
            }
            [self.searchTableView reloadData];
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到联系人" andInterval:1.0];
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

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}

@end
