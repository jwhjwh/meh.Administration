//
//  VCDrafts.m
//  Administration
//
//  Created by zhang on 2017/9/26.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VCDrafts.h"
#import "CellDrafts.h"
@interface VCDrafts ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,assign)NSUInteger _page;//接口page
//是不是第一次执行请求
@property (nonatomic)BOOL _isFirstLoadData ;
//是不是上拉加载数据（脚视图刷新）
@property (nonatomic)BOOL _isFooterFresh ;
@end

@implementation VCDrafts

#pragma -mark custem

-(void)getData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/queryUserOwnReport",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    
    NSDictionary *dict = @{@"appkey":appKeyStr,
                           @"usersid":[USER_DEFAULTS valueForKey:@"userid"],
                           @"CompanyInfoId":compid,
                           @"RoleId":[ShareModel shareModel].roleID,
                           @"Sort":[ShareModel shareModel].sort,
                           @"page":[NSString stringWithFormat:@"%ld",self._page],
                           @"DepartmentID":[ShareModel shareModel].departmentID,
                           @"flag":@"3",
                           @"Num":[ShareModel shareModel].num};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        NSString *code = [responseObject valueForKey:@"status"];
        if ([code isEqualToString:@"0000"]) {
            
            for (NSDictionary *dict in [responseObject valueForKey:@"lists"] ) {
                [self.arrayData addObject:dict];
            }
            [self.tableView reloadData];
            return ;
        }
        if ([code isEqualToString:@"1001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"4444"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"异地登录" andInterval:1.0];
            return ;
        }
        if ([code isEqualToString:@"5000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"暂无数据" andInterval:1.0];
            return ;
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

-(void)setUI
{
    UILabel *label = [[UILabel alloc]init];
    label.text = @"    最近报表";
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 1.0f;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(-1);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.right.mas_equalTo(self.view.mas_right).offset(1);
        make.height.mas_equalTo(21);
    }];
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[CellDrafts class] forCellReuseIdentifier:@"cell"];
    [ZXDNetworking setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(label.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self._page = 1;
        
        self._isFooterFresh = NO;
        [self.arrayData removeAllObjects];
        [self getData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    
    
    //上拉加载
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self._page++;
        
        self._isFooterFresh = YES;
        
        [self getData];
    }];
    
    tableView.mj_footer.automaticallyChangeAlpha = YES;
    
    
    self._isFirstLoadData = YES;
    
    //不是上拉加载数据
    
    self._isFooterFresh = NO;
    
    //页码赋初值
    
    self._page=1;
    self.tableView = tableView;
}

#pragma -mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellDrafts *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellDrafts alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.labelName.text = self.stringTitle;
    NSDictionary *dict = self.arrayData[indexPath.row];
    cell.dict = dict;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.arrayData[indexPath.row];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma -mark system

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.arrayData removeAllObjects];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.stringTitle;
    self.arrayData = [NSMutableArray array];
    
    [self setUI];
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
