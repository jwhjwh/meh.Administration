//
//  SecurityViewController.m
//  Administration
//  账号安全
//  Created by 九尾狐 on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "SecurityViewController.h"
#import "LockSettingViewController.h"//手势锁
#import "ModifyViewController.h"//修改密码
#import "IntercalateController.h"
@interface SecurityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
}
@property (strong,nonatomic) NSArray *InterNameAry;
@property (strong,nonatomic) NSString *Emailstr;
@property(nonatomic,strong)UIAlertController *alert;

@end
@implementation SecurityViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title=@"账号安全";
    [self ManafementUI];
    [self setExtraCellLineHidden:tableview];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _InterNameAry = [[NSArray alloc]initWithObjects:@"手势密码锁定",@"修改密码",nil];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
}
-(void)buttonLiftItem{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)ManafementUI{
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 20,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    tableview.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    tableview.scrollEnabled =NO;
    tableview.dataSource=self;
    tableview.delegate =self;
    [self.view addSubview:tableview];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //定义个静态字符串为了防止与其他类的tableivew重复
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [tableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _InterNameAry[indexPath.row];

    return cell;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return _InterNameAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        [self.navigationController pushViewController:[[LockSettingViewController alloc] init] animated:YES];
    }
    else {
        [self.navigationController pushViewController:[[ModifyViewController alloc]init] animated:YES];
    }
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
