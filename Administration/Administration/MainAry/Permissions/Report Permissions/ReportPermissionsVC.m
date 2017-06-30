//
//  ReportPermissionsVC.m
//  Administration
//
//  Created by 九尾狐 on 2017/4/12.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ReportPermissionsVC.h"
#import "ZHTBtnView.h"
#import "ReportModel.h"
#define WIDTHh [UIScreen mainScreen].bounds.size.width
#define HEIGHTt [UIScreen mainScreen].bounds.size.height
@interface ReportPermissionsVC ()<UIScrollViewDelegate>

@property (strong,nonatomic)  NSMutableArray *ywAry;
@property (strong,nonatomic) NSMutableArray *topAry;
@property (strong,nonatomic) NSMutableArray *topNameAry;
@property (strong,nonatomic) NSMutableArray *numAry;
@property (strong,nonatomic) NSMutableArray *powerAry;


@property (strong,nonatomic) UILabel *neiRLabel;
@property (strong,nonatomic) UILabel *biaoLabel;
@property (strong,nonatomic) UIImageView *imageview1;
@property (strong,nonatomic) UIButton *XYBBtn;
@property (strong,nonatomic) UIView *view1;
@property (assign,nonatomic)  int acode;

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
    
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"guiiiii"]];
    if ([companyinfoid isEqualToString:@"1"]) {
        [self guiiii];
    
    }else{
        [self reoirtNetWork];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
}
-(void)guiiii{
    _acode = 1;
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTHh, HEIGHTt)];
    //_view1.backgroundColor = GetColor(127, 127, 127, 0.8);
    [self.view addSubview:_view1];
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTHh, HEIGHTt)];
    backImage.image = [UIImage imageNamed:@"报表权限02"];
    [_view1 addSubview:backImage];
    
    _imageview1 = [[UIImageView alloc]init];
    _imageview1.image = [UIImage imageNamed:@"bg_mt01"];
    [_view1 addSubview:_imageview1];
    [_imageview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_view1.mas_centerY).offset(-80);
        make.left.mas_equalTo(_view1.mas_left).offset(50);
        make.right.mas_equalTo(_view1.mas_right).offset(-50);
        make.height.mas_equalTo(120);
    }];
    
    _biaoLabel = [[UILabel alloc]init];
    _biaoLabel.text = @"报表批注权限解析";
    _biaoLabel.font = [UIFont systemFontOfSize:17.0f];
    _biaoLabel.textAlignment = NSTextAlignmentCenter;
    [_view1 addSubview:_biaoLabel];
    [_biaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageview1.mas_top).offset(10);
        make.left.mas_equalTo(_imageview1.mas_left).offset(10);
        make.right.mas_equalTo(_imageview1.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    _neiRLabel = [[UILabel alloc]init];
    _neiRLabel.text = @"只有被授予权限的职位才可以进行对报表的批注，没有授予权限的职位不能对报表进行批注只能看";
    _neiRLabel.font = [UIFont systemFontOfSize:15.0f];
    _neiRLabel.numberOfLines = 0;
    _neiRLabel.textColor=  GetColor(112, 112, 112, 1);
    [_view1 addSubview:_neiRLabel];
    [_neiRLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_biaoLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(_imageview1.mas_left).offset(20);
        make.right.mas_equalTo(_imageview1.mas_right).offset(-20);
        make.bottom.mas_equalTo(_imageview1.mas_bottom).offset(-10);
    }];
    _XYBBtn = [[UIButton alloc]init];
    [_XYBBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _XYBBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    _XYBBtn.layer.borderWidth = 1.0f;
    _XYBBtn.layer.cornerRadius = 15.0f;
    _XYBBtn.backgroundColor = [UIColor clearColor];
    _XYBBtn.layer.masksToBounds = YES;
    [_XYBBtn addTarget:self
                action:@selector(BtnClick)
      forControlEvents:UIControlEventTouchUpInside];
    [_view1 addSubview:_XYBBtn];
    [_XYBBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageview1.mas_bottom).offset(20);
        make.centerX.mas_equalTo(_imageview1.mas_centerX).offset(0);
        make.width.mas_offset(100);
        make.height.mas_offset(30);
    }];

}
-(void)BtnClick{
    switch (_acode) {
        case 1:{
            _imageview1.image = [UIImage imageNamed:@"bg_mt02"];
            _biaoLabel.text = @"例:";
            _neiRLabel.text = @"业务写的报表只有被授予权限的业务经理和行政管理职位所进行批注而其他职位只能查看不能进行批注\n\n";
            [_imageview1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_view1.mas_top).offset(231);
                make.left.mas_equalTo(_view1.mas_left).offset(50);
                make.right.mas_equalTo(_view1.mas_right).offset(-50);
                make.height.mas_equalTo(170);
            }];
            [_biaoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_imageview1.mas_top).offset(40);
                make.left.mas_equalTo(_imageview1.mas_left).offset(10);
                make.right.mas_equalTo(_imageview1.mas_right).offset(-10);
                make.height.mas_equalTo(20);
            }];
            [_neiRLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_biaoLabel.mas_bottom).offset(10);
                make.left.mas_equalTo(_imageview1.mas_left).offset(20);
                make.right.mas_equalTo(_imageview1.mas_right).offset(-20);
                make.bottom.mas_equalTo(_imageview1.mas_bottom).offset(-10);
            }];
            [_XYBBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_imageview1.mas_bottom).offset(20);
                make.centerX.mas_equalTo(_imageview1.mas_centerX).offset(0);
                make.width.mas_offset(100);
                make.height.mas_offset(30);
            }];
        }
            _acode=2;
            NSLog(@"%d",_acode);
            break;
        case 2:{
            _acode= 3;
            _imageview1.image = [UIImage imageNamed:@"bg_mt01"];
            [_biaoLabel removeFromSuperview];
            _neiRLabel.text = @"只有被勾选的职位才有对报表批注的权限呦！马上去勾选吧！！！\n\n";
            [_XYBBtn setTitle:@"马上去" forState:UIControlStateNormal];
            [_imageview1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_view1.mas_centerY).offset(-80);
                make.left.mas_equalTo(_view1.mas_left).offset(50);
                make.right.mas_equalTo(_view1.mas_right).offset(-50);
                make.height.mas_equalTo(80);
                
            }];
            [_neiRLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_imageview1.mas_top).offset(10);
                make.left.mas_equalTo(_imageview1.mas_left).offset(20);
                make.right.mas_equalTo(_imageview1.mas_right).offset(-20);
                make.height.mas_equalTo(80);
                
            }];
            NSLog(@"acode=3");
        }
            break;
        case 3:{
            NSLog(@"马上去");
            [USER_DEFAULTS setObject:@"2"forKey:@"guiiiii"];
            [_view1 removeFromSuperview];
            [self reoirtNetWork];
        }
            break;
        default:
            break;
    }
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
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"您还没有创建职位，快去创建职位吧" andInterval:1.0];
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
           for (NSDictionary *dic in responseObject[@"reportList"]) {
                ReportModel *model=[[ReportModel alloc]init];
               [model setValuesForKeysWithDictionary:dic];
                [ _topAry addObject:model.num];
               [_topNameAry addObject:model.Name];
               
               if (model.power.length == 0) {
                   NSString *strUrl = @"0";
                   NSArray*atry =[strUrl componentsSeparatedByString:@","];
                   [_powerAry addObject:atry];
               }else{
                   NSString *strUrl = [model.power stringByReplacingOccurrencesOfString:@" " withString:@""];
                   NSArray*atry =[strUrl componentsSeparatedByString:@","];
                   [_powerAry addObject:atry];
               }
               
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
