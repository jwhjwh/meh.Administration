//
//  quasiCooperation.m
//  Administration
//
//  Created by 九尾狐 on 2017/12/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "quasiCooperation.h"
#import "InterestedTabelViewController.h"
#import "TargetTableViewController.h"
@interface quasiCooperation ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *infonTableview;
    
}
@property (strong,nonatomic) NSMutableArray *InterNameAry;
@property (nonatomic,assign)int pagenum;

@end

@implementation quasiCooperation

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"准合作客户";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    NSString* phoneModel = [UIDevice devicePlatForm];
    infonTableview =[[UITableView alloc]init];
    infonTableview.delegate = self;
    infonTableview.dataSource = self;
    [self.view addSubview: infonTableview];
    [ZXDNetworking setExtraCellLineHidden:infonTableview];
    
    [infonTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
            make.top.mas_equalTo(self.view.mas_top).offset(94);
        }else{
            make.top.mas_equalTo(self.view.mas_top).offset(70);
        }
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
    
    [self getNetworkData:YES];
    __weak typeof(self) weakSelf = self;
    //默认【下拉刷新】
    infonTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _InterNameAry = [NSMutableArray array];
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
    NSString *uStr =[NSString stringWithFormat:@"%@stores/selectshopDepartmentId.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"DepartmentId":[ShareModel shareModel].departmentID, @"RoleId":[ShareModel shareModel].roleID,@"nu":pageStr};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"这已经是全部的客户了" andInterval:1.0];
            [infonTableview.mj_footer endRefreshingWithNoMoreData];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]){
            _InterNameAry = [[NSMutableArray alloc]init];
            _InterNameAry=[responseObject valueForKey:@"list"];
            
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
        }
         [self endRefresh];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _InterNameAry[indexPath.row];
    if ([dic[@"types"] integerValue] ==1) {
        //customer.text = @"意向客户";
        InterestedTabelViewController *intabel = [[InterestedTabelViewController alloc]init];
        intabel.shopId = dic[@"shopId"];
        intabel.isofyou = @"1";
     [self.navigationController pushViewController:intabel animated:YES];
    }else{
       // customer.text = @"目标客户";
        TargetTableViewController *ttvc = [[TargetTableViewController alloc]init];
        
        ttvc.oneStore = @"1";
        ttvc.isofyou = NO;
        ttvc.shopid = dic[@"shopId"];
        
        ttvc.cellend = NO;
        [self.navigationController pushViewController:ttvc animated:YES];
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=nil;
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
   
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
        
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = _InterNameAry[indexPath.row];
    UIImageView *tximage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
    NSString *imageStr = [NSString stringWithFormat:@"%@%@",KURLImage,dic[@"icon"]];
    [tximage sd_setImageWithURL:[NSURL URLWithString:imageStr]placeholderImage:[UIImage imageNamed:@"head_icon"]];
    tximage.layer.masksToBounds = YES;
    tximage.layer.cornerRadius =25.0f;
    [cell addSubview:tximage];
    
    UILabel *namelabel =[[UILabel alloc]initWithFrame:CGRectMake(65, 5, 100, 25)];
    namelabel.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
    namelabel.font = [UIFont systemFontOfSize:14];
    [cell addSubview:namelabel];
    
    UILabel *iphone = [[UILabel alloc]initWithFrame:CGRectMake(65, 30, 100, 20)];
    iphone.text = [NSString stringWithFormat:@"%@",dic[@"account"]];
    iphone.font = [UIFont systemFontOfSize:11];
    iphone.textColor = [UIColor lightGrayColor];
    [cell addSubview:iphone];
    
    UILabel *day = [[UILabel alloc]initWithFrame:CGRectMake(cell.width-80, 5, 80, 20)];
    day.font = [UIFont systemFontOfSize:13];
    day.textColor = [UIColor lightGrayColor];
    day.text = [[NSString alloc]initWithFormat:@"%@", [dic[@"dates"] substringWithRange:NSMakeRange(5, 11)]];
    [cell addSubview:day];
    
    UILabel *customer = [[UILabel alloc]initWithFrame:CGRectMake(cell.width-80, 25, 80, 20)];
     if ([dic[@"types"] integerValue] ==1) {
        customer.text = @"意向客户";
    }else{
        customer.text = @"目标客户";
    }
    customer.font = [UIFont systemFontOfSize:13];
    customer.textColor = [UIColor lightGrayColor];
    [cell addSubview:customer];
    
    
    UILabel *shopname = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, cell.width, 30)];
    shopname.text = [NSString stringWithFormat:@"店名:%@",dic[@"storeName"]];
    [cell addSubview:shopname];
    
    UILabel *citylabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 100, cell.width, 40)];
    citylabel.text = [NSString stringWithFormat:@"地区:%@%@%@\n日期:%@",dic[@"province"],dic[@"city"],dic[@"county"],[dic[@"dates"] substringWithRange:NSMakeRange(0, 10)]];
    citylabel.textColor = [UIColor lightGrayColor];
    citylabel.font = [UIFont systemFontOfSize:14];
    citylabel.numberOfLines = 0;
    [cell addSubview:citylabel];
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _InterNameAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 150;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    
    return 1;
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
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
