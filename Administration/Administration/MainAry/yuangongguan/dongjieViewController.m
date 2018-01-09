//
//  dongjieViewController.m
//  Administration
//
//  Created by zhang on 2017/3/4.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "dongjieViewController.h"
@interface dongjieViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    
    
    NSIndexPath* indPath;
}
@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,retain)UISwitch *gestureUnLockSwitch;
@property (nonatomic,retain)UISwitch *UnLockSwitch;
@property (nonatomic,retain)UILabel *label;
@end

@implementation dongjieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"冻结设置";
    self.view.backgroundColor =GetColor(230, 230, 230, 1);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buttonLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    _label=[[UILabel alloc]init];
    _label.text=[NSString stringWithFormat:@"账号状态:%@",_state];
    _label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_label];
    _arr = [[NSArray alloc]initWithObjects:@"解冻账号",@"冻结账户",nil];
    infonTableview =[[UITableView alloc]init];
     NSString* phoneModel = [UIDevice devicePlatForm];
    
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        _label.frame = CGRectMake(Scree_width/2-80, 94,160, 30);
       infonTableview.frame = CGRectMake(0,124, kScreenWidth, kScreenHeight-64);
    }else{
        _label.frame = CGRectMake(Scree_width/2-80, 74,160, 30);
        infonTableview.frame = CGRectMake(0,104, kScreenWidth, kScreenHeight-64);
    }
    infonTableview.scrollEnabled = NO;
    infonTableview.showsVerticalScrollIndicator = NO;
    infonTableview.delegate = self;
    infonTableview.dataSource = self;
    [self.view addSubview: infonTableview];
}
-(void)buttonLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row==0) {
        _gestureUnLockSwitch = [[UISwitch alloc] init];
        [_gestureUnLockSwitch addTarget:self action:@selector(gestureUnLockSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        _gestureUnLockSwitch.tag=indexPath.row;
        cell.accessoryView  = _gestureUnLockSwitch;
    }else{
        _UnLockSwitch = [[UISwitch alloc] init];
        [_UnLockSwitch addTarget:self action:@selector(gestureUnLockSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        _UnLockSwitch.tag=indexPath.row;
        cell.accessoryView  = _UnLockSwitch;
    }
    if ([_state isEqualToString:@"使用中"]) {
        if (indexPath.row==0) {
            _gestureUnLockSwitch.on = YES;
        }else{
            _UnLockSwitch.on=NO;
        }
    }else{
        if (indexPath.row==0) {
            _gestureUnLockSwitch.on = NO;
        }else{
            _UnLockSwitch.on = YES;
        }
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _arr[indexPath.row];
    return cell;
}
- (void)gestureUnLockSwitchChanged:(UISwitch *)sender{
    
    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"冻结员工" message:@"确定要设置冻结该员工吗" sureBtn:@"确认" cancleBtn:@"取消"];
    alertView.resultIndex = ^(NSInteger index){
        
        if (index == 1) {
            if ([_state isEqualToString:@"使用中"]) {
                if (sender.tag==0) {
                    _gestureUnLockSwitch.on = YES;
                }else{
                    _UnLockSwitch.on=NO;
                }
            }else{
                if (sender.tag==0) {
                    _gestureUnLockSwitch.on = NO;
                }else{
                    _UnLockSwitch.on = YES;
                }
            }
            
        }else if (index==2) {
            UITableViewCell *cell =(UITableViewCell*)[[sender superview]superview];
            indPath=[infonTableview indexPathForCell:cell];
            if (sender.tag==0) {
                if ([_state isEqualToString:@"使用中"]) {
                    [self xiugaishiyonzhuangtaicodeStr:@"0"];
                    __weak __typeof__(self) weakSelf = self;
                    self.Block=^(){
                        weakSelf.UnLockSwitch.on=YES;
                        _state=@"被冻结";
                        weakSelf.stateBlock(weakSelf.state);
                        weakSelf.label.text=[NSString stringWithFormat:@"账号状态:%@", weakSelf.state];
                    };
                    self.suBlock=^(){
                        weakSelf.gestureUnLockSwitch.on=YES;
                        _state=@"使用中";
                        weakSelf.stateBlock(weakSelf.state);
                        weakSelf.label.text=[NSString stringWithFormat:@"账号状态:%@",weakSelf.state];
                    };
                }else{
                    [self xiugaishiyonzhuangtaicodeStr:@"1"];
                    __weak __typeof__(self) weakSelf = self;
                    weakSelf.Block=^(){
                        weakSelf.UnLockSwitch.on=NO;
                        _state=@"使用中";
                        weakSelf.stateBlock(weakSelf.state);
                        weakSelf.label.text=[NSString stringWithFormat:@"账号状态:%@",weakSelf.state];
                    };
                    weakSelf.suBlock=^(){
                        weakSelf.gestureUnLockSwitch.on=NO;
                        _state=@"被冻结";
                        weakSelf.stateBlock(weakSelf.state);
                        weakSelf.label.text=[NSString stringWithFormat:@"账号状态:%@", weakSelf.state];
                    };
                }
            }else{
                if ([_state isEqualToString:@"被冻结"]) {
                    [self xiugaishiyonzhuangtaicodeStr:@"1"];
                    __weak __typeof__(self) weakSelf = self;
                    weakSelf.Block=^(){
                        weakSelf.gestureUnLockSwitch.on=YES;
                        _state=@"使用中";
                        weakSelf.stateBlock(weakSelf.state);
                        weakSelf.label.text=[NSString stringWithFormat:@"账号状态:%@",weakSelf.state];
                    };
                    weakSelf.suBlock=^(){
                        weakSelf.UnLockSwitch.on=YES;
                        _state=@"被冻结";
                        weakSelf.stateBlock(weakSelf.state);
                        weakSelf.label.text=[NSString stringWithFormat:@"账号状态:%@", weakSelf.state];
                    };
                }else{
                    
                    [self xiugaishiyonzhuangtaicodeStr:@"0"];
                    __weak __typeof__(self) weakSelf = self;
                    weakSelf.Block=^(){
                        weakSelf.gestureUnLockSwitch.on=NO;
                        _state=@"被冻结";
                        weakSelf.stateBlock(weakSelf.state);
                        weakSelf.label.text=[NSString stringWithFormat:@"账号状态:%@", weakSelf.state];
                    };
                    weakSelf.suBlock=^(){
                        weakSelf.UnLockSwitch.on=NO;
                        _state=@"使用中";
                        weakSelf.stateBlock(weakSelf.state);
                        weakSelf.label.text=[NSString stringWithFormat:@"账号状态:%@",weakSelf.state];
                    };
                }
            }
            
        }else{
            if ([_state isEqualToString:@"使用中"]) {
                if (sender.tag==0) {
                    _gestureUnLockSwitch.on = YES;
                }else{
                    _UnLockSwitch.on=NO;
                }
            }else{
                if (sender.tag==0) {
                    _gestureUnLockSwitch.on = NO;
                }else{
                    _UnLockSwitch.on = YES;
                }
            }
        }
    };
    [alertView showMKPAlertView];
}
-(void)xiugaishiyonzhuangtaicodeStr:(NSString*)codeStr{
    NSString *uStr =[NSString stringWithFormat:@"%@user/upstate.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"userid":_uresID,@"code":codeStr,@"CompanyInfoId":[USER_DEFAULTS valueForKey:@"companyinfoid"]};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改状态成功" andInterval:1.0];
            self.Block();
        } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"0001"]) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"修改状态失败" andInterval:1.0];
            
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
