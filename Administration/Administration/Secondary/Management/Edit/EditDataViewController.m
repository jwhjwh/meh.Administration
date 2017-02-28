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

@property (nonatomic,retain)UIButton *masgeButton; //编辑提交按钮


@property (nonatomic,retain)UITableView *infonTableview;
@property (nonatomic,retain)NSMutableArray *infoArray;
@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,retain)NSString *logImage;//头像
@property (nonatomic,assign) BOOL hide;
@property (nonatomic,assign) BOOL Open;

@end

@implementation EditDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人信息";
    
    [self InterTableUI];
    [self loadDataFromServer];
    // Do any additional setup after loading the view.
}
-(void)InterTableUI
{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"编辑"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(masgegeClick)];
    self.navigationItem.rightBarButtonItem = leftButton;
    
    _infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height+64) style:UITableViewStylePlain];
    _infonTableview.dataSource=self;
    _infonTableview.delegate =self;
    [self.view addSubview:_infonTableview];
    
    
       
    
}
-(void)masgegeClick{
    DateEditViewController *DateEditVC = [[DateEditViewController alloc]init];
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
    NSString *uStr =[NSString stringWithFormat:@"%@user/queryUserInfo.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],};
    
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        _infoArray=[NSMutableArray array];
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            EditModel *model = [[EditModel alloc]init];
            [model setValuesForKeysWithDictionary:[NSDictionary changeType:responseObject[@"userInfo"]]];
            model.birthday = [model.birthday substringToIndex:10];
            _logImage=model.icon;
            if ([model.roleId isEqualToString:@"6"]||[model.roleId isEqualToString:@"2"]) {
                _arr=@[@[@"头像"],@[@"账号",@"职位",@"所属品牌"],@[@"真实姓名",@"出生日期",@"年龄",@"身份证号",@"现住地址"],@[@"手机号",@"微信号",@"QQ号"],@[@"兴趣爱好",@"个人签名"]];
                
                NSArray *arr=@[model.account,model.rname,model.brandName,];
                NSArray *arr1=@[model.name,model.birthday,model.age,model.idNo,model.address];
                NSArray *arr2=@[model.account,model.wcode,model.qcode];
                NSArray *arr3=@[model.interests,model.sdasd];
                _infoArray = [[NSMutableArray alloc]initWithObjects:arr,arr1,arr2,arr3,nil];
            }else{
                _arr=@[@[@"头像"],@[@"账号",@"职位"],@[@"真实姓名",@"出生日期",@"年龄",@"身份证号",@"现住地址"],@[@"手机号",@"微信号",@"QQ号"],@[@"兴趣爱好",@"个人签名"]];
                NSArray *arr=@[model.account,model.rname];
                NSArray *arr1=@[model.name,model.birthday,model.age,model.idNo,model.address];
                NSArray *arr2=@[model.account,model.wcode,model.qcode];
                NSArray *arr3=@[model.interests,model.sdasd];
                _infoArray = [[NSMutableArray alloc]initWithObjects:arr,arr1,arr2,arr3,nil];
            }
            
            [_infonTableview reloadData];
        } else  {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"网络错误" andInterval:1.0];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
