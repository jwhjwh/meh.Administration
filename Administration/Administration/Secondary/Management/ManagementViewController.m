//
//  ManagementViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "ManagementViewController.h"
#import "EditDataViewController.h"
#import "LVFmdbTool.h"
#import "AlertViewExtension.h"
@interface ManagementViewController ()<UITableViewDataSource,UITableViewDelegate,alertviewExtensionDelegate>
{
    AlertViewExtension *alert;
    UITableView *tableview;
}

@property (strong,nonatomic) NSArray *InterNameAry;
@property (strong,nonatomic) UILabel *NameLabel;//姓名
@property (strong,nonatomic) UILabel *TelLabel;//账号
@property (strong,nonatomic) UIView *view1;//一条线
@property (strong,nonatomic) UIView *view2;//二条线


@end

@implementation ManagementViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"账号管理";
    [self ManafementUI];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setExtraCellLineHidden:tableview];
    _InterNameAry = [[NSArray alloc]initWithObjects:@"个人信息",@"退出当前帐号",nil];
   
}

-(void)ManafementUI{
    
    _view1 = [[UIView alloc]init];
    _view1.backgroundColor = [UIColor colorWithRed:(188/255.0) green:(176/255.0) blue:(195/255.0) alpha:1];
    [self.view addSubview:_view1];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(85);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
    
    
    UIImageView *TXImage = [[UIImageView alloc]init];
    NSString *logoStr = [USER_DEFAULTS  objectForKey:@"logoImage"];
    [TXImage sd_setImageWithURL:[NSURL URLWithString:logoStr] placeholderImage:[UIImage  imageNamed:@"tx23"]];
    TXImage.backgroundColor = [UIColor redColor];
    TXImage.layer.masksToBounds = YES;
    TXImage.layer.cornerRadius = 20.0;//设置圆角
    [self.view addSubview:TXImage];
    [TXImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(90);
        make.left.equalTo (self.view.mas_left).offset (10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    _NameLabel = [[UILabel alloc]init];
    _NameLabel.text =[USER_DEFAULTS  objectForKey:@"name"];
    _NameLabel.textColor = [UIColor blackColor];
    [self.view addSubview:_NameLabel];
    [_NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(TXImage.mas_top).offset(0);
        make.left.equalTo(TXImage.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    _TelLabel = [[UILabel alloc]init];
    _TelLabel.text = [USER_DEFAULTS  objectForKey:@"phone"];
    _TelLabel.textColor = [UIColor colorWithRed:(188/255.0) green:(176/255.0) blue:(195/255.0) alpha:1];
    _TelLabel.font = [UIFont boldSystemFontOfSize:10.6f];
    [self.view addSubview:_TelLabel];
    [_TelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_NameLabel.mas_bottom).offset(10);
        make.left.equalTo(TXImage.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    UIImageView *xuanzeView = [[UIImageView alloc]init];
    xuanzeView.image = [UIImage imageNamed:@"xuanzezhanghao"];
    [self.view addSubview:xuanzeView];
    [xuanzeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(TXImage.mas_top).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    _view2 = [[UIView alloc]init];
    _view2.backgroundColor = [UIColor colorWithRed:(188/255.0) green:(176/255.0) blue:(195/255.0) alpha:1];
    [self.view addSubview:_view2];
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(_TelLabel.mas_bottom).offset(3);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 145,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    tableview.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    tableview.scrollEnabled =NO;
    tableview.dataSource=self;
    tableview.delegate =self;
    [self.view addSubview:tableview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return _InterNameAry.count;
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
        
    }
    cell.textLabel.text = _InterNameAry[indexPath.row];
    
    if ([cell.textLabel.text  isEqual: @"个人信息"]) {
       cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
       
    
    };
    return cell;
    
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        EditDataViewController *EditVC = [[EditDataViewController alloc]init];
         [self.navigationController showViewController:EditVC sender:nil];
    }else{
        alert =[[AlertViewExtension alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
        alert.delegate=self;
        [alert setbackviewframeWidth:300 Andheight:150];
        [alert settipeTitleStr:@"是否退出账号?" Andfont:14];
        [self.view addSubview:alert];
      
    }
    
}
-(void)clickBtnSelector:(UIButton *)btn
{
    if (btn.tag == 2000) {
        [alert removeFromSuperview];
    }else{
        [USER_DEFAULTS  setObject:@"" forKey:@"token"];
        ViewController *VC= [[ViewController alloc]init];
        [self presentViewController:VC animated:YES completion:nil];
        [LVFmdbTool deleteData:nil];
         [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Launch"];
    }
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
