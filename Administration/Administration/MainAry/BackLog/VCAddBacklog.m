//
//  VCAddBacklog.m
//  Administration
//
//  Created by zhang on 2017/10/13.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCAddBacklog.h"
#import "CellEditInfo.h"
@interface VCAddBacklog ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UILabel *label;
@property (nonatomic,weak)UIButton *chooseBacklog;
@property (nonatomic,weak)UIButton *startDate;
@property (nonatomic,weak)UIButton *endDate;
@property (nonatomic,weak)UIButton *warnDate;
@property (nonatomic,weak)UIButton *allReady;
@property (nonatomic,weak)UIButton *notReady;
@property (nonatomic,weak)UITableView *tableView;

@property (nonatomic,weak)UIImageView *imageView1;

@property (nonatomic,weak)UIImageView *imageView2;
@end

@implementation VCAddBacklog

#pragma -mark custem

-(void)getHttpData
{
    
}

-(void)setUI
{
//    UIView *view1 = [[UIView alloc]init];
//    view1.backgroundColor = GetColor(192, 192, 192, 1);
//    [self.view addSubview:view1];
//    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left);
//        make.top.mas_equalTo(self.view.mas_top);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.height.mas_equalTo(90);
//    }];
//    
//    UILabel *labelStay = [[UILabel alloc]init];
//    labelStay.backgroundColor = [UIColor whiteColor];
//    labelStay.text = @"  待办事项";
//    [view1 addSubview:labelStay];
//    [labelStay mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(view1.mas_left);
//        make.top.mas_equalTo(view1.mas_top);
//        make.height.mas_equalTo(44);
//        make.width.mas_equalTo(100);
//    }];
//    
//    UIButton *chooseBacklog = [[UIButton alloc]init];
//    chooseBacklog.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [chooseBacklog setBackgroundColor:[UIColor whiteColor]];
//    [chooseBacklog setTitle:@"选择待办事项" forState:UIControlStateNormal];
//    [chooseBacklog setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
//    [chooseBacklog addTarget:self action:@selector(showChooseBacklog) forControlEvents:UIControlEventTouchUpInside];
//    [view1 addSubview:chooseBacklog];
//    [chooseBacklog mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(labelStay.mas_right);
//        make.top.mas_equalTo(view1.mas_top);
//        make.right.mas_equalTo(view1.mas_right);
//        make.height.mas_equalTo(44);
//    }];
//    self.chooseBacklog = chooseBacklog;
//    
//    UILabel *labelDate = [[UILabel alloc]init];
//    labelDate.text = @"  日期";
//    labelDate.backgroundColor = [UIColor whiteColor];
//    [view1 addSubview:labelDate];
//    [labelDate mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(labelStay.mas_bottom).offset(1);
//        make.left.mas_equalTo(view1.mas_left);
//        make.width.mas_equalTo(100);
//        make.height.mas_equalTo(44);
//    }];
//    
//    UIButton *startDate = [[UIButton alloc]init];
//    startDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [startDate setBackgroundColor:[UIColor whiteColor]];
//    [startDate setTitle:@"选择日期" forState:UIControlStateNormal];
//    [startDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
//    [startDate addTarget:self action:@selector(showDatePick) forControlEvents:UIControlEventTouchUpInside];
//    [view1 addSubview:startDate];
//    [startDate mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(labelDate.mas_right);
//        make.top.mas_equalTo(labelStay.mas_bottom).offset(1);
//        make.width.mas_equalTo(100);
//        make.height.mas_equalTo(44);
//    }];
//    self.startDate = startDate;
//    
//    UILabel *label = [[UILabel alloc]init];
//    label.text = @"至";
//    label.backgroundColor = [UIColor whiteColor];
//    [view1 addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(startDate.mas_right);
//        make.top.mas_equalTo(labelStay.mas_bottom).offset(1);
//        make.height.mas_equalTo(44);
//        make.width.mas_equalTo(15);
//    }];
//    self.label = label;
//    
//    UIButton *endDate = [[UIButton alloc]init];
//    endDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [endDate setBackgroundColor:[UIColor whiteColor]];
//    [endDate setTitle:@"选择日期" forState:UIControlStateNormal];
//    [endDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
//    [endDate addTarget:self action:@selector(showDatePick) forControlEvents:UIControlEventTouchUpInside];
//    [view1 addSubview:endDate];
//    [endDate mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(label.mas_right);
//        make.top.mas_equalTo(labelStay.mas_bottom).offset(1);
//        make.right.mas_equalTo(view1.mas_right);
//        make.height.mas_equalTo(44);
//    }];
//    self.startDate = endDate;
//    
    UIView *viewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, 108)];
    viewFooter.backgroundColor = GetColor(192, 192, 192, 1);
    [self.view addSubview:viewFooter];
    
    UILabel *labelworn = [[UILabel alloc]init];
    labelworn.text = @"    提醒时间";
    labelworn.backgroundColor = [UIColor whiteColor];
    [viewFooter addSubview:labelworn];
    [labelworn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewFooter.mas_left);
        make.top.mas_equalTo(viewFooter.mas_top).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    [viewFooter addSubview:labelworn];
    
