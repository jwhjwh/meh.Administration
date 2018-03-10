//
//  newCooperation.m
//  Administration
//
//  Created by 九尾狐 on 2017/12/21.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "newCooperation.h"
#import "StoreinforViewController.h"
@interface newCooperation ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *infonTableview;
    
}
@property (strong,nonatomic) NSMutableArray *InterNameAry;

@end

@implementation newCooperation

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新合作客户";
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
            make.top.mas_equalTo(self.view.mas_top).offset(0);
        }
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
     [self getNetworkData];
   
    
}
-(void)getNetworkData{
    
    NSString *uStr =[NSString stringWithFormat:@"%@stores/selectStoreDepartmentId.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"DepartmentId":[ShareModel shareModel].departmentID,@"CompanyInfoId":compid, @"RoleId":[ShareModel shareModel].roleID};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
         if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
            [infonTableview addEmptyViewWithImageName:@"" title:@"暂无合作客户" Size:20.0];
            infonTableview.emptyView.hidden  = NO;
         }else if([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]){
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
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _InterNameAry[indexPath.row];
    StoreinforViewController *storeVC = [[StoreinforViewController alloc]init];
   storeVC.shopId =[NSString stringWithFormat:@"%@",dic[@"id"]];
    storeVC.strId = [ShareModel shareModel].roleID;
    storeVC.isend = NO;
    storeVC.shopname = @"1";
    storeVC.shopifot = @"1";
    storeVC.titleName = [NSString stringWithFormat:@"%@",dic[@"name"]];
    [self.navigationController pushViewController:storeVC animated:YES];
    
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
    
    UILabel *day = [[UILabel alloc]initWithFrame:CGRectMake(cell.width-80, 10, 80, 30)];
    day.font = [UIFont systemFontOfSize:13];
    day.textColor = [UIColor lightGrayColor];
    day.text = [[NSString alloc]initWithFormat:@"%@", [dic[@"dates"] substringWithRange:NSMakeRange(5, 11)]];
    [cell addSubview:day];
    
    UILabel *shopname = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, cell.width, 30)];
    shopname.text = [NSString stringWithFormat:@"店名:%@",dic[@"storeName"]];
    [cell addSubview:shopname];
   
    UILabel *citylabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 100, cell.width, 60)];
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
    
    return 160;
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
