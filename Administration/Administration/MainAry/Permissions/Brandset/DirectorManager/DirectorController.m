//
//  DirectorController.m
//  Administration
//
//  Created by zhang on 2017/5/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "DirectorController.h"
#import "ZJLXRTableViewCell.h"
#import "DirtmsnaModel.h"
@interface DirectorController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation DirectorController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=_str;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight+49)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self datalade];
}
-(void)datalade{
    NSString *urlStr =[NSString stringWithFormat:@"%@manager/queryPositionManager.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Num":@"1"};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            self.dataArray = [NSMutableArray array];
            if ([_str isEqualToString:@"添加负责总监"]) {
                NSArray *array=[responseObject valueForKey:@"dList"];
                for (NSDictionary *dic in array) {
                    DirtmsnaModel *model=[[DirtmsnaModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                    
                }
            }else{
                NSArray *array=[responseObject valueForKey:@"mList"];
                for (NSDictionary *dic in array) {
                    DirtmsnaModel *model=[[DirtmsnaModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                    
                }
            }
          
            
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
            [_tableView addEmptyViewWithImageName:@"" title:@"暂无消息" Size:20.0];
            _tableView.emptyView.hidden = NO;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJLXRTableViewCell *cell = [[ZJLXRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[ZJLXRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
   
    return cell;
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DirtmsnaModel *model = _dataArray[indexPath.row];
    NSMutableArray *arr=[NSMutableArray arrayWithObjects:model, nil];
    self.blockArray(arr);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
