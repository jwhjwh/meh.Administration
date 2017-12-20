//
//  storesActivity.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/2.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "storesActivity.h"
#import "JXAlertview.h"   //第三方"年-月"日期选择器
#import "CustomYearDatePicker.h"   //年选择器
#import "DetaStoresActivity.h"
#define WIDTH   [UIScreen mainScreen].bounds.size.width
@interface storesActivity ()<UITableViewDataSource,UITableViewDelegate,CustomAlertDelegete>

{
    UITableView *infonTableview;
    CustomYearDatePicker *yearDpicker;   //年选择器
    NSInteger _mark;         //标记类型
    NSString   *_selectDate; //标记选中的日期
}
@property (strong,nonatomic) NSMutableArray *InterNameAry;
@property (strong,nonatomic) NSMutableArray *InteridAry;
@end

@implementation storesActivity
-(void)viewWillAppear:(BOOL)animated
{
   [self networiking];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"活动概要";
    yearDpicker = [[CustomYearDatePicker alloc]initWithFrame:CGRectMake(0, 60, WIDTH-100, 160)];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    //fj_ico
    if ([_shopname isEqualToString:@"1"]) {
        
    }else{
        UIButton *rightitem = [UIButton buttonWithType:UIButtonTypeCustom];
        rightitem.frame =CGRectMake(self.view.frame.size.width-30, 0, 28,28);
        [rightitem setBackgroundImage:[UIImage imageNamed:@"fj_ico"] forState:UIControlStateNormal];
        [rightitem addTarget: self action: @selector(rightItemAction) forControlEvents: UIControlEventTouchUpInside];
        UIBarButtonItem *rbuttonItem=[[UIBarButtonItem alloc]initWithCustomView:rightitem];
        self.navigationItem.rightBarButtonItem = rbuttonItem;
    }
    
    
    infonTableview =[[UITableView alloc]initWithFrame:CGRectMake(0,84, kScreenWidth, kScreenHeight-64)];    
    infonTableview.delegate = self;
    infonTableview.dataSource = self;
    [self.view addSubview: infonTableview];
    [ZXDNetworking setExtraCellLineHidden:infonTableview];
    
}
-(void)networiking{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectSummarytype.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Storeid":self.shopId};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"list"];
            _InterNameAry = [[NSMutableArray alloc]init];
            _InteridAry = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in array) {
                [_InterNameAry addObject:[dict valueForKey:@"summaryName"]];
               [_InteridAry addObject:[dict valueForKey:@"id"]];
            }
            [infonTableview reloadData];
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
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
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
            [infonTableview addEmptyViewWithImageName:@"" title:@"暂无活动概要" Size:20.0];
            infonTableview.emptyView.hidden = NO;
        }
        
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
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _InterNameAry[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetaStoresActivity *detaVC = [[DetaStoresActivity alloc]init];
    detaVC.shopname =_InterNameAry[indexPath.row];
    detaVC.SummaryTypeid =_InteridAry[indexPath.row];
    detaVC.Storeid =self.shopId;
    detaVC.strId = self.strId;
    detaVC.shopInfor = self.shopname;
    [self.navigationController pushViewController:detaVC animated:YES];
    
}

-(void)rightItemAction{
    
    
    JXAlertview *alert3 = [[JXAlertview alloc] initWithFrame:CGRectMake(50, 0, WIDTH-100, 260)];
    alert3.center = self.view.center;
    alert3.delegate = self;
    [alert3 initwithtitle:@"选择年份" andcommitbtn:@"确定" andStr:@"1"];
    
    //我把Dpicker添加到一个弹出框上展现出来 当然大家还是可以以任何其他动画形式展现
    [alert3 addSubview:yearDpicker];
    [alert3 show];
    _mark = 3;
    
}
-(void)btnindex:(int)index :(int)tag
{
    if (index == 2 ) {
        _selectDate = [NSString stringWithFormat:@"%d",yearDpicker.year];
        NSString *uStr =[NSString stringWithFormat:@"%@shop/insertSummaryType.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"StoreId":self.shopId,@"SummaryName":_selectDate};
        [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"添加成功" sureBtn:@"确认" cancleBtn:nil];
                alertView.resultIndex = ^(NSInteger index){
                    
                    [self networiking];
                };
                [alertView showMKPAlertView];
              
            } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
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
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _InterNameAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([infonTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [infonTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([infonTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [infonTableview setLayoutMargins:UIEdgeInsetsZero];
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

@end
