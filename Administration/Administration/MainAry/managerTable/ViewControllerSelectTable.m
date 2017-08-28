//
//  ViewControllerSelectTable.m
//  Administration
//
//  Created by zhang on 2017/8/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewControllerSelectTable.h"
#import "ViewBack.h"
#import "CellTbale.h"
@interface ViewControllerSelectTable ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UIButton *buttonStart;
@property (nonatomic,weak)UIButton *buttonEnd;
@property (nonatomic,weak)UITableView *tableView;
@end

@implementation ViewControllerSelectTable

#pragma -mark custem
-(void)setUI
{
    UIView *viewTop = [[UIView alloc]init];
    viewTop.layer.borderColor = [UIColor lightGrayColor].CGColor;
    viewTop.layer.borderWidth = 1.0f;
    [self.view addSubview:viewTop];
    [viewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(-1);
        make.right.mas_equalTo(self.view.mas_right).offset(1);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"开始日期";
    label1.font = [UIFont systemFontOfSize:12];
    [viewTop addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.backgroundColor = [UIColor lightGrayColor];
    [viewTop addSubview:label2];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewTop.mas_left).offset(10);
        make.right.mas_equalTo(label2.mas_left);
        make.centerY.mas_equalTo(viewTop.mas_centerY);
        make.height.mas_equalTo(14);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(viewTop.mas_centerX);
        make.left.mas_equalTo(60);
        make.bottom.mas_equalTo(label1.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *buttonStart = [[UIButton alloc]init];
    [buttonStart setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonStart addTarget:self action:@selector(setDate:) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:buttonStart];
    [buttonStart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right);
        make.right.mas_equalTo(viewTop.mas_centerX);
        make.bottom.mas_equalTo(label2.mas_top);
        make.height.mas_equalTo(14);
    }];
    self.buttonStart = buttonStart;
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"结束日期";
    label3.font = [UIFont systemFontOfSize:12];
    [viewTop addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.backgroundColor = [UIColor lightGrayColor];
    [viewTop addSubview:label4];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewTop.mas_centerX);
        make.right.mas_equalTo(label4.mas_left);
        make.centerY.mas_equalTo(viewTop.mas_centerY);
        make.height.mas_equalTo(14);
    }];
    
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(viewTop.mas_right).offset(-10);
        make.left.mas_equalTo(viewTop.mas_centerX).offset(50);
        make.bottom.mas_equalTo(label3.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *buttonEnd = [[UIButton alloc]init];
    [buttonEnd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonEnd addTarget:self action:@selector(setDate:) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:buttonEnd];
    [buttonEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label3.mas_right);
        make.right.mas_equalTo(viewTop.mas_right).offset(-10);
        make.bottom.mas_equalTo(label4.mas_top);
        make.height.mas_equalTo(14);
    }];
    self.buttonEnd = buttonEnd;
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[CellTbale class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(viewTop.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView = tableView;
}

-(void)setDate:(UIButton *)button
{
    ViewBack *viewback = [[ViewBack alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    [button setTitle:viewback.startDate forState:UIControlStateNormal];
    [self.view addSubview:viewback];
    
}

-(void)selectCheck
{
    
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellTbale *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellTbale alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}
#pragma -mark
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"搜索";
    
    [self setUI];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"查询" style:(UIBarButtonItemStyleDone) target:self action:@selector(selectCheck)];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
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
