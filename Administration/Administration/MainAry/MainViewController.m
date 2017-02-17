//
//  MainViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/14.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "MainViewController.h"
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
@end

@implementation MainViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
        
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    [self naveigtionAddSubView];
    [self addLoop];
    [self initData];
}


-(void)naveigtionAddSubView{
    self.title=@"首页";
    
    _logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(12,4,36,36)];
//    _logoImage.layer.masksToBounds = YES;
//    // 设置圆角半径
//    _logoImage.layer.cornerRadius = 18.0f;
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
    _masgeButton.backgroundColor=[UIColor blueColor];
    [self.navigationController.navigationBar addSubview:_masgeButton];
    _numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(_masgeButton.frame.size.width-6,6, 10, 10)];
    _numberLabel.layer.masksToBounds = YES;
    // 设置圆角半径
    _numberLabel.layer.cornerRadius =5.0f;
    _numberLabel.backgroundColor=[UIColor redColor];
    [_masgeButton addSubview:_numberLabel];
}
-(void)initData
{ // 第二种方式 加载plist
    NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"menuData.plist" ofType:nil];
    _menuArray=[[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    NSString *str = [USER_DEFAULTS objectForKey:@"roleId"];
    //判断角色的设定主题的现实

    if ([str isEqualToString:@""]) {
            //内勤人员
        NSArray *arr=@[@"店家跟踪", @"我的报表", @"店家信息", @"公司公告", @"图片报岗"];
       
    }else if ([str isEqualToString:@""]) {
            //业务
        NSArray *arr=@[@"店家跟踪", @"我的报表", @"店家信息",@"公司公告", @"业务陌拜", @"图片报岗"];
        
    }else if ([str isEqualToString:@""]) {
            //业务经理
        NSArray *arr=@[@"店家跟踪", @"我的报表", @"店家信息", @"公司公告", @"业务陌拜",@"图片报岗",
                       @"报表管理"];
       
    }else if ([str isEqualToString:@""]) {
        // 老板
        NSArray *arr=@[@"权限管理", @"店家跟踪", @"报表管理", @"店家信息", @"员工管理", @"经营品牌",
                       @"公司公告", @"图片报岗"];
        
    }else if ([str isEqualToString:@""]) {
        // 品牌经理
        NSArray *arr=@[@"店家跟踪", @"我的报表", @"店家信息", @"公司公告", @"报表管理", @"图片报岗"];
        
    }else if ([str isEqualToString:@""]) {
        // 物流

        NSArray *arr=@[@"店家跟踪",@"店家信息",@"公司公告",@"图片报岗"];
        
    }

    
    NSString *urlStr =[NSString stringWithFormat:@"%@user/querylogoImg.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"]};
    
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
      NSArray *arr= [responseObject valueForKey:@"logoImg"];
        NSMutableArray *array=[NSMutableArray array];
        for (NSDictionary *dic in arr) {
            NSString *Url= [NSString stringWithFormat:@"%@%@",KURLHeader,[dic valueForKey:@"url"]];
            [array addObject:Url];
        }
        self.loop.imageArray=array;
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
   
    
}

- (void)addLoop {
    //轮播图
    self.loop = [[XLsn0wLoop alloc] init];
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
    
    self.loop.xlsn0wDelegate = self;
    self.loop.time = 2;
    [self.loop setPageColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1] andCurrentPageColor:[UIColor whiteColor]];

    [self.loop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.equalTo(self.view.mas_height).multipliedBy(2/7.f);    }];
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
        make.height.equalTo(self.view.mas_height).multipliedBy(1/10.f);
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
    NSLog(@"134");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
