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
    _logoImage.backgroundColor=[UIColor redColor];
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
{
    // 第一种方式 加载plist
    //    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"menuData" ofType:@"plist"];
    //    _menuArray=[[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    
    // 第二种方式 加载plist
    NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"menuData.plist" ofType:nil];
    _menuArray=[[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    
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
    //支持gif动态图
    self.loop.imageArray = @[@"http://i3.hoopchina.com.cn/u/1212/19/386/16355386/2d4f91db_530x.gif",
                             @"http://pic2015.5442.com/2015/1118/8/18.jpg%21960.jpg",
                             @"http://tpic.home.news.cn/xhCloudNewsPic/xhpic1501/M07/1B/9C/wKhTlVeRvImESafHAAAAAGHVmt8775.gif",
                             @"http://www.pp3.cn/uploads/201606/2016060401.jpg"];
    
    [self.loop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.equalTo(self.view.mas_height).multipliedBy(1/4.f);    }];
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
