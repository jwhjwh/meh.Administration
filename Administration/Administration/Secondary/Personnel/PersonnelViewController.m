//
//  PersonnelViewController.m
//  Administration
//  联系人->>各部门人员
//  Created by 九尾狐 on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//
#import "PersonnelViewController.h"
#import "PersonneTableViewCell.h"
#import "inftionxqController.h"
#import "SearchViewController.h"
#import "PersonModel.h"
#import "LVModel.h"
#import "LVFmdbTool.h"
@interface PersonnelViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (strong,nonatomic) UIButton *sousuoBtn;//搜索框
@property (strong,nonatomic) NSMutableArray *InterNameAry;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)int a;
@end

@implementation PersonnelViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _a = _roleld.intValue;
    switch (_a) {
        case 2:
            self.navigationItem.title=@"市场人员";
            break;
        case 5:
            self.navigationItem.title=@"业务人员";
            break;
        case 3:
            self.navigationItem.title=@"内勤人员";
            break;
        case 4:
            self.navigationItem.title=@"物流人员";
            break;
        default:
            break;
    }
    
    [self ManafementUI];
    [self loadDataFromServer];
    self.view.backgroundColor = [UIColor whiteColor];
   [self setExtraCellLineHidden:self.tableView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)ManafementUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    //搜索按钮
    _sousuoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sousuoBtn.frame =CGRectMake(10,70,self.view.frame.size.width-20,40);
    UIImage *imageBtn = [UIImage imageNamed:@"ss_ico01"];
    [_sousuoBtn setBackgroundImage:imageBtn forState:UIControlStateNormal];
    _sousuoBtn.layer.masksToBounds = YES;
    _sousuoBtn.layer.cornerRadius = 8.0;
    [_sousuoBtn addTarget:self action:@selector(Touchsearch)forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:_sousuoBtn];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 134,self.view.bounds.size.width,1)];
    view.backgroundColor=GetColor(216, 216, 216, 1);
    [self.view addSubview:view];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 135,self.view.bounds.size.width,self.view.bounds.size.height-135) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonneTableViewCell" bundle:nil] forCellReuseIdentifier:@"CARRY"];


}
-(void)loadDataFromServer{
    NSString *uStr =[NSString stringWithFormat:@"%@user/findAllUser.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"roleId":_roleld};
    
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        _InterNameAry=[NSMutableArray array];
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *resuAry = responseObject[@"userList"];
            for (NSDictionary *newDict in resuAry) {
                PersonModel *model = [[PersonModel alloc]init];
                [model setValuesForKeysWithDictionary:newDict];
                [self.InterNameAry addObject:model];
            }
            [self.tableView reloadData];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到联系人" andInterval:1.0];
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }

    }failure:^(NSError *error) {
        
    }
    view:self.view MBPro:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CARRY" forIndexPath:indexPath];
    PersonModel *model= _InterNameAry[indexPath.row];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    [cell loadDataFromModel:model];
   
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    return cell;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return _InterNameAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   PersonModel *pmodel =self.InterNameAry[indexPath.row];
    
   
    //首先,需要获取沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 拼接图片名为"currentImage.png"的路径
    NSString *imageFilePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"currentImage%d%ld.png",_a,indexPath.row]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString: [NSString stringWithFormat:@"%@%@",KURLHeader,pmodel.icon]]];
    //转换为图片保存到以上的沙盒路径中
    UIImage * currentImage = [UIImage imageWithData:data];
    //其中参数0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
    [UIImageJPEGRepresentation(currentImage, 0.5) writeToFile:imageFilePath  atomically:YES];
    NSString * imgData = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"currentImage%d%ld.png",_a,indexPath.row]];
    NSString *fuzzyQuerySql = [NSString stringWithFormat:@"SELECT * FROM t_modals WHERE ID_No = %@", pmodel.usersid];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSArray *modals = [LVFmdbTool queryData:fuzzyQuerySql];
    if (modals.count>0) {
        NSString *delesql = [NSString stringWithFormat:@"DELETE FROM t_modals WHERE ID_No = %@",pmodel.usersid];
        [LVFmdbTool deleteData:delesql];
    }
    LVModel *models = [LVModel modalWith:pmodel.name call:[NSString stringWithFormat:@"%ld",pmodel.account] no:pmodel.usersid image:imgData time:dateString roleld:pmodel.NewName];
        BOOL isInsert =  [LVFmdbTool insertModel:models];
    if (isInsert) {
     NSLog(@"插入数据成功");
    } else {
        NSLog(@"插入数据失败");
    }
    inftionxqController *imftionVC=[[inftionxqController alloc]init];
    imftionVC.IDStr=pmodel.usersid;
    [self.navigationController pushViewController:imftionVC animated:YES];

}
-(void)Touchsearch{
    SearchViewController *SearchVC = [[SearchViewController alloc]init];
    SearchVC.roleId=_roleld;
    [self.navigationController showViewController:SearchVC sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
