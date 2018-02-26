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
@property (nonatomic,retain)NSMutableArray *arr;
@property (nonatomic,retain)NSString *logImage;//头像
@property (nonatomic,assign) BOOL hide;
@property (nonatomic,assign) BOOL Open;

@property (nonatomic,strong) NSMutableArray *theValueAry;
@property (nonatomic,strong) NSString *flag;
@property (nonatomic,strong) NSDictionary *dictinfo;

@end

@implementation EditDataViewController

-(void)viewWillAppear:(BOOL)animated
{
   
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
    
    _infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
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
    DateEditVC.flag= self.flag;
    DateEditVC.dictinfo = self.dictinfo;
    [self.navigationController showViewController:DateEditVC sender:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return 80;
    }else{
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    inftionTableViewCell *cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    if (indexPath.row==0) {
        UIImageView *TXImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80, 20, 40, 40)];
        [TXImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLImage,_logImage]] placeholderImage:[UIImage  imageNamed:@"tx23"]];
        TXImage.backgroundColor = [UIColor whiteColor];
        TXImage.layer.masksToBounds = YES;
        TXImage.layer.cornerRadius = 20.0;//设置圆角
        [cell addSubview:TXImage];
    }else{
      
        cell.xingLabel.text=[NSString stringWithFormat:@"%@",_infoArray[indexPath.row]];
    }
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    cell.mingLabel.text=_arr[indexPath.row];
    
    
    
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
            self.flag = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"userInfo"][@"flag"]];
            self.dictinfo = [responseObject valueForKey:@"userInfo"];
            EditModel *model = [[EditModel alloc]init];
            [model setValuesForKeysWithDictionary:[NSDictionary changeType:responseObject[@"userInfo"]]];
            _infoArray = [[NSMutableArray alloc]init];
            _arr  =[[NSMutableArray alloc]init];

            
             _logImage=model.icon;
            
            [_arr addObject:@"头像"];
            [_infoArray addObject:@""];
            [_arr addObject:@"账号"];
            [_infoArray addObject:model.account];
            [_arr addObject:@"真实姓名"];
            [_infoArray addObject:model.name];
            //--------------------------------
            NSArray *array=[responseObject[@"userInfo"] valueForKey:@"list"];
            for (NSDictionary *dic in array) {
                [_arr addObject:@"职位"];
                [_infoArray addObject:dic[@"newName"]];
                if ([dic[@"roleId"]integerValue] == 2||[dic[@"roleId"]integerValue] == 5||[dic[@"roleId"]integerValue] == 3||[dic[@"roleId"]integerValue] == 4||[dic[@"roleId"]integerValue] == 14||[dic[@"roleId"]integerValue] == 16||[dic[@"roleId"]integerValue] == 17) {
                   [_arr addObject:@"所属部门"];
                }else{
                    [_arr addObject:@"管辖部门"];
                }
                if ([dic[@"departmentName"] isKindOfClass:[NSNull class]]) {
                    [_infoArray addObject:@"暂无部门"];
                }else{
                    [_infoArray addObject:dic[@"departmentName"]];
                }
                
                
            }
            
            
            
            
            
            
            //--------------------------------
            [_arr addObject:@"出生日期"];
            
            
            NSString *brithday = @"";
            
            
            if ([[NSString stringWithFormat:@"%@",model.flag] isEqualToString:@"2"]) {
                brithday = model.solarBirthday;
            }else
            {
                brithday = model.lunarBirthday;
            }
            [_infoArray addObject:brithday];
            
            [_arr addObject:@"年龄"];
             [_infoArray addObject:model.age];
            [_arr addObject:@"现住地址"];
             [_infoArray addObject:model.address];
            [_arr addObject:@"手机号"];
            [_infoArray addObject:model.phone];
            [_arr addObject:@"微信号"];
            [_infoArray addObject:model.wcode];
            [_arr addObject:@"QQ号"];
            [_infoArray addObject:model.qcode];
            [_arr addObject:@"兴趣爱好"];
            [_infoArray addObject:model.interests];
            [_arr addObject:@"个人签名"];
            [_infoArray addObject:model.sdasd];
            
            NSArray *arr3=@[model.interests,model.sdasd];
            NSArray *arr4 =@[brithday,model.age,model.address];
            NSArray *arr2 = [[NSArray alloc]init];
            if (model.phone.length>1) {
                arr2=@[model.phone,model.wcode,model.qcode];
            }else{
                arr2=@[model.account,model.wcode,model.qcode];
            }
            _theValueAry = [[NSMutableArray alloc]initWithObjects:arr4,arr2,arr3, nil];

            
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
