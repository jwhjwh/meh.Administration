//
//  dongjieViewController.m
//  Administration
//
//  Created by zhang on 2017/3/4.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "dongjieViewController.h"

@interface dongjieViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    
}
@property (nonatomic,retain)NSArray *arr;

@end

@implementation dongjieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"冻结设置";
    self.view.backgroundColor =GetColor(230, 230, 230, 1);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(Scree_width/2-80, 74,160, 30)];
    label.text=[NSString stringWithFormat:@"使用状态:%@",_state];
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
   _arr = [[NSArray alloc]initWithObjects:@"解冻账号",@"冰冻账户",nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
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
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    cell.textLabel.text = _arr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
