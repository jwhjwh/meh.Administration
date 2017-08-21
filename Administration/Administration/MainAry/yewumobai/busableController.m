//
//  busableController.m
//  Administration
//
//  Created by zhang on 2017/3/10.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "busableController.h"
#import "FillinfoViewController.h"
@interface busableController ()<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *infonTableview;
}
@property (strong,nonatomic) NSArray *InterNameAry;

@end

@implementation busableController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"陌拜记录表";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
     btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
  
    _InterNameAry = @[@"填写新的",@"已填纪录",@"草稿箱"];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,83,self.view.bounds.size.width,1)];
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

-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{//填写新的
            FillinfoViewController *fillVC=[[FillinfoViewController alloc]init];
            [self.navigationController pushViewController:fillVC animated:YES];
        }
            break;
        case 1:{//已填记录
            
        } break;
        case 2:{//草稿箱
            
        }  break;

        default:
            break;
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
