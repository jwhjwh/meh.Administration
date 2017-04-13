//
//  BrandsetController.m
//  Administration
//
//  Created by zhang on 2017/4/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "BrandsetController.h"
#import "AddbranController.h"
#import "BranTableViewCell.h"
#import "branModel.h"
@interface BrandsetController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *indexArray;
@end

@implementation BrandsetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"品牌部";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIButton *bton = [UIButton buttonWithType:UIButtonTypeCustom];
    bton.frame =CGRectMake(0, 0, 28,28);
    [bton setBackgroundImage:[UIImage imageNamed:@"fj_ico"] forState:UIControlStateNormal];
    [bton addTarget: self action: @selector(buttonrightItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *btonItem=[[UIBarButtonItem alloc]initWithCustomView:bton];
    self.navigationItem.rightBarButtonItem=btonItem;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight+49)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    _indexArray=[NSMutableArray arrayWithObjects:@"主力品牌部",@"非主力品牌综合部", nil];
    [self datalade];
    
}
-(void)datalade{
    NSString *urlStr =[NSString stringWithFormat:@"%@user/queryDepartment",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":@"16",@"Num":@"2"};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            self.dataArray = [NSMutableArray array];
            NSArray *array=[responseObject valueForKey:@"mList"];
            NSArray *arr=[responseObject valueForKey:@"nList"];
            NSMutableArray *marr=[NSMutableArray array];
            NSMutableArray *narr=[NSMutableArray array];
            for (NSDictionary *dic in array) {
                
               branModel *model=[[branModel alloc]init];
               [model setValuesForKeysWithDictionary:dic];
               [marr addObject:model];
            }
            [self.dataArray addObject:marr];
            for (NSDictionary *dic in arr) {
                
                branModel *model=[[branModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [narr addObject:model];
            }
             [self.dataArray addObject:narr];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]||[[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登陆超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
            
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }
        if (self.dataArray.count==0) {
            [_tableView addEmptyViewWithImageName:@"" title:@"暂无消息"];
            _tableView.emptyView.hidden = NO;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    

}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)buttonrightItem{
    AddbranController *addbranVC=[[AddbranController alloc]init];
    [self.navigationController pushViewController:addbranVC animated:YES];
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section]count];
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor lightGrayColor];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString * str = [NSString stringWithFormat:@"%@(%lu)",_indexArray[section],(unsigned long)[_dataArray[section]count]];
    return str;
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
   
    BranTableViewCell *cell = [[BranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[BranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
