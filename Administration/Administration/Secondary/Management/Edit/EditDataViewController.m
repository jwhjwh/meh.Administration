//
//  EditDataViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "EditDataViewController.h"
#import "EditModel.h"
#import "inftionTableViewCell.h"
#import "DateEditViewController.h"//编辑页面


@interface EditDataViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,retain)UITableView *infonTableview;
@property (nonatomic,retain)NSMutableArray *infoArray;
@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,retain)NSString *logImage;//头像
@property (nonatomic,assign) BOOL hide;
@property (nonatomic,assign) BOOL Open;

@property (nonatomic,strong) NSMutableArray *theValueAry;

@end

@implementation EditDataViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [self loadDataFromServer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人信息";
    
    [self InterTableUI];
    [self loadDataFromServer];
    // Do any additional setup after loading the view.
}
-(void)InterTableUI
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"编辑"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(masgegeClick)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    _infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height+64) style:UITableViewStylePlain];
    _infonTableview.dataSource=self;
    _infonTableview.delegate =self;
    [self.view addSubview:_infonTableview];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)masgegeClick{
    
    
    DateEditViewController *DateEditVC = [[DateEditViewController alloc]init];
    DateEditVC.InterNameAry = _theValueAry;
    [self.navigationController showViewController:DateEditVC sender:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _arr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_arr[section]count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{ if (section == 0 ){
    return 10;
}
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0){
        return 80;
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    inftionTableViewCell *cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    if (indexPath.section==0) {
        UIImageView *TXImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80, 20, 40, 40)];
        [TXImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,_logImage]] placeholderImage:[UIImage  imageNamed:@"tx23"]];
        TXImage.backgroundColor = [UIColor whiteColor];
        TXImage.layer.masksToBounds = YES;
        TXImage.layer.cornerRadius = 20.0;//设置圆角
        [cell addSubview:TXImage];
    }
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    cell.mingLabel.text=_arr[indexPath.section][indexPath.row];
    
    if (indexPath.section>0) {
        cell.xingLabel.text=[NSString stringWithFormat:@"%@",_infoArray[indexPath.section-1][indexPath.row]];
    }
    
    return cell;
}

-(void)loadDataFromServer{
    // [USER_DEFAULTS setObject:companyinfoid forKey:@"companyinfoid"];
    NSString *uStr =[NSString stringWithFormat:@"%@user/queryUserInfo.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *companyinfoid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid};
    
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        _infoArray=[NSMutableArray array];
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            EditModel *model = [[EditModel alloc]init];
            [model setValuesForKeysWithDictionary:[NSDictionary changeType:responseObject[@"userInfo"]]];
            if (model.birthday.length>0) {
                 model.birthday = [model.birthday substringToIndex:10];
            }
            _logImage=model.icon;
            if ([model.roleId isEqual:@"6"]||[model.roleId isEqual:@"2"]) {
                _arr=@[@[@"头像"],@[@"账号",@"职位",@"所属品牌"],@[@"真实姓名",@"出生日期",@"年龄",@"身份证号",@"现住地址"],@[@"手机号",@"微信号",@"QQ号"],@[@"兴趣爱好",@"个人签名"]];
                
                NSArray *arr=@[model.account,model.NewName,model.departmentName,];
                NSArray *arr1=@[model.name,model.birthday,model.age,model.idNo,model.address];
                NSArray *arr2=@[model.account,model.wcode,model.qcode];
                NSArray *arr3=@[model.interests,model.sdasd];
                NSArray *arr4 =@[model.birthday,model.age,model.idNo,model.address];
                _infoArray = [[NSMutableArray alloc]initWithObjects:arr,arr1,arr2,arr3,nil];
                _theValueAry = [[NSMutableArray alloc]initWithObjects:arr4,arr2,arr3, nil];
            }else{
                _arr=@[@[@"头像"],@[@"账号",@"职位"],@[@"真实姓名",@"出生日期",@"年龄",@"身份证号",@"现住地址"],@[@"手机号",@"微信号",@"QQ号"],@[@"兴趣爱好",@"个人签名"]];
                NSArray *arr=@[model.account,model.NewName];
                NSArray *arr1=@[model.name,model.birthday,model.age,model.idNo,model.address];
                NSArray *arr2=@[model.account,model.wcode,model.qcode];
                NSArray *arr3=@[model.interests,model.sdasd];
                NSArray *arr4 =@[model.birthday,model.age,model.idNo,model.address];
                _infoArray = [[NSMutableArray alloc]initWithObjects:arr,arr1,arr2,arr3,nil];
                _theValueAry = [[NSMutableArray alloc]initWithObjects:arr4,arr2,arr3, nil];
                
            }
            [_infonTableview reloadData];
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"异地登陆,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" sureBtn:@"确认" cancleBtn:nil];
            alertView.resultIndex = ^(NSInteger index){
                [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }else  {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"网络错误,获取个人信息失败" andInterval:1.0];

        }
    }
               failure:^(NSError *error) {
               }
                  view:self.view MBPro:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
