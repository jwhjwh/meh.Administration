//
//  MainViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "MainViewController.h"
#import "GonggaoxqController.h"
#import "EditDataViewController.h"
#import "PermissionsViewController.h"
#import "SubmittedViewController.h"//图片报岗
#import "businessViewController.h"//业务陌拜
#import "TrackingViewController.h"
#import "brandViewController.h"
#import "ViewControllerEmployeeTable.h"//报表管理
#import "ViewControllerChoosePosition.h"//选择职位
#import "ManageViewController.h"//员工管理

#import "MessageController.h"
#import "XLsn0wLoop.h"
#import "MenuCell.h"
#import "NoticeView.h"
#import "SetModel.h"

#define MenuH 270
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,XLsn0wLoopDelegate>
///头像
@property (nonatomic,retain)UIButton *logoImage;
///消息按钮
@property (nonatomic,retain)UIButton *masgeButton;
///消息数量
@property (nonatomic,retain)UILabel *numberLabel;
///轮播图
@property (nonatomic, strong) XLsn0wLoop *loop;
///公告
@property (nonatomic, strong) NoticeView *noticeView ;
///主题
@property(nonatomic,strong)UITableView *tableView;
///主题数组设置
@property(nonatomic,strong)NSMutableArray *menuArray;
//标题名
@property(nonatomic,strong)NSMutableArray *arr;
//标题图片
@property(nonatomic,strong)NSMutableArray *arr1;
//标识
@property(nonatomic,strong)NSMutableArray *arrLogo;
//判断红的消息
@property(nonatomic,retain)NSString *number;
@end

@implementation MainViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self naveigtionAddSubView];
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_logoImage  removeFromSuperview];
    [_masgeButton removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initData];
   //[self addLoop];
    _menuArray=[NSMutableArray array];
}


