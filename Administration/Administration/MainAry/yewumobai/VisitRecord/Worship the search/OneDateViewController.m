//
//  OneDateViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/9/20.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "OneDateViewController.h"
#import "OneDateModel.h"
#import "RecordTableViewCell.h"
#import "ModifyVisitViewController.h"
#import "StoreinforViewController.h"
@interface OneDateViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *infonTableview;
    
}
@property (nonatomic,strong)UILabel *proviceLabel;
@property (nonatomic,strong)UILabel *cityLabel;
@property (nonatomic,strong)UILabel *areaLabel;
@property (nonatomic,strong)UIButton*comBtn;
@property (nonatomic,strong)UIButton*meBtn;
@property (nonatomic,strong)NSMutableArray* InterNameAry;
@property (nonatomic,assign)int pagenum;
@end

@implementation OneDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"详细搜索";
    self.view.backgroundColor =[UIColor whiteColor];
    [self worshipSearchUI];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
}
-(void)endRefresh{
    if (_pagenum == 1) {
        [infonTableview.mj_header endRefreshing];
    }else{
        [infonTableview.mj_footer endRefreshing];
    }
    
}
-(void)worshipSearchUI{
    
    _proviceLabel = [[UILabel alloc]init];
    _proviceLabel.backgroundColor = [UIColor whiteColor];
    _proviceLabel.font = [UIFont systemFontOfSize:14];
    _proviceLabel.text = self.provice;
    _proviceLabel.adjustsFontSizeToFitWidth = YES;
    _proviceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_proviceLabel];
    
    _cityLabel = [[UILabel alloc]init];
    _cityLabel.backgroundColor = [UIColor whiteColor];
    _cityLabel.font = [UIFont systemFontOfSize:14];
    _cityLabel.text = self.city;
    _cityLabel.adjustsFontSizeToFitWidth = YES;
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_cityLabel];
    
    _areaLabel = [[UILabel alloc]init];
    _areaLabel.backgroundColor = [UIColor whiteColor];
    _areaLabel.text = self.area;
    _areaLabel.font = [UIFont systemFontOfSize:14];
    _areaLabel.adjustsFontSizeToFitWidth = YES;
    _areaLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_areaLabel];
    
    _meBtn = [[UIButton alloc]init];
    _meBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_meBtn setTitle:@"我的" forState:UIControlStateNormal];
     _meBtn.backgroundColor =GetColor(203, 176, 219, 1);
    [_meBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_meBtn addTarget:self action:@selector(TouchsearchMe:)forControlEvents:UIControlEventTouchUpInside];
    [_meBtn.layer setMasksToBounds:YES];
    [_meBtn.layer setCornerRadius:1.0]; //设置矩圆角半径
    [_meBtn.layer setBorderWidth:1.0];   //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 218/255.0, 219/255.0, 219/255.0, 1 });
    [_meBtn.layer setBorderColor:colorref];//边框颜色
    [self.view addSubview:_meBtn];
    
    _comBtn = [[UIButton alloc]init];
    _comBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_comBtn setTitle:@"公司" forState:UIControlStateNormal];
    [_comBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_comBtn addTarget:self action:@selector(TouchsearchCom:)forControlEvents: UIControlEventTouchUpInside];
    [_comBtn.layer setMasksToBounds:YES];
    [_comBtn.layer setCornerRadius:1.0]; //设置矩圆角半径
    [_comBtn.layer setBorderWidth:1.0];
    
    [_comBtn.layer setBorderColor:colorref];//边框颜色
    [self.view addSubview:_comBtn];
    
    NSString* phoneModel = [UIDevice devicePlatForm];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        _proviceLabel.frame = CGRectMake(0, 88, self.view.frame.size.width/3, 30);
        _cityLabel.frame = CGRectMake(self.view.frame.size.width/3, 88, self.view.frame.size.width/3, 30);
        _areaLabel.frame = CGRectMake((self.view.frame.size.width/3)*2, 88, self.view.frame.size.width/3, 30);
        _meBtn.frame =CGRectMake(-1, 118, self.view.frame.size.width/2, 40);
        _comBtn.frame =CGRectMake((self.view.frame.size.width/2)-2, 118, (self.view.frame.size.width/2)+3, 40);
    }else{
        _proviceLabel.frame = CGRectMake(0, 64, self.view.frame.size.width/3, 30);
        _cityLabel.frame = CGRectMake(self.view.frame.size.width/3, 64, self.view.frame.size.width/3, 30);
        _areaLabel.frame = CGRectMake((self.view.frame.size.width/3)*2, 64, self.view.frame.size.width/3, 30);
        _meBtn.frame =CGRectMake(-1, 94, self.view.frame.size.width/2, 40);
        _comBtn.frame =CGRectMake((self.view.frame.size.width/2)-2, 94, (self.view.frame.size.width/2)+3, 40);
    }
    
    
    
    infonTableview =[[UITableView alloc]init];
    infonTableview.delegate = self;
    infonTableview.dataSource = self;
    [self.view addSubview: infonTableview];
    [ZXDNetworking setExtraCellLineHidden:infonTableview];
    
    [infonTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_comBtn.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
    [self OneDateNetworking:_meBtn];
    __weak typeof(self) weakSelf = self;
    //默认【下拉刷新】
    infonTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //_dataArray = [NSMutableArray array];
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
    OneDateModel *model=[[OneDateModel alloc]init];
    model = _InterNameAry[indexPath.row];
    cell.dianmingLabel.text = [NSString stringWithFormat:@"店名:%@",model.StoreName];
    cell.RectordLabel.text = [NSString stringWithFormat:@"地址:%@%@%@",model.Province,model.City,model.County];
    cell.RectordLabel.adjustsFontSizeToFitWidth = YES;
    cell.RectordLabel.textAlignment = NSTextAlignmentLeft;
    NSString *xxsj = [[NSString alloc]init];
    if ([self.tvvc isEqualToString:@"3"]) {
        xxsj =  [[NSString alloc]initWithFormat:@"%@", [model.dates substringWithRange:NSMakeRange(5, 11)]];
    }else{
        xxsj =  [[NSString alloc]initWithFormat:@"%@", [model.wtime substringWithRange:NSMakeRange(5, 11)]];
    }
   
    cell.shijianLabel.text = xxsj;
    
    return cell;
}

