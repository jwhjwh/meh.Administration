//
//  CooperationViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CooperationViewController.h"
#import "RecordTableViewCell.h"
@interface CooperationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *infonTableview;
    
}
@property (strong,nonatomic) NSMutableArray *InterNameAry;
@property (strong,nonatomic) UIButton *sousuoBtn;//搜索框
@property (strong,nonatomic) NSMutableArray *shopidAry;
@end

@implementation CooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确定合作客户";
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
    UILabel *zuijinlabel = [[UILabel alloc]init];
    zuijinlabel.text = @"最近确定合作的客户";
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
-(void)Touchsearch{
//搜索
}
-(void)selectTargetVisit{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectStoreState.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"RoleId":self.strId,@"nu":@"1",@"types":@"1"};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"list"];
            _InterNameAry = [[NSMutableArray alloc]init];
            _shopidAry= [[NSMutableArray alloc]init];
            for (NSDictionary *dic in array) {
//                tcModel *model=[[tcModel alloc]init];
//                [model setValuesForKeysWithDictionary:dic];
//                [_shopidAry addObject:[dic valueForKey:@"shopId"]];
//                [_InterNameAry addObject:model];
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
            [infonTableview addEmptyViewWithImageName:@"" title:@"暂无目标客户" Size:20.0];
            infonTableview.emptyView.hidden = NO;
        }
        
        
    } failure:^(NSError *error) {
        
        
        
    } view:self.view MBPro:YES];
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
//    tcModel *model=[[tcModel alloc]init];
//    model = _InterNameAry[indexPath.row];
//    cell.dianmingLabel.text = [NSString stringWithFormat:@"店名:%@",model.StoreName];
//    if (model.Province == nil) {
//        cell.RectordLabel.text = [NSString stringWithFormat:@"地区:%@\n地址:%@",model.City,model.County];
//    }else{
//        cell.RectordLabel.text = [NSString stringWithFormat:@"地区:%@%@\n地址:%@",model.Province,model.City,model.County];
//    }
//
//    NSString *xxsj =  [[NSString alloc]initWithFormat:@"%@", [model.Time substringWithRange:NSMakeRange(5, 11)]];
//    cell.shijianLabel.text = xxsj;
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _InterNameAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
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
