//
//  SecurityViewController.m
//  Administration
//  账号安全
//  Created by 九尾狐 on 2017/2/17.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "SecurityViewController.h"
#import "LockSettingViewController.h"//手势锁
#import "ModifyViewController.h"//修改密码
#import "EmailViewController.h"//解除绑定邮箱
#import "IntercalateController.h"

@interface SecurityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
}

@property (strong,nonatomic) NSArray *InterNameAry;
@property (strong,nonatomic) NSString *Emailstr;
@property(nonatomic,strong)UIAlertController *alert;


@end

@implementation SecurityViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title=@"账号安全";
    [self ManafementUI];
    [self setExtraCellLineHidden:tableview];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _InterNameAry = [[NSArray alloc]initWithObjects:@"手势密码锁定",@"修改密码",@"邮箱地址",nil];
    
   
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
        
    }
    cell.textLabel.text = _InterNameAry[indexPath.row];
    
    if ([cell.textLabel.text  isEqual: @"邮箱地址"]) {
       
        if (_emailYes == nil || _emailYes == NULL ||[_emailYes isEqualToString:@""]) {
            UILabel *BDLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80, 105, 40, 40)];
            BDLabel.text = @"未绑定";
            BDLabel.font = [UIFont boldSystemFontOfSize:10.6f];
            BDLabel.textColor = [UIColor RGBview];
            [tableview addSubview:BDLabel];
        }
        
            
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
    NSString *a = NSLocalizedString(@"修改邮箱地址", nil);
    NSString *b = NSLocalizedString(@"如果你改了邮箱地址，你需要对邮箱地址重新进行验证", nil);
    NSString *c = NSLocalizedString(@"取消绑定", nil);
    NSString *d = NSLocalizedString(@"申请绑定", nil);

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        [self.navigationController pushViewController:[[LockSettingViewController alloc] init] animated:YES];
    }
    
    else if (indexPath.row == 1){
        [self.navigationController pushViewController:[[ModifyViewController alloc]init] animated:YES];
    }else
    {
        if (_emailYes == nil || _emailYes == NULL ||[_emailYes isEqualToString:@""]) {
            self.alert = [UIAlertController alertControllerWithTitle:a message:b preferredStyle:UIAlertControllerStyleAlert];
            [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                
                textField.backgroundColor = [UIColor colorWithRed:252.0/35 green:255.0/123 blue:255.0/198 alpha:1];
                
                UIAlertAction *aa = [UIAlertAction actionWithTitle:c style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                }];
                UIAlertAction *bb = [UIAlertAction actionWithTitle:d style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    _Emailstr = textField.text;
                    
                    [self emailNTW];
                }];
                
                [self.alert addAction:aa];
                [self.alert addAction:bb];
            }];
            
            
            [self presentViewController:_alert animated:YES completion:nil];

        }else{
            EmailViewController *emailVc = [[EmailViewController alloc]init];
            emailVc.emailStr =_emailYes;
            [self.navigationController pushViewController:emailVc animated:YES];

        }
        
    }
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(void)emailNTW{
    NSString *uStr =[NSString stringWithFormat:@"%@user/bindingemail.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"emails":_Emailstr};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请前往邮箱进行验证" andInterval:1.0];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4000"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"邮箱已经被注册" andInterval:1.0];
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"3000"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"邮件发送失败" andInterval:1.0];
        }else
        {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时，请重新发送" andInterval:1.0];
        }
    } failure:^(NSError *error) {
        
    }view:self.view MBPro:YES];
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
