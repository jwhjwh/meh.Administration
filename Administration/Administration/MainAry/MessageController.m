//
//  MessageController.m
//  Administration
//
//  Created by zhang on 2017/2/18.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "MessageController.h"
#import "MesgeTableViewCell.h"
@interface MessageController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation MessageController

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
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.tableView .delegate = self;
    self.tableView .dataSource = self;
    [self.view addSubview: self.tableView ];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250*kHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;


    
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
//        cell.coModel = self.BidCouponDataArray[indexPath.row];
//        cell.view.image =[UIImage imageNamed:@"daishiyon@2x"];
//        cell.priceLabel.textColor=[UIColor colorWithRed:58/256.0 green:147/256.0 blue:223.0/256.0 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
