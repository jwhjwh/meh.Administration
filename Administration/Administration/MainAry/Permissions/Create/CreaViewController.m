//
//  CreaViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/5/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CreaViewController.h"
#import "SelectAlert.h"
@interface CreaViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    NSMutableArray *titles;
    NSMutableArray *numBS;
//    NSMutableArray *finskAry;
//    NSMutableArray *brandLogoAry;
    NSString *jsid;
    NSString *NameorID;
    NSString *YZM;//验证码
    
}
@property (nonatomic,assign) BOOL hide;
@property (nonatomic,retain)NSArray *arr;//黑色标签
@property (nonatomic,retain)NSArray *HSarr;//灰色标签
@property (nonatomic,strong)UIButton *WCBtn;//完成按钮
@property (nonatomic,strong) UIButton *hideButton;//对勾
@property (nonatomic,strong)UILabel *promptLabel;//显示密码Label

@property (nonatomic,strong)UITextField *codeField;//验证码输入框
@property (nonatomic,strong)UITextField *PassField;//密码框
@property (nonatomic,strong)UITextField *QRPassField;//确认密码框
@property (nonatomic,strong) NSString *codeStr;//验证码

@property (nonatomic,strong) NSString *MobileStr;
@property (nonatomic,strong)UILabel *PINPLabel;
@property (nonatomic,strong)UILabel *JSLabel;//角色

@end


@implementation CreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"创建角色";
    self.view.backgroundColor = [UIColor whiteColor];
    _hide = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    _arr = @[@"角色",@"姓名",@"手机号",@"验证码",@"密码",@"确认密码"];
    _HSarr = @[@"职位",@"输入姓名",@"请输入11位手机号",@"请输入验证码",@"输入密码",@"输入密码"];
     [self InterTableUI];
    [self ZwNetWork];
}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)InterTableUI{
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,380) style:UITableViewStylePlain];
    infonTableview.scrollEnabled =NO;
    
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    infonTableview.backgroundColor = [UIColor clearColor];
    [self setExtraCellLineHidden:infonTableview];
    [self.view addSubview:infonTableview];
    
    _WCBtn = [[UIButton alloc]init];
    [_WCBtn setTitle:@"确定" forState:UIControlStateNormal];
    _WCBtn.layer.cornerRadius =5.0f;
    _WCBtn.tintColor = [UIColor whiteColor];
    _WCBtn.backgroundColor = [UIColor lightGrayColor];
    [_WCBtn addTarget:self action:@selector(action_button) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_WCBtn];
    [_WCBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(80);
        make.right.mas_equalTo(self.view.mas_right).offset(-80);
        make.top.mas_equalTo(infonTableview.mas_bottom).offset(15);
        make.height.mas_equalTo(30);
    }];
    _hideButton = [[UIButton alloc]init];
    _hideButton.layer.cornerRadius =10;
    _hideButton.layer.masksToBounds = YES;
    [_hideButton setBackgroundImage:[UIImage imageNamed:@"对-未选"] forState:UIControlStateNormal];
    [_hideButton addTarget:self action:@selector(action_hideBUtton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hideButton];
    [_hideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_WCBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    _promptLabel = [[UILabel alloc]init];
    _promptLabel.font = FONT(13);
    _promptLabel.text = @"显示密码";
    _promptLabel.textAlignment = NSTextAlignmentLeft;
    _promptLabel.textColor = GetColor(128, 128, 128, 1);
    [self.view addSubview:_promptLabel];
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_WCBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(_hideButton.mas_right).offset(5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
}
-(void)ZwNetWork{
    NSString *urlStr = [NSString stringWithFormat:@"%@user/queryUserCreate.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *RoleId=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"roleId"]];
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"RoleId":RoleId};
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"])
        {
            NSArray *arr= [responseObject valueForKey:@"list"];
            titles = [[NSMutableArray alloc]init];
            numBS = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arr) {
                NSString *strr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"num"]];
                if ([strr isEqualToString:@"1"]) {
                    
                }else{
                    [numBS  addObject:[dic valueForKey:@"num"]];
                    [titles addObject:[dic valueForKey:@"newName"]];
                }
                
            }

        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时，请重新登录" andInterval:1.0];
        }else{
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"网络超时" andInterval:1.0];
        }

    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
