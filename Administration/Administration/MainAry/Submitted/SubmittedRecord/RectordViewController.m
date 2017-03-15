//
//  RectordViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/10.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "RectordViewController.h"
#import "RectordModel.h"
#import "RectordTableViewCell.h"
#import "DateSubmittedViewController.h"
@interface RectordViewController ()<UITableViewDataSource,UITableViewDelegate>

//列表
@property (nonatomic,strong)UITableView *tableView;
//服务器获取数据源
@property (nonatomic,strong)NSMutableArray *dataArray;
//页数
@property (nonatomic,assign)int pagenum;

@end

@implementation RectordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"报岗记录";
    _pagenum = 1;
     self.dataArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight	)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RectordTableViewCell" bundle:nil] forCellReuseIdentifier:@"RECTORD"];
    
    [self getNetworkData:NO];
    __weak typeof(self) weakSelf = self;
    //默认【下拉刷新】
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        _dataArray = [NSMutableArray array];
        [weakSelf getNetworkData:YES];
    }];
    //默认【上拉加载】
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getNetworkData:NO];
    }];
    // Do any additional setup after loading the view.
}
-(void)getNetworkData:(BOOL)isRefresh{
    if (isRefresh) {
        _pagenum = 1;
    }else{
        _pagenum++;
    }
    NSString *pageStr=[NSString stringWithFormat:@"%d",_pagenum];
    NSString *urlStr =[NSString stringWithFormat:@"%@picreport/queryPic.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"pageNo":pageStr};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        //plist
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"plist"];
            if (array.count==0) {
                self.tableView.footer.state = MJRefreshFooterStateNoMoreData;
                return;
                
            }else{
                for (NSDictionary *dic in array) {
                    RectordModel *model=[[RectordModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    model.dateTimes = [model.dateTimes substringToIndex:16];
                    [self.dataArray addObject:model];
                }
 
            }
                        [self.tableView reloadData];
            
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]||[[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登陆超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
            
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RectordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RECTORD" forIndexPath:indexPath];
    if (self.dataArray.count <=0) {
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RectordModel *model = _dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    [cell loadDataFromModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DateSubmittedViewController *detail = [[DateSubmittedViewController alloc]init];
    RectordModel *model =self.dataArray[indexPath.section];
    detail.contentid = model.Pid;
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end