//    view1.frame = CGRectMake(0, 0, Scree_width,30);
    
    UIButton *wornDate = [[UIButton alloc]init];
    wornDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [wornDate setBackgroundColor:[UIColor whiteColor]];
    [wornDate setTitle:@"选择提醒时间" forState:UIControlStateNormal];
    [wornDate setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [wornDate addTarget:self action:@selector(showDatePick) forControlEvents:UIControlEventTouchUpInside];
    [viewFooter addSubview:wornDate];
    [wornDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelworn.mas_right);
        make.top.mas_equalTo(viewFooter.mas_top).offset(10);
        make.right.mas_equalTo(viewFooter.mas_right);
        make.height.mas_equalTo(44);
    }];
    self.startDate = wornDate;
    
    
    
    UIButton *notReady = [[UIButton alloc]init];
    notReady.tag = 300;
    [notReady setBackgroundColor:[UIColor whiteColor]];
    [notReady setImage:[UIImage imageNamed:@"yuanhuan_03"] forState:UIControlStateNormal];
    [notReady setTitle:@"未完成" forState:UIControlStateNormal];
    [notReady setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [notReady addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [viewFooter addSubview:notReady];
    [notReady mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewFooter.mas_left);
        make.right.mas_equalTo(viewFooter.mas_centerX);
        make.top.mas_equalTo(labelworn.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
    }];
    self.notReady = notReady;
    
    UIButton *allReady = [[UIButton alloc]init];
    allReady.tag = 400;
    [allReady setBackgroundColor:[UIColor whiteColor]];
    [allReady setImage:[UIImage imageNamed:@"yuanhuan_03"] forState:UIControlStateNormal];
    [allReady setTitle:@"已完成" forState:UIControlStateNormal];
    [allReady setTitleColor:GetColor(192, 192, 192, 1) forState:UIControlStateNormal];
    [allReady addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [viewFooter addSubview:allReady];
    [allReady mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewFooter.mas_centerX);
        make.right.mas_equalTo(viewFooter.mas_right);
        make.top.mas_equalTo(labelworn.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
    }];
    self.allReady = allReady;
    
    if (self.isCheckDetail) {
        notReady.hidden = NO;
        allReady.hidden = NO;
        notReady.userInteractionEnabled = YES;
        allReady.userInteractionEnabled = YES;
    }else
    {
        notReady.hidden = YES;
        allReady.hidden = YES;
        notReady.userInteractionEnabled = NO;
        allReady.userInteractionEnabled = NO;
    }
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 50;
//    tableView.tableHeaderView = view1;
    tableView.tableFooterView = viewFooter;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[CellEditInfo class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).offset(kTopHeight);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView = tableView;
}


-(void)showChooseBacklog
{
    
}

-(void)saveBacklog
{
    
}

-(void)showShooseEdit
{
    
}

-(void)showDatePick
{
    
}

-(void)changeState:(UIButton *)button
{
    
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellEditInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellEditInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.labelTitle.text = @"33333";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

#pragma  -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.isCheckDetail) {
        [self getHttpData];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem;
    self.navigationItem.rightBarButtonItem = rightitem;
    
    if (self.isCheckDetail) {
        self.title = @"";
       rightitem = [[UIBarButtonItem alloc] initWithTitle:@"..." style:(UIBarButtonItemStyleDone) target:self action:@selector(showShooseEdit)];
        [rightitem setTitleTextAttributes:dictionary forState:UIControlStateNormal];
    }
    else
    {
        self.title = @"添加待办事项";
       rightitem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(saveBacklog)];
        [rightitem setTitleTextAttributes:dictionary forState:UIControlStateNormal];
    }
    
    self.navigationItem.rightBarButtonItem = rightitem;
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
