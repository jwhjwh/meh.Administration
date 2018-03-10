//
//  InterestedViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/9/21.
//  Copyright © 2017年 九尾狐. All rights reserved.
//
//
#import "InterestedViewController.h"
#import "RecotdModel.h"
#import "RecordTableViewCell.h"
#import "WorshipSearchViewController.h"
//
#import "InterestedChooseViewController.h"
@interface InterestedViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *infonTableview;
    
}
@property (strong,nonatomic) NSMutableArray *InterNameAry;
@property (strong,nonatomic) NSMutableArray *shopidAry;
@property (strong,nonatomic) UIButton *sousuoBtn;//搜索框
@end

@implementation InterestedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意向客户";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    [self InterestedUI];
    [self Visitnewworking];
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
    UILabel *zuijinlabel = [[UILabel alloc]init];
    zuijinlabel.text = @"最近的意向客户";
    zuijinlabel.font = [UIFont systemFontOfSize:14];
    zuijinlabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:zuijinlabel];
    [zuijinlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view1.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor  = [UIColor lightGrayColor];
    [self.view addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(zuijinlabel.mas_bottom).offset(0);
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
        make.top.mas_equalTo(view2.mas_bottom).offset(0);
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
    RecordTableViewCell *cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    
    if (cell ==nil)
    {
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RecotdModel *model=[[RecotdModel alloc]init];
    model = _InterNameAry[indexPath.row];
    cell.dianmingLabel.text = [NSString stringWithFormat:@"店名:%@",model.storeName];
    if (model.province == nil) {
    cell.RectordLabel.text = [NSString stringWithFormat:@"地区:%@\n地址:%@",model.city,model.county];
    }else if([model.province isEqualToString:model.city]){
        cell.RectordLabel.text = [NSString stringWithFormat:@"地区:%@\n地址:%@",model.city,model.county];
    }else{
       cell.RectordLabel.text = [NSString stringWithFormat:@"地区:%@%@\n地址:%@",model.province,model.city,model.county];
    }
    
    NSString *xxsj =  [[NSString alloc]initWithFormat:@"%@", [model.dates substringWithRange:NSMakeRange(5, 11)]];
    cell.shijianLabel.text = xxsj;
    NSLog(@"----%@",model.State);
    if (model.UserId !=nil) {
        cell.UserIdLabel.text = @"已分享同事";
        cell.UserIdImage.image = [UIImage imageNamed:@"fx_ico"];
    }
    if (model.DepartmentId !=nil) {
        cell.DepartmentIdLabel.text = @"已分享部门";
        cell.DepartmentIdImage.image = [UIImage imageNamed:@"fx_icof"];
    }
    switch ([model.State integerValue]) {
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
-(void)Visitnewworking{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectIntended.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"RoleId":self.strId};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"list"];
            _InterNameAry = [[NSMutableArray alloc]init];
            _shopidAry = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in array) {
                RecotdModel *model=[[RecotdModel alloc]init];
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
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有意向客户表" andInterval:1.0];
            [infonTableview.mj_footer endRefreshingWithNoMoreData];
            
            return;
            
        }
        
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecotdModel *model=[[RecotdModel alloc]init];
    model = _InterNameAry[indexPath.row];

    InterestedChooseViewController *intabel = [[InterestedChooseViewController alloc]init];
    intabel.strIdName = model.storeName;
    intabel.strId = self.strId;
    intabel.intentionId= model.Id;
    intabel.shopId = _shopidAry[indexPath.row];
 [self.navigationController pushViewController:intabel animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)Touchsearch{
    //SearchViewController
    WorshipSearchViewController *worseaVC = [[WorshipSearchViewController alloc]init];
    worseaVC.strId = self.strId;
    worseaVC.intere = @"1";
    [self.navigationController pushViewController:worseaVC animated:YES];
}

@end
