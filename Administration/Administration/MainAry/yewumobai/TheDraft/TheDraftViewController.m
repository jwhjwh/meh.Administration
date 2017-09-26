//
//  TheDraftViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/9/21.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TheDraftViewController.h"
#import "RecordTableViewCell.h"
#import "RecotdModel.h"
#import "ModifyVisitViewController.h"
@interface TheDraftViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *fonTableview;
    
}
@property (strong,nonatomic) NSMutableArray *InterNameAry;

@end

@implementation TheDraftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"草稿箱";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    
    fonTableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    fonTableview.delegate = self;
    fonTableview.dataSource = self;
    [self.view addSubview: fonTableview];
    [ZXDNetworking setExtraCellLineHidden:fonTableview];
   [self Visitnewworking];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _InterNameAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 120;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    RecordTableViewCell *cell = [fonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        cell = [[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RecotdModel *model=[[RecotdModel alloc]init];
    model = _InterNameAry[indexPath.row];
    cell.dianmingLabel.text = [NSString stringWithFormat:@"店名:%@",model.storeName];
    NSString *sj = [[NSString alloc]initWithFormat:@"%@", [model.dates substringWithRange:NSMakeRange(0, 10)]];
    cell.RectordLabel.text = [NSString stringWithFormat:@"地区:%@%@\n地址:%@\n日期:%@",model.province,model.city,model.county,sj];
    NSString *xxsj =  [[NSString alloc]initWithFormat:@"%@", [model.wtime substringWithRange:NSMakeRange(5, 11)]];
    cell.shijianLabel.text = xxsj;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecotdModel *model=[[RecotdModel alloc]init];
    model = _InterNameAry[indexPath.row];
    ModifyVisitViewController *modify = [[ModifyVisitViewController alloc]init];
    modify.ModifyId = model.Id;
    modify.strId = self.strId;
    modify.moandthe = @"1";
    [self.navigationController pushViewController:modify animated:YES];
    
}
-(void)Visitnewworking{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectWorshipRecord.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"RoleId":self.strId,@"Draft":@"0"};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"recordInfo"];
            _InterNameAry = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in array) {
                RecotdModel *model=[[RecotdModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_InterNameAry addObject:model];
            }
            [fonTableview reloadData];
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
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"草稿箱无记录" andInterval:1];
        }


    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
  
    
    
}

-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([fonTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [fonTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([fonTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [fonTableview setLayoutMargins:UIEdgeInsetsZero];
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
