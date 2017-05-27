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
#import "PerLomapController.h"
#import "depmtCell.h"
#import "EditModel.h"
#import "DongImage.h"
@interface GuanglixqVController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UITableView *infonTableview;
@property (nonatomic,retain)NSMutableArray *infoArray;
@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,retain)NSMutableArray *departarr;
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
    _infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    _infonTableview.dataSource=self;
    _infonTableview.delegate =self;
    _infonTableview.rowHeight = UITableViewAutomaticDimension;
    _infonTableview.estimatedRowHeight = 110;
   
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
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     if(section==1){
      UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0,Scree_width, 30)];
         
         headV.backgroundColor = GetColor(230,230,230,1);
         UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 30)];
         lab.text=@"职位";
         lab.font = [UIFont systemFontOfSize:14.0f];
         [headV addSubview:lab];
         UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
         btn.frame =CGRectMake(Scree_width-50,1,28,30);
         [btn setBackgroundImage:[UIImage imageNamed:@"bj_ico01"] forState:UIControlStateNormal];
         [btn addTarget: self action: @selector(buttonsender) forControlEvents: UIControlEventTouchUpInside];
         [headV addSubview:btn];
    return headV;
     }
      return nil;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = GetColor(230,230,230,1);
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    header.textLabel.textColor = [UIColor grayColor];
//    header.textLabel.font = [UIFont systemFontOfSize:14.0f];
}
//-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
//   
//    if(section==1){
//         return @" 职位";
//    }
//    return nil;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{ if (section == 0 ||section == 1){
    return 30;
}else if(section == 4){
     return 0;
}
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0){
        return 80;
    }else if(indexPath.section ==2){
        if (indexPath.row%2==0) {
           return 50;
        }else{
            id obj = _departarr[indexPath.row];
            if([obj isKindOfClass:[NSString class]]){
            return 50;
            }else{//不是字符串
            return 50+25*([_departarr[indexPath.row]count]-1)-5;
            }
        }
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    inftionTableViewCell *cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell == nil) {
        cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
     if (indexPath.section==4) {
        cell.imageView.image=[UIImage imageNamed:@"location_ico"];
        cell.textLabel.text=_arr[indexPath.section][indexPath.row];
    }else{
        cell.mingLabel.text=_arr[indexPath.section][indexPath.row];
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
    }else if (indexPath.section==1) {
        if (indexPath.row==0) {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(Scree_width-60,10,50, 30)];
            label.text=_state;
            label.font=[UIFont systemFontOfSize:14];
            [cell addSubview:label];
        }
        cell.xingLabel.text=[NSString stringWithFormat:@"%@",_infoArray[indexPath.row]];
    }else  if (indexPath.section==2) {
         if (indexPath.row%2==0) {
         cell.xingLabel.text=[NSString stringWithFormat:@"%@",_departarr[indexPath.row]];
         }else{
             id obj = _departarr[indexPath.row];
             if([obj isKindOfClass:[NSString class]]){
                 //此元素是字符串
                 cell.xingLabel.text=[NSString stringWithFormat:@"%@",_departarr[indexPath.row]];
             }else{//不是字符串
                 depmtCell *celled=[[depmtCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"depmCell" arr:_departarr[indexPath.row]];
                 celled.mLabel.text=_arr[indexPath.section][indexPath.row];
                 [celled setNeedsUpdateConstraints];
                 [celled updateConstraintsIfNeeded];
                 return celled;
             }
         }
    }
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3) {
        switch (indexPath.row) {
            case 0:{
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
            case 1:{
                xiugaiViewController *xiugaiVC=[[xiugaiViewController alloc]init];
                xiugaiVC.uresID=_uresID;
                xiugaiVC.callNum=_callNum;
                [self.navigationController pushViewController:xiugaiVC animated:YES];
            }
                break;
            case 2:{
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
    }else if(indexPath.section==4){

        PerLomapController *perLomaVC=[[PerLomapController alloc]init];
        perLomaVC.uesrId=_uresID;
        perLomaVC.name=_infoArray[1];
        perLomaVC.account=[NSString stringWithFormat:@"%@",_infoArray[0]];
        [self.navigationController pushViewController:perLomaVC animated:YES];
    }
}
-(void)loadData{
    NSString *uStr =[NSString stringWithFormat:@"%@user/queryUserBasicInfo.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":compid,@"id":_uresID};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            EditModel *model = [[EditModel alloc]init];
            _departarr=[NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"list2"]) {
            [model setValuesForKeysWithDictionary:[NSDictionary changeType:dic]];
                   [_departarr addObject:model.NewName];
                if ([model.departmentName isEqualToString:@""]) {
                    model.departmentName=@"未分配";
                     [_departarr addObject:model.departmentName];
                }else if([model.departmentName containsString:@","]){
                   
                  NSArray* array = [model.departmentName componentsSeparatedByString:@","];
                  [_departarr addObject:array];
                }else{
                    [_departarr addObject:model.departmentName];
                }
            
             
               
            }
            model.birthday = [model.birthday substringToIndex:10];
            _logImage=model.icon;
            _callNum=[NSString stringWithFormat:@"%@",model.account];
            _callName=model.name;
            if ( model.state==1) {
                _state=@"使用中";
            }else{
                _state=@"被冻结";
            }
            NSMutableArray *array=[NSMutableArray array];
            if ([model.NewName containsString:@"总监"]||[model.NewName containsString:@"经理"]) {
                for (int i=0;[responseObject[@"list2"]count]>i ; i++) {
                    [array addObject:@"职位"];
                    [array addObject:@"管理部门"];
                }
            }else{
                for (int i=0;[responseObject[@"list2"]count]>i ; i++) {
                    [array addObject:@"职位"];
                    [array addObject:@"所属部门"];
                }
            }
        _arr=@[@[@"头像"],@[@"账号",@"真实姓名"],array,@[@"冻结账户",@"重置密码",@"删除账号"],@[@"查看位置"]];
                
        _infoArray = [[NSMutableArray alloc]initWithObjects:model.account,model.name,nil];
            [self.infonTableview reloadData];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"获取员工信息失败" andInterval:1.0];
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
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"删除失败" andInterval:1.0];
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
        
    }view:self.view MBPro:YES];
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([self.infonTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.infonTableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.infonTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.infonTableview setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)imageViewGestureAction:(UIGestureRecognizer *)tap{
    [DongImage showImage:_TXImage];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
