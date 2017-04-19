//
//  BusinessGroupViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/4/15.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "BusinessGroupViewController.h"
#import "AddBusinessViewController.h"//添加业务组
@interface BusinessGroupViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *businessTableview;
    
}

@property (nonatomic,retain)NSArray *arr;
@end

@implementation BusinessGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"业务部";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    ///<<<<<<
    UIButton *letfbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    letfbtn.frame =CGRectMake(0, 0, 28,28);
    [letfbtn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [letfbtn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:letfbtn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    //+
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(self.view.frame.size.width-30, 0, 28, 28);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"tj_ico02"] forState:UIControlStateNormal];
    [rightBtn addTarget: self action: @selector(buttonrightItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem2=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=buttonItem2;
    _arr = [[NSArray alloc]initWithObjects:@"业务组1",@"业务组2",@"业务组3",@"业务组4",nil];
    [self InterTableUI];
}
-(void)buttonrightItem{
    AddBusinessViewController *AddBusinessVC =[[AddBusinessViewController alloc]init];
    [self.navigationController pushViewController:AddBusinessVC animated:YES];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)InterTableUI
{
    businessTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,20,self.view.bounds.size.width,self.view.bounds.size.height+29) style:UITableViewStylePlain];
    businessTableview.dataSource=self;
    businessTableview.delegate =self;
    businessTableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:businessTableview];
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = GetColor(201, 201, 201, 1);
    [businessTableview addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.bottom.equalTo(businessTableview.mas_top).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [businessTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    cell.textLabel.text = _arr[indexPath.row];
    return cell;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    
    view.backgroundColor =GetColor(201, 201, 201, 1);
    
    
    return view;
    
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
