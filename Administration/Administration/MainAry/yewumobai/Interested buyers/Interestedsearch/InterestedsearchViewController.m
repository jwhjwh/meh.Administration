//
//  InterestedsearchViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/9/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "InterestedsearchViewController.h"
#import "OneDateModel.h"
#import "RecordTableViewCell.h"
#import "InterestedChooseViewController.h"
@interface InterestedsearchViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *infonTableview;
    
}
@property (nonatomic,strong)UILabel *proviceLabel;
@property (nonatomic,strong)UILabel *cityLabel;
@property (nonatomic,strong)UILabel *areaLabel;
@property (nonatomic,strong)UIButton*comBtn;
@property (nonatomic,strong)UIButton*meBtn;
@property (nonatomic,strong)NSMutableArray* InterNameAry;


@end

@implementation InterestedsearchViewController

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
-(void)worshipSearchUI{
    
    _proviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width/3, 30)];
    _proviceLabel.backgroundColor = [UIColor whiteColor];
    _proviceLabel.font = [UIFont systemFontOfSize:14];
    _proviceLabel.text = self.provice;
    _proviceLabel.adjustsFontSizeToFitWidth = YES;
    _proviceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_proviceLabel];
    
    _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3, 64, self.view.frame.size.width/3, 30)];
    _cityLabel.backgroundColor = [UIColor whiteColor];
    _cityLabel.font = [UIFont systemFontOfSize:14];
    _cityLabel.text = self.city;
    _cityLabel.adjustsFontSizeToFitWidth = YES;
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_cityLabel];
    
    _areaLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width/3)*2, 64, self.view.frame.size.width/3, 30)];
    _areaLabel.backgroundColor = [UIColor whiteColor];
    _areaLabel.text = self.area;
    _areaLabel.font = [UIFont systemFontOfSize:14];
    _areaLabel.adjustsFontSizeToFitWidth = YES;
    _areaLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_areaLabel];
    
    _meBtn = [[UIButton alloc]initWithFrame:CGRectMake(-1, 94, self.view.frame.size.width/2, 40)];
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
    
    _comBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-2, 94, (self.view.frame.size.width/2)+3, 40)];
    _comBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_comBtn setTitle:@"同事分享" forState:UIControlStateNormal];
    [_comBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_comBtn addTarget:self action:@selector(TouchsearchCom:)forControlEvents: UIControlEventTouchUpInside];
    [_comBtn.layer setMasksToBounds:YES];
    [_comBtn.layer setCornerRadius:1.0]; //设置矩圆角半径
    [_comBtn.layer setBorderWidth:1.0];
    
    [_comBtn.layer setBorderColor:colorref];//边框颜色
    [self.view addSubview:_comBtn];
    
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
    NSString *xxsj =  [[NSString alloc]initWithFormat:@"%@", [model.dates substringWithRange:NSMakeRange(5, 11)]];
    cell.shijianLabel.text = xxsj;
    
    return cell;
}
-(void)TouchsearchMe:(UIButton *)meBtn{
    NSLog(@"点我");
    meBtn.backgroundColor =GetColor(203, 176, 219, 1);
    _comBtn.backgroundColor = [UIColor whiteColor];
    [self OneDateNetworking:meBtn];
}

-(void)TouchsearchCom:(UIButton *)comBtn{
    comBtn.backgroundColor = GetColor(203, 176, 219, 1);
    _meBtn.backgroundColor = [UIColor whiteColor];
    [self OneDateNetworking:comBtn];
    
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)OneDateNetworking :(UIButton*)btn{
    NSString *uuStr =[NSString stringWithFormat:@"%@shop/selectIntended.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    if ([btn.titleLabel.text isEqualToString:@"我的"]) {
        dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"RoleId":self.strId,@"province":self.provice,@"city":self.city,@"county":self.area,@"Type":@"1"};
    }else{
        dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"RoleId":self.strId,@"province":self.provice,@"city":self.city,@"county":self.area,@"Type":@"2",@"CompanyInfoId":[USER_DEFAULTS objectForKey:@"companyinfoid"]};
    }
    [ZXDNetworking GET:uuStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            //recordInfo
            NSArray *array=[responseObject valueForKey:@"list"];
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
            _InterNameAry = [[NSMutableArray alloc]init];
            [infonTableview reloadData];
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"该地区无意向客户" andInterval:1];
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
    InterestedChooseViewController *intereVC = [[InterestedChooseViewController alloc]init];
    intereVC.strIdName = model.StoreName;
    intereVC.strId = self.strId;
    
    [self.navigationController pushViewController:intereVC animated:YES];

    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
