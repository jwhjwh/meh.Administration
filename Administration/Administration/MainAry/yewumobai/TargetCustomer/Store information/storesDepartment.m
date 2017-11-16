//
//  storesDepartment.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/1.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "storesDepartment.h"
#import "branModel.h"
#import "BranTableViewCell.h"
@interface storesDepartment ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *daArr;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *indexArray;
@property (nonatomic,strong)NSArray *natureArr;
@property(nonatomic,strong)NSMutableArray *ArrID;
@property (nonatomic,strong)NSString *StoreId;
@property(nonatomic,strong)NSMutableArray *groupNumber;
@end

@implementation storesDepartment

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择部门";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight+49)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self working];
}
-(void)working{
    NSString *urlStr =[NSString stringWithFormat:@"%@user/queryBrandDepartment",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"Num":@"1"};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            self.dataArray = [NSMutableArray array];
            _daArr = [NSMutableArray array];
            _ArrID = [NSMutableArray array];
            _groupNumber  = [NSMutableArray array];
            NSArray *array=[responseObject valueForKey:@"mList"];
            for (NSDictionary *dic in array) {
                
                NSArray *barndArr = [dic valueForKey:@"brandList"];
                [_daArr addObject:[dic valueForKey:@"departmentName"]];
                [_ArrID addObject:[dic valueForKey:@"id"]];
                [_groupNumber addObject:[dic valueForKey:@"groupNumber"]];
                NSMutableArray *logoArr=[NSMutableArray array];
                
                for (NSDictionary *dict in barndArr) {
                    branModel *model=[[branModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [logoArr addObject:model];
                }
                [self.dataArray addObject:logoArr];
            }
            [self.tableView reloadData];
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
        if (self.dataArray.count==0) {
            [_tableView addEmptyViewWithImageName:@"" title:@"暂无部门" Size:20.0];
            _tableView.emptyView.hidden = NO;
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
    return _daArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BranTableViewCell *cell = [[BranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[BranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = _daArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if ([_dataArray[indexPath.row] count]==1) {
        
        for ( branModel *model in  _dataArray[indexPath.row]) {
            [cell.imageVie sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,model.brandLogo]]placeholderImage:[UIImage imageNamed:@"banben100"]];
        }
    }else if ([_dataArray[indexPath.row] count]==2){
        NSMutableArray *LogoImage=[NSMutableArray array];
        for ( branModel *model in  _dataArray[indexPath.row]) {
            [LogoImage addObject:[NSString stringWithFormat:@"%@%@",KURLHeader,model.brandLogo]];
        }
        cell.imageVie.image =[self addTwoImageToOne:[UIImage imageNamed:@"bg"] twoImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[0]]]] ThreeImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[1]]]]];
    }else if ([_dataArray[indexPath.row] count]==3){
        NSMutableArray *LogoImage=[NSMutableArray array];
        for ( branModel *model in  _dataArray[indexPath.row]) {
            [LogoImage addObject:[NSString stringWithFormat:@"%@%@",KURLHeader,model.brandLogo]];
        }
        cell.imageVie.image =[self addTwoImageToOne:[UIImage imageNamed:@"bg"] twoImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[0]]]] ThreeImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[1]]]] fourImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[2]]]]];
    }else{
        NSMutableArray *LogoImage=[NSMutableArray array];
        for ( branModel *model in  _dataArray[indexPath.row]) {
            [LogoImage addObject:[NSString stringWithFormat:@"%@%@",KURLHeader,model.brandLogo]];
        }
        if (LogoImage.count>0) {
            cell.imageVie.image =[self addTwoImageToOne:[UIImage imageNamed:@"bg"] twoImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[0]]]] ThreeImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[1]]]] fourImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[2]]]]fiveImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:LogoImage[3]]]]];
        }
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *messagestr = [[NSString alloc]initWithFormat:@"是否将此内容提交到%@",_daArr[indexPath.row]];
    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:messagestr sureBtn:@"确认" cancleBtn:@"取消"];
    alertView.resultIndex = ^(NSInteger index){
        if (index == 2) {
            NSString *uStr =[NSString stringWithFormat:@"%@shop/insertStore.action",KURLHeader];
            NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
            NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
            NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
            NSDictionary *dic = [[NSDictionary alloc]init];
            dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"StoreName":self.storeName,@"Province":self.province,@"City":self.city,@"County":self.county,@"Address":self.address,@"RideInfo":self.rideinfo,@"Area":self.area,@"BrandBusiness":self.brandbusiness,@"IntentionBrand":self.intentionbrand,@"Berths":self.berths,@"ValidNumber":self.valinumber,@"StaffNumber":self.staffnumber,@"JobExpires":self.jobexpires,@"Problems":self.problems,@"DepartmentId":_ArrID[indexPath.row],@"shopId":self.shopId,@"CompanyInfoId":compid,@"RoleId":self.strId};
            [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
                if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"提交成功" sureBtn:@"确认" cancleBtn:nil];
                    alertView.resultIndex = ^(NSInteger index){
                        [ShareModel shareModel].StoreId =[responseObject valueForKey:@"id"];
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
                }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0003"]) {
                    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"已经升级为合作客户" sureBtn:@"确认" cancleBtn:nil];
                    alertView.resultIndex = ^(NSInteger index){
                        
                    };
                    [alertView showMKPAlertView];
                }
                if (self.dataArray.count==0) {
                    [_tableView addEmptyViewWithImageName:@"" title:@"暂无部门" Size:20.0];
                    _tableView.emptyView.hidden = NO;
                }
            } failure:^(NSError *error) {
                
            } view:self.view MBPro:YES];
        }
    };
    [alertView showMKPAlertView];
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
- (UIImage *)addTwoImageToOne:(UIImage *)oneImg twoImage:(UIImage *)twoImg  ThreeImage:(UIImage *)ThreeImage
{
    UIGraphicsBeginImageContext(oneImg.size);
    [oneImg drawInRect:CGRectMake(0, 0, oneImg.size.width, oneImg.size.height)];
    [twoImg drawInRect:CGRectMake(oneImg.size.width/4, 0, oneImg.size.width/2, oneImg.size.height/2)];
    [ThreeImage drawInRect:CGRectMake(oneImg.size.width/4,oneImg.size.height/2, oneImg.size.width/2, oneImg.size.height/2)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}
- (UIImage *)addTwoImageToOne:(UIImage *)oneImg twoImage:(UIImage *)twoImg  ThreeImage:(UIImage *)ThreeImage fourImage:(UIImage *)fourImage

{
    UIGraphicsBeginImageContext(oneImg.size);
    [oneImg drawInRect:CGRectMake(0, 0, oneImg.size.width, oneImg.size.height)];
    [twoImg drawInRect:CGRectMake(oneImg.size.width/4, 0, oneImg.size.width/2, oneImg.size.height/2)];
    [ThreeImage drawInRect:CGRectMake(0,oneImg.size.height/2, oneImg.size.width/2, oneImg.size.height/2)];
    [fourImage drawInRect:CGRectMake(oneImg.size.width/2,oneImg.size.height/2, oneImg.size.width/2, oneImg.size.height/2)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}
- (UIImage *)addTwoImageToOne:(UIImage *)oneImg twoImage:(UIImage *)twoImg  ThreeImage:(UIImage *)ThreeImage fourImage:(UIImage *)fourImage fiveImage:(UIImage *)fiveImage
{
    UIGraphicsBeginImageContext(oneImg.size);
    [oneImg drawInRect:CGRectMake(0, 0, oneImg.size.width, oneImg.size.height)];
    [twoImg drawInRect:CGRectMake(0, 0, oneImg.size.width/2, oneImg.size.height/2)];
    [ThreeImage drawInRect:CGRectMake(oneImg.size.width/2,0, oneImg.size.width/2, oneImg.size.height/2)];
    [fourImage drawInRect:CGRectMake(0,oneImg.size.height/2, oneImg.size.width/2, oneImg.size.height/2)];
    [fiveImage drawInRect:CGRectMake(oneImg.size.width/2,oneImg.size.height/2, oneImg.size.width/2, oneImg.size.height/2)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