-(void)TouchsearchMe:(UIButton *)meBtn{
    NSLog(@"点我");
    meBtn.backgroundColor =GetColor(203, 176, 219, 1);
    _comBtn.backgroundColor = [UIColor whiteColor];
    _pagenum = 1;
    [self OneDateNetworking:meBtn];
}

-(void)TouchsearchCom:(UIButton *)comBtn{
    comBtn.backgroundColor = GetColor(203, 176, 219, 1);
    _meBtn.backgroundColor = [UIColor whiteColor];
    [self OneDateNetworking:comBtn];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getNetworkData:(BOOL)isRefresh{
    if (isRefresh) {
        _pagenum = 1;
    }else{
        _pagenum++;
    }
    [self OneDateNetworking:_meBtn];
}
-(void)OneDateNetworking :(UIButton*)btn{
    //selectStoreState 公司 selectStoreState
    
    NSString *uuStr =[[NSString alloc]init];
    
    if ([self.tvvc isEqualToString:@"3"]) {
        uuStr = [NSString stringWithFormat:@"%@shop/selectStoreState.action",KURLHeader];
    }else{
        uuStr =[NSString stringWithFormat:@"%@shop/selectWorshipRecord.action",KURLHeader];
    }
    NSString *pageStr=[NSString stringWithFormat:@"%d",_pagenum];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    if ([self.tvvc isEqualToString:@"3"]) {
        //确定合作客户
        if ([btn.titleLabel.text isEqualToString:@"我的"]) {
            dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"RoleId":self.strId,@"province":self.provice,@"city":self.city,@"county":self.area,@"types":@"1",@"nu":pageStr};
        }else{
            dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"RoleId":self.strId,@"province":self.provice,@"city":self.city,@"county":self.area,@"types":@"2",@"CompanyInfoId":[USER_DEFAULTS objectForKey:@"companyinfoid"],@"nu":pageStr};
        }
    }else{
        //陌拜记录
        if ([btn.titleLabel.text isEqualToString:@"我的"]) {
            dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"RoleId":self.strId,@"province":self.provice,@"city":self.city,@"county":self.area,@"Types":@"1",@"nu":pageStr};
        }else{
            dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"RoleId":self.strId,@"province":self.provice,@"city":self.city,@"county":self.area,@"Types":@"2",@"CompanyInfoId":[USER_DEFAULTS objectForKey:@"companyinfoid"],@"nu":pageStr};
        }
    }
    
    [ZXDNetworking GET:uuStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
        //recordInfo
            NSArray *array=[[NSArray alloc]init];
            if ([self.tvvc isEqualToString:@"3"]) {
                array=[responseObject valueForKey:@"list"];
            }else{
                array=[responseObject valueForKey:@"recordInfo"];
            }
            _InterNameAry = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in array) {
                OneDateModel *model=[[OneDateModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
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
            [infonTableview addEmptyViewWithImageName:@"" title:@"该地区暂无客户" Size:20.0];
            infonTableview.emptyView.hidden = NO;
        
        }

    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _InterNameAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OneDateModel *model=[[OneDateModel alloc]init];
    model = _InterNameAry[indexPath.row];
    
    if ([self.tvvc isEqualToString:@"3"]) {
        StoreinforViewController *storeVC = [[StoreinforViewController alloc]init];
        storeVC.shopId =model.ShopId;
        storeVC.strId = self.strId;
        storeVC.isend = NO;
        storeVC.titleName = model.StoreName;
        [self.navigationController pushViewController:storeVC animated:YES];
    }else{
        ModifyVisitViewController *modify = [[ModifyVisitViewController alloc]init];
        modify.ModifyId = model.ShopId;
        modify.strId = self.strId;
        NSString *userid =[USER_DEFAULTS objectForKey:@"userid"];
        int ivalue = [model.usersId intValue];
        NSString *modeluserid =[NSString stringWithFormat:@"%d",ivalue];
        if ([modeluserid isEqualToString:userid]) {
            
            [self.navigationController pushViewController:modify animated:YES];
        }else{
            //
            NSString *uuStr =[[NSString alloc]init];
            uuStr =[NSString stringWithFormat:@"%@shop/selectWorshipRecord.action",KURLHeader];
            NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
            NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
            NSDictionary *dic = [[NSDictionary alloc]init];
            dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"RoleId":self.strId,@"province":self.provice,@"city":self.city,@"county":self.area,@"Type":@"2",@"CompanyInfoId":[USER_DEFAULTS objectForKey:@"companyinfoid"],@"WorshipRecordId":model.ShopId};
            //[ZXDNetworking GET:uuStr parameters:dic success:^(id responseObject) {
            [ZXDNetworking GET:uuStr parameters:dic success:^(id responseObject) {
                if ([[responseObject valueForKey:@"status"]isEqualToString:@"0003"]) {
                    //recordInfo
                    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"您没有权限查看该记录" sureBtn:@"确认" cancleBtn:nil];
                    alertView.resultIndex = ^(NSInteger index){
                        
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
                }else if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
                    _InterNameAry = [[NSMutableArray alloc]init];
                    [infonTableview reloadData];
                    [ELNAlerTool showAlertMassgeWithController:self andMessage:@"该地区无陌拜记录" andInterval:1];
                } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                    //有权限查看返回详情
                     NSArray *arry=[responseObject valueForKey:@"recordInfo"];
                    modify.one_arry = arry;
                    modify.andisofyou =@"2";
                    NSString *stringInt=[responseObject valueForKey:@"Authority"];
                    int ivalue = [stringInt intValue];
                    NSString *string = [NSString stringWithFormat:@"%d",ivalue];
                    modify.one_Authority =string;
                    [self.navigationController pushViewController:modify animated:YES];
                }
            } failure:^(NSError *error) {
                
            } view:self.view MBPro:YES];
        }
        //
    }
    
    
    
}

@end
