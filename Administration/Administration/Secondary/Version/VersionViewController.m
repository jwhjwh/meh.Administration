//
//  VersionViewController.m
//  Administration
//  版本信息
//  Created by 九尾狐 on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "VersionViewController.h"

@interface VersionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
}

@property (strong,nonatomic) NSArray *InterNameAry;
@property (strong,nonnull) NSString *BDStr;//有无更新
@property (strong,nonnull) NSString *BBGLXT;//名称字段
@property (strong,nonatomic) UIImageView *HeadView;//版本头像
@property (strong,nonatomic) UIView *view1;//一条线
@property (strong,nonatomic) UILabel *NameLabel;//版本名称
@end

@implementation VersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"版本信息";
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    _InterNameAry = [[NSArray alloc]initWithObjects:@"版本更新",@"功能介绍",@"帮助",nil];
    _BDStr = @"有新版本可更新";
    _BBGLXT = @"报表管理系统V 1.0";
    [self ManafementUI];
    [self setExtraCellLineHidden:tableview];

    // Do any additional setup after loading the view.
}
-(void)ManafementUI{
    
    _HeadView = [[UIImageView alloc]init];
    [_HeadView setImage:[UIImage imageNamed:@"banben100"]];
    _HeadView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_HeadView];
    [_HeadView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.left.equalTo(self.view.mas_centerX).offset(-50);
        make.right.equalTo(self.view.mas_centerX).offset(50);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    _NameLabel = [[UILabel alloc]init];
    _NameLabel.text = _BBGLXT;
    _NameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _NameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_NameLabel];
    [_NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_HeadView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
   
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 270,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    tableview.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    tableview.scrollEnabled =NO;
    tableview.dataSource=self;
    tableview.delegate =self;
    [self.view addSubview:tableview];
    
    _view1 = [[UIView alloc]init];
    _view1.backgroundColor = [UIColor colorWithRed:(188/255.0) green:(176/255.0) blue:(195/255.0) alpha:1];
    [self.view addSubview:_view1];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.bottom.equalTo(tableview.mas_top).offset(5);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
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
    cell.textLabel.text = _InterNameAry[indexPath.row];
    if ([cell.textLabel.text  isEqual: @"版本更新"]) {
         [cell setAccessoryType:UITableViewCellAccessoryNone];
        UILabel *BDLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80, 5, 100, 40)];
        BDLabel.text = _BDStr;
        BDLabel.font = [UIFont boldSystemFontOfSize:10.6f];
        BDLabel.textColor = [UIColor RGBview];
        [tableview addSubview:BDLabel];
    };
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
