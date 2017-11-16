//
//  businessViewController.m
//  Administration
//
//  Created by zhang on 2017/3/10.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "businessViewController.h"
#import "busableController.h"
#import "InterestedViewController.h"
#import  "TargetCustomerViewController.h"
#import "CooperationViewController.h"
@interface businessViewController ()<UITableViewDataSource,UITableViewDelegate>

{
   UITableView *infonTableview;
}
@property (strong,nonatomic) NSArray *InterNameAry;
@end

@implementation businessViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"业务陌拜";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
   
    _InterNameAry = @[@"陌拜记录",@"意向客户",@"目标客户",@"确定合作客户"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 83,self.view.bounds.size.width,1)];
    view.backgroundColor=GetColor(216, 216, 216, 1);
    [self.view addSubview:view];
    infonTableview =[[UITableView alloc]initWithFrame:CGRectMake(0,84, kScreenWidth, kScreenHeight-64)];
    //分割线无
    //    infonTableview.separatorStyle= UITableViewCellSeparatorStyleNone;
    //不让滚动
    infonTableview.scrollEnabled = NO;
    infonTableview.showsVerticalScrollIndicator = NO;
    infonTableview.delegate = self;
    infonTableview.dataSource = self;
    [self.view addSubview: infonTableview];
    [ZXDNetworking setExtraCellLineHidden:infonTableview];
}


-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _InterNameAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _InterNameAry[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{//陌拜记录
            busableController *busableVC = [[busableController alloc]init];
            busableVC.strId = self.strId;
            [self.navigationController showViewController:busableVC sender:nil];
        }
            
            break;
        case 1:{//意向客户
            InterestedViewController *interestedVC = [[InterestedViewController alloc]init];
            interestedVC.strId = self.strId;
            [self.navigationController showViewController:interestedVC sender:nil];
        }
            break;
        case 2:{//目标客户
            TargetCustomerViewController *TCVC= [[TargetCustomerViewController alloc]init];
            TCVC.strId = self.strId;
            [self.navigationController showViewController:TCVC sender:nil];
        }
            break;
        case 3:{//确定合作客户
            CooperationViewController *ctvc= [[CooperationViewController alloc]init];
            ctvc.strId = self.strId;
            [self.navigationController showViewController:ctvc sender:nil];
        }
            break;
        default:
            break;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([infonTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [infonTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([infonTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [infonTableview setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

@end
