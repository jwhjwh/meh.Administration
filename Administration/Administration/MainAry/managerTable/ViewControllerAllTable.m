//
//  ViewControllerAllTable.m
//  Administration
//
//  Created by zhang on 2017/8/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewControllerAllTable.h"
#import "ViewControllerSelectTable.h"
#import "MBProgressHUD.h"
#import "CellTbale.h"
@interface ViewControllerAllTable ()<UITableViewDelegate,UITableViewDataSource>
{
    NSUInteger _page;//接口page
    NSNumber *page;
    //是不是第一次执行请求
    
    BOOL _isFirstLoadData ;
    
    //是不是上拉加载数据（脚视图刷新）
    
    BOOL _isFooterFresh ;
    
    UITableView *tableView1;
    UILabel *label;
    NSMutableArray *arrayData;
    
}
@end

@implementation ViewControllerAllTable

#pragma mark - 添加刷新

- (void)removeHUD:(id)hud

{
    
    //结束刷新
    
    [tableView1.mj_header endRefreshing];
    
    [tableView1.mj_footer endRefreshing];
    
    [hud removeFromSuperview];
    
}

-(void)setUI
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(-1, 64, Scree_width+1, 50)];
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 0.5f;
    [self.view addSubview:view];
    
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundImage:[UIImage imageNamed:@"ss_ico01"]forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoNext) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).offset(8);
        make.bottom.mas_equalTo(view.mas_bottom).offset(-8);
        make.left.mas_equalTo(view.mas_left).offset(20);
        make.right.mas_equalTo(view.mas_right).offset(-20);
    }];
    
    label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"    所有报表" ];
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 1.0f;
    label.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left).offset(-1);
        make.right.mas_equalTo(self.view.mas_right).offset(1);
        make.height.mas_equalTo(20);
    }];
    
}

-(void)gotoNext
{
    ViewControllerSelectTable *vc = [[ViewControllerSelectTable alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)getData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    //    hud.mode = MBProgressHUDModeText;
    
    hud.labelText = @"加载中...";
    
    hud.labelFont = [UIFont systemFontOfSize:12];
    
    hud.margin = 10.f;
    
        hud.dimBackground = YES;
    
    [self.view addSubview:hud];
    
    NSString *urlStr =[NSString stringWithFormat:@"%@report/querySearchReportList",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *dict = @{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS valueForKey:@"userid"],@"CompanyInfoId":compid,@"Sort":@"1",@"DepartmentID":@"152",@"RoleId":@"1",@"Num":@"4",@"code":@"1",@"page":[NSString stringWithFormat:@"%lu",(unsigned long)_page]};
    [ZXDNetworking GET:urlStr parameters:dict success:^(id responseObject) {
        NSString *stringCode = [responseObject valueForKey:@"status"];
        if ([stringCode isEqualToString:@"0000"]) {
            hud.labelText = @"加载成功";
            [self performSelector:@selector(removeHUD:) withObject:hud afterDelay:0.5];
            
           // label.text = [];
            return ;
        }else
        {
            [self performSelector:@selector(removeHUD:) withObject:hud afterDelay:0.5];
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

- (void)createRefresh

{
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 134, Scree_width, Scree_height) style:UITableViewStylePlain];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    [ZXDNetworking setExtraCellLineHidden:tableView1];
    [self.view addSubview:tableView1];
    //添加下拉刷新
    
    tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 1;
        
        _isFooterFresh = NO;
        
        [self getData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    
    tableView1.mj_header.automaticallyChangeAlpha = YES;
    
    
    
    //上拉加载
    
    tableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page++;
        
        _isFooterFresh = YES;
        
        [self getData];
        
        
        
    }];
    
    tableView1.mj_footer.automaticallyChangeAlpha = YES;
    
}

#pragma -mark tabelView
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


#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"所有报表";
    
    _isFirstLoadData = YES;
    
    //不是上拉加载数据
    
    _isFooterFresh = NO;
    
    //页码赋初值
    
    _page=1;
    
    [self createRefresh];
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
