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
#define MenuH 160
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,XLsn0wLoopDelegate>
///
@property (nonatomic,retain)UIImageView *logoImage;
///
@property (nonatomic,retain)UIButton *masgeButton;
///
@property (nonatomic,retain)UILabel *numberLabel;
///轮播图
@property (nonatomic, strong) XLsn0wLoop *loop;
///
@property(nonatomic,strong)UITableView *tableView;
///
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
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    //创建一个高20的假状态栏背景
    self.view.backgroundColor=[UIColor redColor];
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
    
    self.loop = [[XLsn0wLoop alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 240)];
    [self.view addSubview:self.loop];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,self.loop.frame.size.height,Scree_width,MenuH) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    self.loop.xlsn0wDelegate = self;
    self.loop.time = 2;
    [self.loop setPageColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1] andCurrentPageColor:[UIColor whiteColor]];
    //支持gif动态图
    self.loop.imageArray = @[@"http://i3.hoopchina.com.cn/u/1212/19/386/16355386/2d4f91db_530x.gif",
                             @"http://pic2015.5442.com/2015/1118/8/18.jpg%21960.jpg",
                             @"http://tpic.home.news.cn/xhCloudNewsPic/xhpic1501/M07/1B/9C/wKhTlVeRvImESafHAAAAAGHVmt8775.gif",
                             @"http://www.pp3.cn/uploads/201606/2016060401.jpg"];
    
    
    
    
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
