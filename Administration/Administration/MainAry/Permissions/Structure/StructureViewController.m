//
//  StructureViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "StructureViewController.h"

@interface StructureViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSTimer *_timerrrrrrrr;
    int     count;
}
@property (nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)NSMutableArray *indesPaths;
@property (nonatomic,assign)int DatNum;
@property(nonatomic,strong) NSTimer * timer;

@end

@implementation StructureViewController
- (void)dealloc {
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [_timerrrrrrrr invalidate];
    _timerrrrrrrr = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    [self timerMethodB];
    _tableView = [[UITableView alloc]init];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, kHeight*650)];
    self.tableView.tableHeaderView=_imageView;
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)timerMethodB
{
    _timerrrrrrrr = [NSTimer scheduledTimerWithTimeInterval:0.5f  //间隔时间
                                              target:self
                                            selector:@selector(methodBEvnet)
                                            userInfo:nil
                                             repeats:YES];
}
- (void)methodBEvnet
{
    count ++;
    NSString *filename = [NSString stringWithFormat:@"职位结构%d", count];
    NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:file];
    [self.imageView setImage:image];
    if (count >= 10) {
       
        [self tableviewpUi];
        [_timerrrrrrrr invalidate];
        self.DatNum = -1;
        NSMutableArray *indexPaths = @[].mutableCopy;
        self.indesPaths = indexPaths;
        self.timer =  [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(charusell) userInfo:nil repeats:YES];
    
    }
}
-(void)tableviewpUi
{

        _tableView.delegate = self;
        _tableView.dataSource = self;
    

}
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"职位解析",
                     @"",
                     @"",
                     @"1.老板:管理所有员工拥有所有权限",
                     @"2.行政管理:1)管理公司内所有报表等文档的手机整理 ",
                     @"         2)协助老板管理",
                     @"         3)相当于一个老板的辅助管理账号.",
                     @"3.业务总监:1)负责业务方面开拓市场所有规划 ",
                     @"          2)管理下属业务经理",
                     @"4.业务经理:1)负责完成业务总监的计划任务",
                     @"          2)管理下属业务员",
                     @"5.业务:负责开拓新的合作客户",
                     @"6.市场总监:1)负责已合作客户的整体销售计划 ",
                     @"         2)任务管理下属各市场经理",
                     @"7.市场经理:1)负责该品牌客户的销售、服务、管理 ",
                     @"          2)管理下属品牌美导.",
                     @"8.美导:服务店家的美容导师.",
                     @"9.财务总监:1)负责公司的财务计算",
                     @"         2)物流的运转 ",
                     @"         3)客服与客户之间的沟通及管理下属.",
                     @"10.客服经理:负责内部人员及客户的问题沟通及管理下",
                     @"属客服.",
                     @"11.客服:负责公司的客户机公司内部人员的沟通.",
                     @"12.物流经理:负责公司的物流服务管理及出入活管理.",
                     @"13.物流:负责公司向店家供货的物流服务.",
                     @"14.仓库:负责货物的出入库及管理.",
                     @"15.财务经理:负责公司的财务管理及管理下属.",
                     @"16.会计:负责公司所有明细分类账，直接将逐笔登记",
                     @"总账等工作流程.",
                     @"17.出纳:负责货物价款首付及往来款项收付等."
                     
                     ];
    }
    return _dataArr;
}

-(void)charusell{
    self.DatNum = self.DatNum +1;
    if (self.DatNum < self.dataArr.count) {
        [self.indesPaths addObject:[NSIndexPath indexPathForItem:self.DatNum inSection:0]];
        [self.tableView insertRowsAtIndexPaths:self.indesPaths withRowAnimation:UITableViewRowAnimationRight];
        [self.indesPaths removeAllObjects];
    }else{
        [self.timer invalidate];
        //记得当不用这个定时器的时候要销毁.
        self.timer = nil;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.DatNum+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.tintColor = GetColor(76, 76, 76, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:kWidth*28];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 20;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
