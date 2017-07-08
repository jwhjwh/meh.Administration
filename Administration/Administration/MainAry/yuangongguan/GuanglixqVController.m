//
//  GuanglixqVController.m
//  Administration
//
//  Created by 九尾狐 on 2017/6/30.
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
#import "BJZWViewController.h"
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

@property (nonatomic,retain) NSMutableArray *codeeAry;//->>>

@property (nonatomic,retain)NSMutableArray *ZWAry;//职位名字
@property (nonatomic,retain)NSMutableArray *ZWnumAry;//职位id
@property (nonatomic,retain)NSMutableArray *ZWLBnumAry;//职位类别id
@property (nonatomic,retain)NSMutableArray *ZWLBAry;//职位类别名字
@property (nonatomic,retain)NSMutableArray *BMAry;//部门名字
@property (nonatomic,retain)NSMutableArray *BMNumAry;//部门id

@end

@implementation GuanglixqVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"员工管理";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _ZWAry = [[NSMutableArray alloc]init];
    _ZWLBAry = [[NSMutableArray alloc]init];
    _BMAry = [[NSMutableArray alloc]init];
    _BMNumAry = [[NSMutableArray alloc]init];
    _ZWnumAry = [[NSMutableArray alloc]init];
    _ZWLBnumAry = [[NSMutableArray alloc]init];
    
    _codeeAry = [[NSMutableArray alloc]init];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    _infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height+64) style:UITableViewStylePlain];
    _infonTableview.dataSource=self;
    _infonTableview.delegate =self;
    [ZXDNetworking setExtraCellLineHidden:_infonTableview];
    [self.view addSubview:_infonTableview];
    [self loadData];
}
#pragma mark - 网络请求
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
            NSMutableArray *array=[NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"list2"]) {
                NSMutableArray *array2=[NSMutableArray array];
                NSMutableArray *zwlbary = [NSMutableArray array];//职位类别
                NSMutableArray *zwlbnumary = [NSMutableArray array];//职位类别id
                NSMutableArray *zwary = [NSMutableArray array];//职位
                NSMutableArray *zwnumary = [NSMutableArray array];//职位id
                NSMutableArray *bmnumary = [NSMutableArray array];//部门id
                NSMutableArray *bmary = [NSMutableArray array];//部门
                [model setValuesForKeysWithDictionary:[NSDictionary changeType:dic]];
                
                NSString *string = [[NSString alloc] initWithFormat:@"%@",model.roleId];
                [array addObject:@"职位"];
                [array2 addObject:@"职位"];
                if ([string isEqualToString:@"2"]||[string isEqualToString:@"5"]) {
                    [array addObject:@"所属部门"];
                    [array2 addObject:@"所属部门"];
                }else{
                    [array addObject:@"管理部门"];
                    [array2 addObject:@"管理部门"];
                }
                [_codeeAry addObject:array2];
                
                if ([model.LevelName isEqualToString:@""]) {
                    [_departarr addObject:model.NewName];
                    
                    [zwlbary addObject:@"未分配"];//职位类别
                    [zwlbnumary addObject:@"0"];//职位类别id
                    
                    [_ZWLBAry addObject:zwlbary];
                    [_ZWLBnumAry addObject:zwlbnumary];
                    
                    [zwary addObject:model.NewName];//职位
                    [zwnumary addObject:model.roleId];//职位id
                    
                    [_ZWAry addObject:zwary];
                    [_ZWnumAry addObject:zwnumary];
                    
                }else{
                    [_departarr addObject:[NSString stringWithFormat:@"%@(%@)",model.NewName,model.LevelName]];
                    [zwary addObject:model.NewName];//职位
                    [zwnumary addObject:model.roleId];//职位id
                    
                    [_ZWAry addObject:zwary];
                    [_ZWnumAry addObject:zwnumary];
                    
                    [_ZWLBAry addObject:model.LevelName];//职位类别
                    [_ZWLBnumAry addObject:model.levelID];//职位类别id
                    
                }
                if ([model.departmentName isEqualToString:@""]) {
                    model.departmentName=@"未分配";
                    [_departarr addObject:model.departmentName];
                    
                    [bmary addObject:model.departmentName];
                    [_BMAry addObject:bmary];//部门
                    
                    [bmnumary addObject:@"0"];
                    [_BMNumAry addObject:bmnumary];//部门id
                    
                    
                }else if([model.departmentName containsString:@","]){
                    NSArray* array = [model.departmentName componentsSeparatedByString:@","];
                    NSArray* numarray = [model.departmentID componentsSeparatedByString:@","];
                    [_departarr addObject:array];
                    
                    [_BMAry addObject:array];//部门
                    
                    [_BMNumAry addObject:numarray];//部门id
                    
                }else{
                    [_departarr addObject:model.departmentName];
                    [bmary addObject:model.departmentName];
                    [_BMAry addObject:bmary];//部门
                    
                    [bmnumary addObject:model.departmentID];
                    [_BMNumAry addObject:bmnumary];//部门id
                    
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
            _arr=@[@[@"头像"],@[@"账号",@"真实姓名"],array,@[@"冻结账户",@"重置密码",@"删除账号"],@[@"查看位置"]];
            _infoArray = [[NSMutableArray alloc]initWithObjects:model.account,model.name,nil];
            [self.infonTableview reloadData];
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"获取员工信息失败" andInterval:1.0];
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
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"获取员工信息失败" andInterval:1.0];
        }
    }failure:^(NSError *error) {
        
    }view:self.view MBPro:YES];
}
#pragma mark tableView
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
#pragma mark 列表设置
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
    return 35;
}
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section==1){
        UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0,Scree_width, 30)];
        
        headV.backgroundColor = GetColor(247,247,247,1);
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 30)];
        lab.text=@"职位";
        lab.font = [UIFont systemFontOfSize:14.0f];
        [headV addSubview:lab];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake(Scree_width-50,2,28,30);
        [btn setBackgroundImage:[UIImage imageNamed:@"bj_ico01"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"bj_ico02"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget: self action: @selector(buttonsender:) forControlEvents: UIControlEventTouchUpInside];
        [headV addSubview:btn];
        return headV;
    }
    return nil;
}
- (void)button1BackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = GetColor(205,176,218,1);
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
                    if (index == 2) {
                        [self shanchuyuangong ];
                    }
                    
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
#pragma mark 删除员工
-(void)shanchuyuangong{
    NSString *uStr =[NSString stringWithFormat:@"%@user/deluser.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *comp = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"userid":_uresID,@"CompanyInfoId":comp};
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
        }
        
    }failure:^(NSError *error) {
        
    }view:self.view MBPro:YES];
}

#pragma mark - 返回
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)buttonsender:(UIButton *)sender
{
    sender.backgroundColor = GetColor(247,247,247,1);
    
   
    
    
    BJZWViewController *BJZWVC = [[BJZWViewController alloc]init];
    
    BJZWVC.ZW = _ZWAry;//职位
    BJZWVC.Numm = _ZWnumAry;//职位id
    BJZWVC.ZWLB = _ZWLBAry;//职位类别
    BJZWVC.lbNum = _ZWLBnumAry;//职位类别id
    BJZWVC.gxbmAry = _BMAry;//部门
    BJZWVC.gxbmidAry = _BMNumAry;//部门id
    BJZWVC.codeAry = _codeeAry;
    [self.navigationController pushViewController:BJZWVC animated:YES];
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
