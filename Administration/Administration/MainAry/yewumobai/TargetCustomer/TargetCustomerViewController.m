//
//  TargetCustomerViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/10/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "TargetCustomerViewController.h"
#import "tcModel.h"
#import "RecordTableViewCell.h"
#import "WorshipSearchViewController.h"//搜索
#import "DeterMineTcViewController.h"
@interface TargetCustomerViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *infonTableview;
    
}
@property (strong,nonatomic) NSMutableArray *InterNameAry;
@property (strong,nonatomic) UIButton *sousuoBtn;//搜索框
@property (strong,nonatomic) NSMutableArray *shopidAry;
@end

@implementation TargetCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"目标客户";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    [self InterestedUI];
    [self selectTargetVisit];
}
-(void)InterestedUI{
    NSString* phoneModel = [UIDevice devicePlatForm];
    _sousuoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *imageBtn = [UIImage imageNamed:@"ss_ico01"];
    [_sousuoBtn setBackgroundImage:imageBtn forState:UIControlStateNormal];
    //防止图片变灰
    _sousuoBtn.adjustsImageWhenHighlighted = NO;
    _sousuoBtn.layer.masksToBounds = YES;
    _sousuoBtn.layer.cornerRadius = 8.0;
    [_sousuoBtn addTarget:self action:@selector(Touchsearch)forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:_sousuoBtn];
    [_sousuoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
            make.top.mas_equalTo(self.view.mas_top).offset(94);
        }else{
            make.top.mas_equalTo(self.view.mas_top).offset(70);
        }
        
        make.height.mas_equalTo(40);
    }];
    
    
    
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_sousuoBtn.mas_bottom).offset(5);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.height.mas_offset(1);
    }];
    
    
    infonTableview =[[UITableView alloc]init];
    infonTableview.delegate = self;
    infonTableview.dataSource = self;
    [self.view addSubview: infonTableview];
    [ZXDNetworking setExtraCellLineHidden:infonTableview];
    
    [infonTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view1.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
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
    RecordTableViewCell *cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        cell = [[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tcModel *model=[[tcModel alloc]init];
    model = _InterNameAry[indexPath.row];
    cell.dianmingLabel.text = [NSString stringWithFormat:@"店名:%@",model.StoreName];
    if (model.Province == nil) {
        cell.RectordLabel.text = [NSString stringWithFormat:@"地区:%@\n地址:%@",model.City,model.County];
    }else{
        cell.RectordLabel.text = [NSString stringWithFormat:@"地区:%@%@\n地址:%@",model.Province,model.City,model.County];
    }
    
    NSString *xxsj =  [[NSString alloc]initWithFormat:@"%@", [model.Time substringWithRange:NSMakeRange(5, 11)]];
    cell.shijianLabel.text = xxsj;
    if (model.UserId !=nil) {
        cell.UserIdLabel.text = @"已分享同事";
        cell.UserIdImage.image = [UIImage imageNamed:@"fx_ico"];
    }
    if (model.DepartmentId !=nil) {
        cell.DepartmentIdLabel.text = @"已分享部门";
        cell.DepartmentIdImage.image = [UIImage imageNamed:@"fx_icof"];
    }
    
    switch ([model.State integerValue]) {
        case 1:
            break;
        case 2:
            cell.StateLabel.text= @"已升级为意向客户";
            cell.StateImage.image = [UIImage imageNamed:@"tj__ico01"];
            break;
        case 3:
            cell.StateLabel.text= @"已升级为目标客户";
            cell.StateImage.image = [UIImage imageNamed:@"tj__ico02"];
            break;
        case 4:
            cell.StateLabel.text= @"已升级为合作客户";
            cell.StateImage.image = [UIImage imageNamed:@"tj_ico03"];
            break;
            
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tcModel *model=[[tcModel alloc]init];
    model = _InterNameAry[indexPath.row];
    DeterMineTcViewController *dTcVC = [[DeterMineTcViewController alloc]init];
    dTcVC.TargetVisitId = model.Id;
    dTcVC.strId = self.strId;
    dTcVC.shopname =model.StoreName;
    dTcVC.shopId = _shopidAry[indexPath.row];
    [self.navigationController pushViewController:dTcVC animated:YES];
}
-(void)Touchsearch{
    
    WorshipSearchViewController *worseaVC = [[WorshipSearchViewController alloc]init];
    worseaVC.strId = self.strId;
    worseaVC.intere = @"2";
    [self.navigationController pushViewController:worseaVC animated:YES];
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
-(void)selectTargetVisit{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectTargetVisit.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"RoleId":self.strId};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"list"];
            _InterNameAry = [[NSMutableArray alloc]init];
            _shopidAry= [[NSMutableArray alloc]init];
            for (NSDictionary *dic in array) {
                tcModel *model=[[tcModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_shopidAry addObject:[dic valueForKey:@"shopId"]];
                [_InterNameAry addObject:model];
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
            [infonTableview.mj_footer endRefreshingWithNoMoreData];
            [infonTableview addEmptyViewWithImageName:@"" title:@"暂无目标客户" Size:20.0];
            infonTableview.emptyView.hidden = NO;
        }
        
        
    } failure:^(NSError *error) {
        
        
        
    } view:self.view MBPro:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
