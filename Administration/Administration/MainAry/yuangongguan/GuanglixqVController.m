//
//  GuanglixqVController.m
//  Administration
//
//  Created by zhang on 2017/3/4.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "GuanglixqVController.h"
#import "xiugaiViewController.h"
#import "dongjieViewController.h"
#import "inftionTableViewCell.h"
#import "EditModel.h"
#import "DongImage.h"
@interface GuanglixqVController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UITableView *infonTableview;
@property (nonatomic,retain)NSMutableArray *infoArray;
@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,retain)UIImageView *TXImage;
@property (nonatomic,retain)NSString *logImage;//头像
@property (nonatomic,retain)NSString *callNum;//电话
@property (nonatomic,retain)NSString *callName;//姓名
@property (nonatomic,retain)NSString *state;//状态
@end

@implementation GuanglixqVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"员工管理";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    _infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height+49) style:UITableViewStylePlain];
    _infonTableview.dataSource=self;
    _infonTableview.delegate =self;
    [self.view addSubview:_infonTableview];
    [ZXDNetworking setExtraCellLineHidden:_infonTableview];
    [self loadData];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
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
{ if (section == 1 ){
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
        _TXImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80, 20, 40, 40)];
        [_TXImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURLHeader,_logImage]] placeholderImage:[UIImage  imageNamed:@"tx23"]];
        _TXImage.userInteractionEnabled=YES;
        _TXImage.backgroundColor = [UIColor whiteColor];
        _TXImage.layer.masksToBounds = YES;
        _TXImage.layer.cornerRadius = 20.0;//设置圆角
        [cell addSubview:_TXImage];
        UITapGestureRecognizer *tapSingleGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewGestureAction:)];//添加单击的手势
        tapSingleGR.numberOfTapsRequired = 1; //设置单击几次才触发方法
        [_TXImage addGestureRecognizer:tapSingleGR];
        
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    cell.mingLabel.text=_arr[indexPath.section][indexPath.row];
    
    if (indexPath.section>0) {
        if (indexPath.row==0) {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(Scree_width-60,10,50, 30)];
            label.text=_state;
            label.font=[UIFont systemFontOfSize:14];
            [cell addSubview:label];
        }
        cell.xingLabel.text=[NSString stringWithFormat:@"%@",_infoArray[indexPath.section-1][indexPath.row]];
        if (indexPath.row>2) {
        cell.mingLabel.font=[UIFont systemFontOfSize:17];
        }
    }
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 3:{
                dongjieViewController *dongjieVC=[[dongjieViewController alloc]init];
                dongjieVC.state=_state;
                dongjieVC.uresID=_uresID;
                dongjieVC.stateBlock=^(NSString*str){
                    _state=str;
                    [_infonTableview reloadData];
                };
                [self.navigationController pushViewController:dongjieVC animated:YES];
            }
                
                break;
            case 4:{
                xiugaiViewController *xiugaiVC=[[xiugaiViewController alloc]init];
                xiugaiVC.uresID=_uresID;
                xiugaiVC.callNum=_callNum;
                [self.navigationController pushViewController:xiugaiVC animated:YES];
            }
                
                break;
            case 5:{
                PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"删除员工" message:@"确定要删除该员工吗" sureBtn:@"确认" cancleBtn:@"取消"];
                
                alertView.resultIndex = ^(NSInteger index){
                    [self shanchuyuangong ];
                };
                [alertView showMKPAlertView];
            }
                
                break;
            default:
                break;
        }
    }
}
-(void)loadData{
    NSString *uStr =[NSString stringWithFormat:@"%@user/queryinfo.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"id":_uresID};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
      
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            EditModel *model = [[EditModel alloc]init];
            [model setValuesForKeysWithDictionary:[NSDictionary changeType:responseObject[@"userInfo"]]];
            model.birthday = [model.birthday substringToIndex:10];
            _logImage=model.icon;
            _callNum=[NSString stringWithFormat:@"%@",model.account];
            _callName=model.name;
            if ( model.state==1) {
                _state=@"使用中";
            }else{
                _state=@"被冻结";
            }
            _arr=@[@[@"头像"],@[@"账号",@"职位",@"真实姓名",@"冻结账户",@"重置密码",@"删除账号"]];
            switch (model.roleId.intValue) {
                case 1:
                   model.rname=@"老板";
                    break;
                case 2:
                    //市场美导
                    model.rname=@"市场美导";
                    break;
                case 3:
                    //内勤人员
                    model.rname=@"内勤";
                    break;
                case 4:
                    // 物流
               model.rname=@"物流";
                    break;
                case 5:
                    //业务
              model.rname=@"业务";
                    break;
                case 6:
                    // 品牌经理
                model.rname=@"品牌经理";
                    break;
                case 7:
                    //行政管理员
                  model.rname=@"行政";
                    break;
                case 8:
                    //业务经理
                 model.rname=@"业务经理";
                    break;
                default:
                    break;
            }
        NSArray *arr=@[model.account,model.rname,model.name,@"",@"",@""];
           _infoArray = [[NSMutableArray alloc]initWithObjects:arr,nil];

            [self.infonTableview reloadData];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"获取员工信息失败" andInterval:1.0];
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]||[[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登陆超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
            
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
            
        }
        
    }failure:^(NSError *error) {
        
    }view:self.view MBPro:YES];
    
}
-(void)shanchuyuangong{
    NSString *uStr =[NSString stringWithFormat:@"%@user/deluser.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"userid":_uresID};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
             [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除成功" andInterval:1.0];
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
                self.Cellblock();
            });
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到联系人" andInterval:1.0];
        } else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]||[[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登陆超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
            
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
            
        }
        
    }failure:^(NSError *error) {
        
    }view:self.view MBPro:YES];
}




-(void)imageViewGestureAction:(UIGestureRecognizer *)tap{
    [DongImage showImage:_TXImage];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
