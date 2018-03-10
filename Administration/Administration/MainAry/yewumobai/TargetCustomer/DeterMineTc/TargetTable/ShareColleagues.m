//
//  ShareColleagues.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/3.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ShareColleagues.h"
#import "branModel.h"
#import "BranTableViewCell.h"
@interface ShareColleagues ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
}
@property(nonatomic,strong)NSMutableArray *daArr;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray *ArrID;
@property(nonatomic,strong)NSMutableArray *groupNumber;
@end

@implementation ShareColleagues

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享给同事";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    [self afnetworking];
    [self InterTableUI];
}
-(void)InterTableUI
{
    
    NSString* phoneModel = [UIDevice devicePlatForm];
    
    infonTableview= [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        infonTableview.frame =CGRectMake(0,88,self.view.bounds.size.width,self.view.bounds.size.height-88);
    }else{
        infonTableview.frame =CGRectMake(0,65,self.view.bounds.size.width,self.view.bounds.size.height-65);
    }
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    [self.view addSubview:infonTableview];
    [ZXDNetworking setExtraCellLineHidden:infonTableview];
}
-(void)afnetworking{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectDepartmentIdusers.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"CompanyInfoId":[USER_DEFAULTS objectForKey:@"companyinfoid"],@"DepartmentID":[USER_DEFAULTS objectForKey:@"departmentID"]};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            _dataArray = [NSMutableArray array];
            _daArr = [NSMutableArray array];
            _ArrID = [NSMutableArray array];
            _groupNumber  = [NSMutableArray array];
            _indexArray = [NSMutableArray array];
            NSArray *array=[responseObject valueForKey:@"list"];
            for (NSDictionary *dic in array) {
                [_dataArray addObject:[dic valueForKey:@"account"]];
                [_daArr addObject:[dic valueForKey:@"departmentName"]];
                [_ArrID addObject:[dic valueForKey:@"usersid"]];
                [_groupNumber addObject:[dic valueForKey:@"name"]];
                if ([dic valueForKey:@"icon"] ==nil) {
                    [_indexArray addObject:@""];
                }else{
                   [_indexArray addObject:[dic valueForKey:@"icon"]];
                }
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
        }else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到同事信息" andInterval:1.0];
            [infonTableview addEmptyViewWithImageName:@"" title:@"没有搜索到同事信息" Size:20.0];
            infonTableview.emptyView.hidden = NO;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupNumber.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"gameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imageVw =[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 50, 50)];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageVw.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii: imageVw.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = imageVw.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    imageVw.layer.mask = maskLayer;
    [imageVw sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,_indexArray[indexPath.row]]] placeholderImage:[UIImage  imageNamed:@"tx23"]];
    [cell addSubview:imageVw];
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, cell.width-70, 30)];
    namelabel.font = [UIFont systemFontOfSize:15];
    namelabel.text = _groupNumber[indexPath.row];
    [cell addSubview:namelabel];
    
    UILabel *iphonelabel =[[UILabel alloc]initWithFrame:CGRectMake(70, 40, 110, 30)];
    iphonelabel.font = [UIFont systemFontOfSize:14];
    iphonelabel.textColor = [UIColor lightGrayColor];
    iphonelabel.text =_dataArray[indexPath.row];
    [cell addSubview:iphonelabel];
    
    UILabel *departmentname = [[UILabel alloc]initWithFrame:CGRectMake(190, 40, cell.width-190, 30)];
    departmentname.font =[UIFont systemFontOfSize:14];
    departmentname.textColor = [UIColor lightGrayColor];
    departmentname.text =_daArr[indexPath.row];
    departmentname.textAlignment = NSTextAlignmentRight;
    
    [cell addSubview:departmentname];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *uStr =[[NSString alloc]init];
    
    
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    if ([self.yiandmu isEqualToString:@"1"]) {
        uStr = [NSString stringWithFormat:@"%@shop/UpdateTargetVisitUserId.action",KURLHeader];//目标
        dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"userid":_ArrID[indexPath.row],@"TargetVisitId":self.targetvisitid,@"shopId":self.shopip};
    }else{
        uStr = [NSString stringWithFormat:@"%@shop/updateIntendedUserid.action",KURLHeader];//意向
        dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"userid":_ArrID[indexPath.row],@"IntendedId":self.targetvisitid,@"shopId":self.shopip};
    }
    
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
         if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
             PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"分享成功" sureBtn:@"确认" cancleBtn:nil];
             alertView.resultIndex = ^(NSInteger index){
                [self.navigationController popViewControllerAnimated:YES];
             };
             [alertView showMKPAlertView];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
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
