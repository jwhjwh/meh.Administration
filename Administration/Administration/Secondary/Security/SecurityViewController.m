//
//  SecurityViewController.m
//  Administration
//  账号安全
//  Created by 九尾狐 on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "SecurityViewController.h"

@interface SecurityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
}

@property (strong,nonatomic) NSArray *InterNameAry;
@property (strong,nonnull) NSString *BDStr;
@end

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"账号安全";
    [self ManafementUI];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setExtraCellLineHidden:tableview];
    _InterNameAry = [[NSArray alloc]initWithObjects:@"手势密码锁定",@"修改密码",@"邮箱地址",nil];
    _BDStr = @"未绑定";
    // Do any additional setup after loading the view.
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
        NSLog(@"加上箭头了么");
    }
    cell.textLabel.text = _InterNameAry[indexPath.row];
    
    if ([cell.textLabel.text  isEqual: @"邮箱地址"]) {
        UILabel *BDLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80, 105, 40, 40)];
        BDLabel.text = _BDStr;
        BDLabel.font = [UIFont boldSystemFontOfSize:10.6f];
        BDLabel.textColor = [UIColor RGBview];
        [tableview addSubview:BDLabel];
        
    };
    //jwhdzkj
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