- (void)action_hideBUtton:(UIButton *)sender{
    _hide = !_hide;
    if (_hide == YES) {
        [_hideButton setBackgroundImage:[UIImage imageNamed:@"对-选中"] forState:UIControlStateNormal];
        _PassField.secureTextEntry = NO;
        _QRPassField.secureTextEntry = NO;
        
        
    }else{
        [_hideButton setBackgroundImage:[UIImage imageNamed:@"对-未选"] forState:UIControlStateNormal];
        _PassField.secureTextEntry = YES;
        _QRPassField.secureTextEntry = YES;
    }
}
-(void)action_button{
    if (YZM ==nil) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请输入验证码" andInterval:1.0];
    }else if ([_codeStr isEqualToString:YZM]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@user/adduser.action", KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSDictionary *dic = [[NSDictionary alloc]init];
        if ([jsid isEqualToString:@"2"]||[jsid isEqualToString:@"6"]) {
            dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"password":_PassField.text,@"roleId":jsid,@"mobile":_MobileStr,@"realName":NameorID,@"brandID":_PINPLabel.text};
        }else{
            dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"password":_PassField.text,@"roleId":jsid,@"mobile":_MobileStr,@"realName":NameorID};
        }
        [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"])
            {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"创建成功" andInterval:1.0];
            }else if([[responseObject valueForKey:@"status"]isEqualToString:@"2000"]){
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"用户已存在" andInterval:1.0];
            }else if([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]){
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
            }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时，请重新登录" andInterval:1.0];
            }else{
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"创建失败" andInterval:1.0];
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
        
    }else{
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"验证码无效" andInterval:1.0];

    
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSInteger row = [indexPath row];
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.text = _arr[indexPath.row];
    cell.textLabel.font =[UIFont boldSystemFontOfSize:13.0f];
    CGRect labelRect2 = CGRectMake(100, 1, self.view.bounds.size.width-100, 38);
    if ([cell.textLabel.text isEqualToString:@"角色"] ) {
        _JSLabel = [[UILabel alloc]initWithFrame:labelRect2];
        _JSLabel.text = _HSarr[indexPath.row];
        _JSLabel.textColor = GetColor(199, 199, 205, 1);
        _JSLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        [cell addSubview:_JSLabel];
        
    }else{
    
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
        [self showAlert];
    }
}
-(void)showAlert{
    NSLog(@"%@",titles);
    [ SelectAlert showWithTitle:@"选择职业" titles:titles selectIndex:^(NSInteger selectIndex) {
        NSLog(@"选择了第%ld个",(long)selectIndex);
         jsid = numBS[selectIndex];
        NSLog(@":::%@",jsid);
        if (selectIndex == 0 ||selectIndex == 1) {
            if (_arr.count == 6) {
                _arr = @[@"职位",@"姓名",@"品牌",@"手机号",@"验证码",@"密码",@"确认密码"];
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                [indexPaths addObject: indexPath];
                [infonTableview beginUpdates];
                [infonTableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
                [infonTableview endUpdates];
            }
        }else{
            if (_arr.count == 7) {
                [infonTableview beginUpdates];
                _arr = @[@"职位",@"姓名",@"手机号",@"验证码",@"密码",@"确认密码"];
                NSArray *_tempIndexPathArr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]];
                [infonTableview deleteRowsAtIndexPaths:_tempIndexPathArr withRowAnimation:UITableViewRowAnimationFade];
                [infonTableview endUpdates];
            }
            else{
                
            }
        }
    } selectValue:^(NSString *selectValue) {
        NSLog(@"选择的值为%@",selectValue);
        _JSLabel.text = selectValue;
        _JSLabel.textColor= [UIColor blackColor];
        
        
    } showCloseButton:NO];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(void)callIphone:(UIButton*)sender{
    
    if (_MobileStr  == nil) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请输入11位手机号" andInterval:1.0];
    }else if (_MobileStr.length<11){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请输入11位手机号" andInterval:1.0];
    }
    else{
        NSString *urlStr = [NSString stringWithFormat:@"%@user/sendMessage.action", KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"mobile":_MobileStr};
        NSLog(@"%@%@",urlStr,dic);
        [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"])
            {
                _codeStr = [responseObject objectForKey:@"code"];
                NSLog(@"_codeStr:%@",_codeStr);
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"短信已发送，请注意查收" andInterval:1.0];
            }else{
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"网络堵塞了" andInterval:1.0];
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
        
    }
    
    
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