-(void)naveigtionAddSubView{
    self.title=@"首页";
    self.automaticallyAdjustsScrollViewInsets=NO;
    _logoImage = [UIButton buttonWithType:UIButtonTypeCustom] ;
    _logoImage.frame =CGRectMake(12,4,36,36);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_logoImage.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii: _logoImage.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = _logoImage.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    _logoImage.layer.mask = maskLayer;
     NSString *logoStr = [USER_DEFAULTS  objectForKey:@"logoImage"];
   [_logoImage sd_setBackgroundImageWithURL:[NSURL URLWithString:logoStr] forState:UIControlStateNormal placeholderImage:[UIImage  imageNamed:@"tx23"]options:EMSDWebImageRefreshCached];
    [_logoImage addTarget:self action:@selector(xinxiTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_logoImage];
   
    _masgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _masgeButton.frame = CGRectMake(Scree_width - 12-36,4,36,36);
    //防止图片变灰
    _masgeButton.adjustsImageWhenHighlighted = NO;
    [_masgeButton addTarget:self action:@selector(masgeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_masgeButton setImage:[UIImage imageNamed:@"xx_ico1"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:_masgeButton];
    _numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(_masgeButton.frame.size.width-6,1, 10, 10)];
    _numberLabel.layer.masksToBounds = YES;
    //设置圆角半径
    if ([_number isEqualToString: @"1" ]) {
    _numberLabel.backgroundColor=[UIColor redColor];
    }
    _numberLabel.layer.cornerRadius =5.0f;
    [_masgeButton addSubview:_numberLabel];
    
    [ShareModel shareModel].roleID = [NSString stringWithFormat:@"%@",[USER_DEFAULTS valueForKey:@"roleId"]];
}
-(void)initData
{
    
    NSString *urlStr =[NSString stringWithFormat:@"%@user/querylogoImg.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"comId":compid};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        //NSLog(@"00-----%@",responseObject);
    if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
      NSArray *arr= [responseObject valueForKey:@"logoImg"];
        NSMutableArray *array=[NSMutableArray array];
        for (NSDictionary *dic in arr) {
            NSString *Url= [NSString stringWithFormat:@"%@%@",KURLHeader,[dic valueForKey:@"url"]];
            [array addObject:Url];
        }
    
        NSArray *listarr= [responseObject valueForKey:@"list"];
        for (NSDictionary *ditList in listarr) {
            SetModel *model=[[SetModel alloc]init];
            [model setValuesForKeysWithDictionary:ditList];
            
            ZYJHeadLineModel *model2 = [[ZYJHeadLineModel alloc]init];
            [model2 setValuesForKeysWithDictionary:ditList];
            model2.type  = [NSString stringWithFormat:@"%@%@",KURLHeader,model.image];
            model2.title = model.name;
            model2.teeeg = model.locational;
            [_menuArray addObject:model2];
            //cc
            
        }
        [self addLoop];
         self.loop.imageArray=array;
    
        
        
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
        }else{
             [ELNAlerTool showAlertMassgeWithController:self andMessage:@"网络错误" andInterval:1.0];
            [self initData];
        }

    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
    NSString *uStr =[NSString stringWithFormat:@"%@marketReport/queryNewSum.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"]};
    
        [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
            if ([[responseObject valueForKey:@"message"]isEqualToString:@"1"]) {
                _number=@"1";
                _numberLabel.backgroundColor=[UIColor redColor];
            } else {
                _numberLabel.backgroundColor=[UIColor clearColor];
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];

}

-(void)addLoop {
    
    //轮播图
    self.loop = [[XLsn0wLoop alloc] init];
    self.loop.xlsn0wDelegate = self;
    self.loop.time = 2;
    [self.loop setPageColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1] andCurrentPageColor:[UIColor whiteColor]];
    [self.view addSubview:self.loop];
    //主题内容
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.scrollEnabled =NO; //设置tableview 不能滚动
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉下滑线
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.loop.mas_bottom);
        if(_menuArray.count<5){
            make.height.mas_offset(90);
        }else if(_menuArray.count>8){
            
            make.height.mas_equalTo(MenuH);
        }else{
            make.height.mas_offset(180);
        }
        
    }];

    
    [self.loop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.29f);
    }];
    
    //公告
    _noticeView=[[NoticeView alloc]initWithFrame:CGRectMake(15, self.loop.bottom+_tableView.height+10, Scree_width-30, 80)];
    [self.view addSubview:_noticeView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noticeTap:)];
    [_noticeView addGestureRecognizer:tap];
    __weak __typeof(self)weakSelf = self;
    _noticeView.TopLineView.clickBlock = ^(NSInteger index){
        GonggaoxqController *gongVC=[[GonggaoxqController alloc]init];
        [weakSelf.navigationController pushViewController:gongVC animated:YES];
        
    };
       [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.right.mas_equalTo(self.view.mas_right).offset(-12);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(15);
           
           if (_menuArray.count<9) {
               make.height.mas_offset(kHeight*150);
           }else if(_menuArray.count>8){
               make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
           }
        
    }];
  
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MenuH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier=@"MenuCell";
    MenuCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell==nil) {
        cell=[[MenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier menuArray:_menuArray];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.resultBLock = ^(NSInteger index){
        switch (index) {
            case 1:{
                //权限管理
                PermissionsViewController *perVC  =[[PermissionsViewController alloc]init];
                 [self.navigationController pushViewController:perVC animated:YES];
            }
                break;
            case 2:{
                //员工管理
                ManageViewController *manVC = [[ManageViewController  alloc]init];
                [self.navigationController pushViewController:manVC animated:YES];
            }
                break;
            case 3:{
                //待办事项
                
            }
                break;
            case 4:{
                //图片报岗
                SubmittedViewController *subVC = [[SubmittedViewController alloc]init];
                [self.navigationController pushViewController:subVC animated:YES];
            }
                break;
            case 5:
                //我的报表
                break;
            case 6:
                //报表管理
            {
                NSArray *arrayIds = [USER_DEFAULTS valueForKey:@"myRole"];
                if (arrayIds.count>1) {
                    ViewControllerChoosePosition *vc = [[ViewControllerChoosePosition alloc]init];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else
                {
                ViewControllerEmployeeTable *vc = [[ViewControllerEmployeeTable alloc]init];
                self.hidesBottomBarWhenPushed = YES;
                vc.myRoleid = [USER_DEFAULTS valueForKey:@"roleId"];
                [self.navigationController pushViewController:vc animated:YES];
                }
            }
                
                break;
            case 7:{
                //业务陌拜
                businessViewController *busVC = [[businessViewController alloc]init];
                [self.navigationController pushViewController:busVC animated:YES];
            }
                break;
            case 8:
                //店家信息
                break;
            case 9:{
                //店家跟踪
                TrackingViewController *traVC = [[TrackingViewController alloc]init];
                [self.navigationController pushViewController:traVC animated:YES];
                
            }
                break;
            case 10:
                //生日提醒
                break;
            case 11:{
                //公司公告
                GonggaoxqController *ggVC = [[GonggaoxqController alloc]init];
                [self.navigationController pushViewController:ggVC animated:YES];
            }
                break;
            case 12:
                //陌拜管理
                break;
                
            default:
                break;
        }
    
    };
    return cell;
}
#pragma mark XRCarouselViewDelegate
- (void)loopView:(XLsn0wLoop *)loopView clickImageAtIndex:(NSInteger)index {
    NSLog(@"点击了第%ld张图片", index);
}
-(void)masgeClick:(UIButton*)sender{
  
    MessageController *MessageVC=[[MessageController alloc]init];
    [self.navigationController pushViewController:MessageVC animated:YES];
}
//公告
-(void)noticeTap:(UITapGestureRecognizer*)sender{
    GonggaoxqController *gongVC=[[GonggaoxqController alloc]init];
    [self.navigationController pushViewController:gongVC animated:YES];
}
//个人信息
-(void)xinxiTap:(UIButton *)sender{
    EditDataViewController *editVC=[[EditDataViewController alloc]init];
    [self.navigationController pushViewController:editVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
