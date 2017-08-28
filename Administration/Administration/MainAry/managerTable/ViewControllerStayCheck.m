
//
//  ViewControllerStayCheck.m
//  Administration
//
//  Created by zhang on 2017/8/22.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ViewControllerStayCheck.h"
#import "CellTbale.h"
#import "ViewControllerPersonTableDetail.h"
@interface ViewControllerStayCheck ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation ViewControllerStayCheck
#pragma -mark custem
-(void)getData
{
    NSString *urlStr =[NSString stringWithFormat:@"%@report/selectUsersid.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info = [[NSDictionary alloc]init];
    
}
#pragma -mark tabelView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellTbale *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[CellTbale alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewControllerPersonTableDetail *vc = [[ViewControllerPersonTableDetail alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

#pragma -mark system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"待审核";
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 64, Scree_width, 20)];
    label.text = [NSString stringWithFormat:@"%ld",self.arrayData.count];
    [self.view addSubview:label];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Scree_width, Scree_height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CellTbale class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    
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
