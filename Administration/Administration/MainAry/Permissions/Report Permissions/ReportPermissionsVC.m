//
//  ReportPermissionsVC.m
//  Administration
//
//  Created by 九尾狐 on 2017/4/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ReportPermissionsVC.h"
#import "GuiiiiiDView.h"
#import "ZHTBtnView.h"
#import "ReportModel.h"
@interface ReportPermissionsVC ()<UIScrollViewDelegate>
@property (strong,nonatomic)  GuiiiiiDView *guiiiiidView;


@property (strong,nonatomic)  NSMutableArray *ywAry;
@property (strong,nonatomic) NSMutableArray *topAry;
@property (strong,nonatomic) NSMutableArray *topNameAry;
@property (strong,nonatomic) NSMutableArray *numAry;
@property (strong,nonatomic) NSMutableArray *powerAry;

@end

@implementation ReportPermissionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"报表权限设置";
    self.view.backgroundColor = [UIColor whiteColor];
    _ywAry = [[NSMutableArray alloc]init];
    _topAry = [[NSMutableArray alloc]init];
     _topNameAry = [[NSMutableArray alloc]init];
    _numAry = [[NSMutableArray alloc]init];
    _powerAry = [[NSMutableArray alloc]init];
    
    [self reoirtNetWork];
    _guiiiiidView = [[GuiiiiiDView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
   
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)subLabelUI{
    
    UILabel *gouxuanLabel = [[UILabel alloc]init];
    gouxuanLabel.text = @"   请勾选报表批注权限职位";
    gouxuanLabel.textColor = GetColor(112, 112, 112, 1);
    gouxuanLabel.font = [UIFont systemFontOfSize:15.0f];
    gouxuanLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:gouxuanLabel];
    [gouxuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_offset(30);
    }];
   
    UIScrollView *backScroll = [[UIScrollView alloc]init];
    backScroll.directionalLockEnabled = YES;
    backScroll.backgroundColor = GetColor(235, 235, 235, 1);
    backScroll.delegate = self;
    backScroll.bounces = NO;
    backScroll.contentSize = CGSizeMake(self.view.frame.size.width, (180*_topAry.count)+(20*_topAry.count)+30);
    [self.view addSubview:backScroll];
    [backScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(gouxuanLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
    if (_topAry.count==0) {
        [self.view addSubview:_guiiiiidView];
    }else{
        if (_powerAry.count == 0) {
            for (int i = 0; i<_topAry.count; i++) {
                ZHTBtnView *zhtbtnview = [[ZHTBtnView alloc]initWithFrame:CGRectZero arr:_ywAry[i] coode:[_topAry[i] intValue] numarr:_numAry[i]];
                zhtbtnview.frame = CGRectMake(0,(180+20)*i, self.view.frame.size.width, 180);
                [backScroll addSubview:zhtbtnview];
            }
        }else{
            for (int i = 0; i<_topAry.count; i++) {
                ZHTBtnView *zhtbtnview = [[ZHTBtnView alloc]initWithFrame:CGRectZero arr:_ywAry[i] coode:[_topAry[i] intValue] numarr:_numAry[i] powerAry:_powerAry[i]];
                zhtbtnview.frame = CGRectMake(0,(180+20)*i, self.view.frame.size.width, 180);
                [backScroll addSubview:zhtbtnview];
        }
       
    }
    
    
    }
}
-(void)reoirtNetWork{
  

    //manager/queryPosition.action
    NSString *urlStr = [NSString stringWithFormat:@"%@manager/queryReportPosition", KURLHeader];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid};
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
       if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
           NSLog(@"%@",responseObject);
           for (NSDictionary *dic in responseObject[@"reportList"]) {
               
                ReportModel *model=[[ReportModel alloc]init];
               [model setValuesForKeysWithDictionary:dic];
                [ _topAry addObject:model.num];
               [_topNameAry addObject:model.Name];
               
               NSArray*atry =[model.power componentsSeparatedByString:@","];
               [_powerAry addObject:atry];
               
               NSMutableArray *zwArr=[NSMutableArray array];
               NSMutableArray *numArr=  [NSMutableArray array];
               
               for (NSDictionary *dict in dic[@"roleSetList"]) {
                   ReportModel *model=[[ReportModel alloc]init];
                   [model setValuesForKeysWithDictionary:dict];
                   [ zwArr addObject:model.Name];
                   [numArr addObject:model.num];
               }
               [_ywAry addObject:zwArr];
               [_numAry addObject:numArr];
           }
           [self subLabelUI];
       }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
           PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
           
           alertView.resultIndex = ^(NSInteger index){
               ViewController *loginVC = [[ViewController alloc] init];
               UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
               [self presentViewController:loginNavC animated:YES completion:nil];
           };
           [alertView showMKPAlertView];

       }else if ([[responseObject valueForKey:@"status"] isEqualToString:@"4444"]){
       [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求，未识别的设备" andInterval:1.0];
       }else if ([[responseObject valueForKey:@"status"] isEqualToString:@"1111"]){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"数据异常，操作失败" andInterval:1.0];
       }
        
        
    } failure:^(NSError *error) {
        
        
    } view:self.view MBPro:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
