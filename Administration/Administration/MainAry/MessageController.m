//
//  MessageController.m
//  Administration
//
//  Created by zhang on 2017/2/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "MessageController.h"
#import "MessagexqController.h"
#import "MesgeTableViewCell.h"
#import "mesgeModel.h"
@interface MessageController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation MessageController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"系统消息";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+49)];
    self.tableView .delegate = self;
    self.tableView .dataSource = self;
    [self.view addSubview: self.tableView ];
    
    NSString *urlStr =[NSString stringWithFormat:@"%@marketReport/newInfo.action.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"]};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        self.dataArray = [NSMutableArray array];
        NSArray *array=[responseObject valueForKey:@"Sums"];
        for (NSDictionary *dic in array) {
            mesgeModel *model=[[mesgeModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
    
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;


    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MesgeTableViewCell *cell = [[MesgeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[MesgeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    if (self.dataArray.count > 0) {
        cell = [[MesgeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
        cell.model = self.dataArray[indexPath.row];
//        cell.view.image =[UIImage imageNamed:@"daishiyon@2x"];
//        cell.priceLabel.textColor=[UIColor colorWithRed:58/256.0 green:147/256.0 blue:223.0/256.0 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
    }
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   mesgeModel *model=self.dataArray[indexPath.row];
    MessagexqController *messageVC =[[MessagexqController alloc]init];
   NSString *tabStr =[NSString stringWithFormat:@"%@",model.tableName];
    messageVC.IdStr=[NSString stringWithFormat:@"%@",model.ID];
    messageVC.remarkStr=[NSString stringWithFormat:@"%@",model.remark];
    
    if([tabStr  hasPrefix:@"Clerk"]){
        messageVC.flagStr=@"4";
    } else if ([tabStr  hasPrefix:@"Market"]){
        messageVC.flagStr=@"2";
    }else if ([tabStr  hasPrefix:@"Secre"]){
        messageVC.flagStr=@"6";
    }
    
    if ([model.tableName isEqualToString:@"MarketDayReport"]|| [model.tableName isEqualToString:@"ClerkDayReport"]
        || [model.tableName isEqualToString:@"SecretaryDayReport"]) {
        messageVC.codeStr=@"2";
        messageVC.sortStr=@"1";
    } else if ([model.tableName isEqualToString:@"MarketWeekPlanReport"]|| [model.tableName isEqualToString:@"ClerkWeekPlanReport"]
               || [model.tableName isEqualToString:@"SecretaryWeekPlanReport"]) {
        messageVC.codeStr=@"1";
        messageVC.sortStr=@"2";
    } else if ([model.tableName isEqualToString:@"MarketMonthPlanReport" ]|| [model.tableName isEqualToString:@"SecretaryMonthPlanReport"]) {
        messageVC.codeStr=@"1";
        messageVC.sortStr=@"3";
    } else if ([model.tableName isEqualToString:@"MarketMonthSumReport"] || [model.tableName isEqualToString:@"SecretaryMonthSumReport"]) {
        messageVC.codeStr=@"2";
        messageVC.sortStr=@"3";
    } else if ([model.tableName isEqualToString:@"MarketWeekSumReport"] || [model.tableName isEqualToString:@"SecretaryWeekSumReport"]
               || [model.tableName isEqualToString:@"ClerkWeekSumReport"]) {
        messageVC.codeStr=@"2";
        messageVC.sortStr=@"2";
    }
    [self.navigationController pushViewController:messageVC animated:YES];
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
