//
//  inftionxqController.m
//  Administration
//
//  Created by zhang on 2017/2/25.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "inftionxqController.h"
#import "inftionTableViewCell.h"
#import "AlertViewExtension.h"
#import "EditModel.h"
@interface inftionxqController ()<UITableViewDelegate,UITableViewDataSource,alertviewExtensionDelegate>
{
     AlertViewExtension *alert;
}
@property (nonatomic,retain)UITableView *infonTableview;
@property (nonatomic,retain)NSMutableArray *infoArray;
@property (nonatomic,retain)NSArray *arr;

@end

@implementation inftionxqController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"信息";
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
    [self loadDataFromServer ];
  
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
    return 0;
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
        [TXImage sd_setImageWithURL:[NSURL URLWithString:@"tx23"] placeholderImage:[UIImage  imageNamed:@"tx23"]];
        TXImage.backgroundColor = [UIColor whiteColor];
        TXImage.layer.masksToBounds = YES;
        TXImage.layer.cornerRadius = 20.0;//设置圆角
        [cell addSubview:TXImage];
    }
    if (indexPath.section==0&&indexPath.row==0) {
        UIButton *TXImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [TXImage setImage:[UIImage imageNamed:@""] forState: UIControlStateNormal];
        [TXImage addTarget:self action:@selector(callIphone:) forControlEvents:UIControlEventTouchUpInside];
        TXImage.frame=CGRectMake(self.view.bounds.size.width-80,cell.center.y, 40, 40);
        [cell addSubview:TXImage];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    cell.mingLabel.text=_arr[indexPath.section][indexPath.row];
    cell.xingLabel.text=self.infoArray[indexPath.section][indexPath.row];
    return cell;
}
//打电话
-(void)callIphone:(UIButton*)sender{
    alert =[[AlertViewExtension alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
    alert.delegate=self;
    [alert setbackviewframeWidth:300 Andheight:150];
    [alert settipeTitleStr:@"是否拨打电话?" Andfont:14];
    [self.view addSubview:alert];
}
-(void)clickBtnSelector:(UIButton *)btn
{
    if (btn.tag == 2000) {
        [alert removeFromSuperview];
    }else{
//        NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",isnumber];
//        //而这个方法则打电话前先弹框 是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    }
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadDataFromServer{
    NSString *uStr =[NSString stringWithFormat:@"%@user/queryUserInfo.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"id":_roleld};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        _infoArray=[NSMutableArray array];
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            EditModel *model = [[EditModel alloc]init];
            [model setValuesForKeysWithDictionary:responseObject[@"userInfo"]];
            model.birthday = [model.birthday substringToIndex:10];
            if ([model.roleId isEqualToString:@"6"]||[model.roleId isEqualToString:@"2"]) {
                _arr=@[@[@"头像"],@[@"账号",@"职位",@"所属品牌"],@[@"真实姓名",@"出生日期",@"年龄",@"身份证号",@"现住地址"],@[@"手机号",@"微信号",@"QQ号"],@[@"兴趣爱好",@"个人签名"]];
                
                NSArray *arr=@[model.account,model.rname,model.brandName,];
                NSArray *arr1=@[model.name,model.birthday,model.age,model.idNo,model.address];
                NSArray *arr2=@[model.account,model.wcode,model.qcode];
                NSArray *arr3=@[model.interests,model.sdasd];
                _infoArray = [[NSMutableArray alloc]initWithObjects:@"",arr,arr1,arr2,arr3,nil];
            }else{
                _arr=@[@[@"头像"],@[@"账号",@"职位"],@[@"真实姓名",@"出生日期",@"年龄",@"身份证号",@"现住地址"],@[@"手机号",@"微信号",@"QQ号"],@[@"兴趣爱好",@"个人签名"]];
                NSArray *arr=@[model.account,model.rname];
                NSArray *arr1=@[model.name,model.birthday,model.age,model.idNo,model.address];
                NSArray *arr2=@[model.account,model.wcode,model.qcode];
                NSArray *arr3=@[model.interests,model.sdasd];
                _infoArray = [[NSMutableArray alloc]initWithObjects:@"",arr,arr1,arr2,arr3,nil];
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



@end
