//
//  MainViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "MainViewController.h"
#import "GonggaoxqController.h"
#import "MessageController.h"
#import "XLsn0wLoop.h"
#import "MenuCell.h"
#import "NoticeView.h"
#define MenuH 160
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,XLsn0wLoopDelegate>
///头像
@property (nonatomic,retain)UIImageView *logoImage;
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
@property(nonatomic,strong)NSArray *arr;
//标题图片
@property(nonatomic,strong)NSArray *arr1;
//判断红的消息
@property(nonatomic,retain)NSString *number;
@end

@implementation MainViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self naveigtionAddSubView];
   
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_logoImage  removeFromSuperview];
    [_masgeButton removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    [self initData];
    [self addLoop];
   
    
}


-(void)naveigtionAddSubView{
    self.title=@"首页";
    _logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(12,4,36,36)];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_logoImage.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii: _logoImage.bounds.size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = _logoImage.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    _logoImage.layer.mask = maskLayer;
     NSString *logoStr = [USER_DEFAULTS  objectForKey:@"logoImage"];
    [_logoImage sd_setImageWithURL:[NSURL URLWithString:logoStr] placeholderImage:[UIImage  imageNamed:@"tx23"]];
    [self.navigationController.navigationBar addSubview:_logoImage];
    
    _masgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _masgeButton.frame =CGRectMake(Scree_width - 12-36,4,36,36);
    [_masgeButton addTarget:self action:@selector(masgeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_masgeButton setImage:[UIImage imageNamed:@"xx_ico01"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:_masgeButton];
    _numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(_masgeButton.frame.size.width-6,1, 10, 10)];
    _numberLabel.layer.masksToBounds = YES;
    // 设置圆角半径
    if ([_number isEqualToString: @"1" ]) {
    _numberLabel.backgroundColor=[UIColor redColor];
    }
    _numberLabel.layer.cornerRadius =5.0f;
    [_masgeButton addSubview:_numberLabel];
}
-(void)initData
{
    int str = [[USER_DEFAULTS objectForKey:@"roleId"]intValue];
    //判断角色的设定主题的现实
    switch (str) {
        case 1:
            // 老板
            _arr=@[@"权限管理", @"店家跟踪", @"报表管理", @"店家信息", @"员工管理", @"经营品牌",@"公司公告", @"图片报岗"];
            _arr1=@[@"quanxian", @"dianpugenzong", @"baobiaoguanli", @"dianjiaxinxi", @"yuangongguanli", @"jingyingpinpai",@"gongsigonggao", @"baogang"];
            break;
        case 2:
            //市场美导
            _arr=@[@"店家跟踪", @"我的报表", @"店家信息", @"公司公告", @"图片报岗"];
            _arr1=@[@"dianpugenzong", @"baobiaomokuai", @"dianjiaxinxi", @"gongsigonggao", @"baogang"];
            break;
        case 3:
            //内勤人员
            _arr=@[@"店家跟踪", @"我的报表", @"店家信息", @"公司公告", @"图片报岗"];
            _arr1=@[@"dianpugenzong",@"baobiaomokuai",@"dianjiaxinxi",@"gongsigonggao",@"baogang"];
            break;
        case 4:
            // 物流
            _arr=@[@"店家跟踪",@"店家信息",@"公司公告",@"图片报岗"];
        _arr1=@[@"dianpugenzong",@"dianjiaxinxi",@"gongsigonggao",@"baogang"];
            break;
        case 5:
            //业务
            _arr=@[@"店家跟踪", @"我的报表", @"店家信息",@"公司公告", @"业务陌拜", @"图片报岗"];
            _arr1=@[@"dianpugenzong", @"baobiaomokuai", @"dianjiaxinxi",@"gongsigonggao", @"mobaijilu", @"baogang"];
            break;
        case 6:
            // 品牌经理
            _arr=@[@"店家跟踪", @"我的报表", @"店家信息", @"公司公告", @"报表管理", @"图片报岗"];
            _arr1=@[@"dianpugenzong", @"baobiaomokuai", @"dianjiaxinxi", @"gongsigonggao", @"baobiaoguanli", @"baogang"];
            break;
        case 7:
            //行政管理员
            _arr=@[@"店家跟踪", @"我的报表", @"店家信息", @"公司公告", @"报表管理", @"图片报岗"];
            _arr1=@[@"dianpugenzong", @"baobiaomokuai", @"dianjiaxinxi", @"gongsigonggao", @"baobiaoguanli", @"baogang"];
            break;
        case 8:
            //业务经理
            _arr=@[@"店家跟踪", @"我的报表", @"店家信息", @"公司公告", @"业务陌拜",@"图片报岗",@"报表管理"];
            _arr1=@[@"dianpugenzong",@"baobiaomokuai", @"dianjiaxinxi", @"gongsigonggao", @"mobaijilu",@"baogang",@"baobiaoguanli"];
            break;
        default:
            break;
    }
//    if ([str isEqualToString:@"3"]) {
//        
//       
//       
//    }else if ([str isEqualToString:@"5"]) {
//      
//    }else if ([str isEqualToString:@"8"]) {
//        
//       
//    }else if ([str isEqualToString:@"1"]) {
//       
//    }else if ([str isEqualToString:@"6"]) {
//     
//        
//    }else if ([str isEqualToString:@"4"]) {
//      
//    }else if ([str isEqualToString:@"7"]){
//   
//    }else if ([str isEqualToString:@"2"]){
//     
//    }
    _menuArray=[NSMutableArray array];
    for (int i=0; i<_arr1.count; i++) {
        ZYJHeadLineModel *model = [[ZYJHeadLineModel alloc]init];
        model.type  = _arr1[i];
        model.title = _arr[i];
        [_menuArray addObject:model];
    }


    
   
    // 创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 创建全局并行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        
        
        
        dispatch_semaphore_signal(semaphore);
        
        
    });
    dispatch_group_async(group, queue, ^{
        
        NSString *urlStr =[NSString stringWithFormat:@"%@user/querylogoImg.action",KURLHeader];
        NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
        NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"]};
        
        [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
            dispatch_semaphore_signal(semaphore);
            NSArray *arr= [responseObject valueForKey:@"logoImg"];
            NSMutableArray *array=[NSMutableArray array];
            for (NSDictionary *dic in arr) {
                NSString *Url= [NSString stringWithFormat:@"%@%@",KURLHeader,[dic valueForKey:@"url"]];
                [array addObject:Url];
            }
            self.loop.imageArray=array;
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
       
        
    });
    dispatch_group_async(group, queue, ^{
        
        NSString *uStr =[NSString stringWithFormat:@"%@marketReport/queryNewSum.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"]};
        [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
            dispatch_semaphore_signal(semaphore);
            if ([[responseObject valueForKey:@"message"]isEqualToString:@"1"]) {
                _number=@"1";
                _numberLabel.backgroundColor=[UIColor redColor];
            } else {
                _numberLabel.backgroundColor=[UIColor clearColor];
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
        
  
    });
    
    dispatch_group_notify(group, queue, ^{
        
        //在这里 进行请求后的方法
        
        
        // 三个请求对应三次信号等待
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    });

}


- (void)addLoop {
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
    //公告
    _noticeView=[[NoticeView alloc]initWithFrame:CGRectMake(15, self.loop.bottom+MenuH+10, Scree_width-30, 80)];
    [self.view addSubview:_noticeView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noticeTap:)];
    [_noticeView addGestureRecognizer:tap];
    __weak __typeof(self)weakSelf = self;
    _noticeView.TopLineView.clickBlock = ^(NSInteger index){
        GonggaoxqController *gongVC=[[GonggaoxqController alloc]init];
        [weakSelf.navigationController pushViewController:gongVC animated:YES];
        
    };
    [self.loop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.height.equalTo(self.view.mas_height).multipliedBy(3/8.f);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.loop.mas_bottom);
        make.height.mas_equalTo(MenuH);
    }];
    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.right.mas_equalTo(self.view.mas_right).offset(-12);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(10);
        make.height.equalTo(self.view.mas_height).multipliedBy(1/8.f);
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
-(void)noticeTap:(UITapGestureRecognizer*)sender{
    GonggaoxqController *gongVC=[[GonggaoxqController alloc]init];
    [self.navigationController pushViewController:gongVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
