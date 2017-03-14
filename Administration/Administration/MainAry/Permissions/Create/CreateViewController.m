//
//  CreateViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/3/3.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "CreateViewController.h"
#import "SelectAlert.h"
#import "SetPositionViewController.h"
@interface CreateViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    NSArray *titles;
    NSMutableArray *finskAry;
    NSMutableArray *brandLogoAry;
    NSString *jsid;
    NSString *NameorID;
    NSString *YZM;//验证码
    
}

@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,strong)UIButton *WCBtn;
@property (nonatomic,strong)UILabel *promptLabel;
@property (nonatomic,strong) UIButton *hideButton;
@property (nonatomic,assign) BOOL hide;
@property (nonatomic,retain)NSArray *HSarr;
@property (nonatomic,strong)UILabel *JSLabel;
@property (nonatomic,strong)UITextField *codeField;
@property (nonatomic,strong)UITextField *PassField;
@property (nonatomic,strong)UITextField *QRPassField;
@property (nonatomic,strong) NSString *MobileStr;
@property (nonatomic,strong) NSString *codeStr;

@property (nonatomic,strong)UILabel *PINPLabel;
@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"创建角色";
    
    _hide = YES;
   // [self setExtraCellLineHidden:infonTableview];
    self.view.backgroundColor =GetColor(231, 230, 230, 1);
    
    _arr = @[@"职位设定",@"职位",@"姓名",@"手机号",@"验证码",@"密码",@"确认密码"];
    _HSarr = @[@"职位设定",@"职位",@"输入姓名",@"请输入11位手机号",@"请输入验证码",@"输入密码",@"输入密码"];
    titles = @[@"品牌经理",@"市场美导",@"业务人员",@"内勤人员",@"物流人员",@"行政管理人员",@"业务经理"];
    [self InterTableUI];
    // Do any additional setup after loading the view.
}
-(void)InterTableUI{
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,50,self.view.bounds.size.width,52*(_arr.count+2)) style:UITableViewStylePlain];
    infonTableview.scrollEnabled =NO;
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    infonTableview.backgroundColor = [UIColor clearColor];
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
        make.top.mas_equalTo(infonTableview.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
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
    return 50.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier =@"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [infonTableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        
    }
     cell.textLabel.text = _arr[indexPath.row];
    CGRect labelRect2 = CGRectMake(100, 1, self.view.bounds.size.width-100, 48);
    if ([cell.textLabel.text isEqualToString:@"职位设定"]) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头

    }
    if ([cell.textLabel.text isEqualToString:@"职位"] ) {
        _JSLabel = [[UILabel alloc]initWithFrame:labelRect2];
        _JSLabel.text = _HSarr[indexPath.row];
        _JSLabel.textColor = GetColor(199, 199, 205, 1);
        _JSLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        [cell addSubview:_JSLabel];
        
    }else if([cell.textLabel.text isEqualToString:@"姓名"]||[cell.textLabel.text isEqualToString:@"手机号"]||[cell.textLabel.text isEqualToString:@"验证码"]){
        CGRect labelRect3 = CGRectMake(100, 1, self.view.bounds.size.width-200, 48);
        _codeField =[[UITextField alloc]initWithFrame:labelRect3];
        _codeField.backgroundColor=[UIColor whiteColor];
        _codeField.font = [UIFont boldSystemFontOfSize:13.0f];
        _codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeField.adjustsFontSizeToFitWidth = YES;
        [_codeField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        _codeField.tag = row;
        _codeField.placeholder =_HSarr[indexPath.row];
        [cell addSubview:_codeField];
        
        if ([cell.textLabel.text isEqualToString:@"手机号"]) {
            UIButton *TXImage = [UIButton buttonWithType:UIButtonTypeCustom];
            [TXImage setTitle:@"获取验证码" forState:UIControlStateNormal];
            [TXImage addTarget:self action:@selector(callIphone:) forControlEvents:UIControlEventTouchUpInside];
            TXImage.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            TXImage.frame=CGRectMake(self.view.bounds.size.width-100,0, 99, 49);
            TXImage.backgroundColor = GetColor(144, 75, 174, 1);
            [cell addSubview:TXImage];
        }
    }else if ([cell.textLabel.text isEqualToString:@"品牌"]){
        _PINPLabel = [[UILabel alloc]initWithFrame:labelRect2];
        _PINPLabel.textColor = GetColor(199, 199, 205, 1);
        _PINPLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        [cell addSubview:_PINPLabel];
        
    }else if ([cell.textLabel.text isEqualToString:@"密码"]){
        _PassField =[[UITextField alloc]initWithFrame:labelRect2];
        _PassField.backgroundColor=[UIColor whiteColor];
        _PassField.font = [UIFont boldSystemFontOfSize:13.0f];
        _PassField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _PassField.adjustsFontSizeToFitWidth = YES;
        [_PassField addTarget:self action:@selector(PassFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        _PassField.placeholder =_HSarr[indexPath.row];
        _PassField.secureTextEntry= YES;
        [cell addSubview:_PassField];
       
    }else if ([cell.textLabel.text isEqualToString:@"确认密码"]){
        _QRPassField =[[UITextField alloc]initWithFrame:labelRect2];
        _QRPassField.backgroundColor=[UIColor whiteColor];
        _QRPassField.font = [UIFont boldSystemFontOfSize:13.0f];
        _QRPassField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _QRPassField.adjustsFontSizeToFitWidth = YES;
        [_QRPassField addTarget:self action:@selector(PassFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        _QRPassField.placeholder =_HSarr[indexPath.row];
        _QRPassField.secureTextEntry = YES;
        [cell addSubview:_QRPassField];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    
    return cell;
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
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (void)PassFieldWithText:(UITextField *)textField
{
    if (_PassField.text.length > 0 && _QRPassField.text.length > 0 && jsid.length>0 &&NameorID.length>0 && _MobileStr.length>0 && YZM.length >0 && _PassField.text == _QRPassField.text) {
        _WCBtn.backgroundColor = GetColor(144, 75, 174, 1);
        _WCBtn.enabled = YES;
        
    }else{
        _WCBtn.backgroundColor = [UIColor lightGrayColor];
        _WCBtn.enabled = NO;
        
    }
  
}

- (void)textFieldWithText:(UITextField *)textField
{
   
    switch (textField.tag) {
        case 1:
            NameorID = textField.text;
            NSLog(@"姓名:%@",textField.text);
            break;
        case 2:
            if (textField.text.length>11) {
                NSString *lengthstr = textField.text;
                textField.text = [lengthstr substringToIndex:11];
                
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"最多输入11位" andInterval:1.0];
            }
            _MobileStr = textField.text;
            NSLog(@"手机号:%@",textField.text);
            break;
        case 3:
            if (textField.text.length>6) {
                NSString *lengthstr = textField.text;
                textField.text = [lengthstr substringToIndex:6];
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"最多输入6位" andInterval:1.0];
            }
            YZM = textField.text;
             NSLog(@"验证码:%@",textField.text);
            break;
        default:
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SetPositionViewController *setPostionVC= [[ SetPositionViewController alloc]init];
        [self.navigationController pushViewController:setPostionVC animated:YES];
        //[self.navigationController showViewController:StructVC sender:nil];
    }
    else if (indexPath.row == 1 ) {
        [self showAlert];
    }else if (indexPath.row ==3){
        NSLog(@"点是什么什么品牌");
        [self pinpaiAlerStr];
        
    }

}
-(void)pinpaiAlerStr{
    NSString *urlStr = [NSString stringWithFormat:@"%@brand/querybrand.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"]};
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
      
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"])
        {
             NSArray *resultAry = responseObject[@"brandlist"];
            finskAry = [[NSMutableArray alloc]init];
            brandLogoAry = [[NSMutableArray alloc]init];
                for (NSDictionary *bin in resultAry) {
                    NSString *finskStr =[[NSString alloc]init];
                    finskStr  =bin[@"finsk"];
                    NSString *logo = [[NSString alloc]init];
                    logo = bin[@"brandLogo"];
                    
                    [finskAry addObject:finskStr];
                    [brandLogoAry addObject:logo];
                }
            
            [SelectAlert showWithTitle:@"选择品牌" titles:finskAry imageViews:brandLogoAry selectIndex:^(NSInteger selectIndex) {
              
                 NSLog(@"选择了第%ld个",(long)selectIndex);
            } selectValue:^(NSString *selectValue) {
                _PINPLabel.text = selectValue;
                NSLog(@"选择的值为%@",selectValue);
                _PINPLabel.textColor= [UIColor blackColor];
            } showCloseButton:NO];
            

        }else{
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"查询品牌失败,请重试" andInterval:1.0];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)showAlert{
    [SelectAlert showWithTitle:@"选择职业" titles:titles selectIndex:^(NSInteger selectIndex) {
        if (selectIndex == 0 ||selectIndex == 1) {
            if (_arr.count == 8) {
            }else{
                _arr = @[@"职位设定",@"职位",@"姓名",@"品牌",@"手机号",@"验证码",@"密码",@"确认密码"];
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                [indexPaths addObject: indexPath];
                [infonTableview beginUpdates];
                [infonTableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
                [infonTableview endUpdates];
            }
        }else{
            if (_arr.count == 8) {
                [infonTableview beginUpdates];
                _arr = @[@"职位设定",@"职位",@"姓名",@"手机号",@"验证码",@"密码",@"确认密码"];
                NSArray *_tempIndexPathArr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]];
                [infonTableview deleteRowsAtIndexPaths:_tempIndexPathArr withRowAnimation:UITableViewRowAnimationFade];
                [infonTableview endUpdates];
            }
            else{
                
            }
        }
        //[infonTableview reloadData];
        NSLog(@"选择了第%ld个",(long)selectIndex);
        switch (selectIndex) {
            case 0:
                jsid = @"6";
                break;
            case 1:
                jsid = @"2";
                break;
            case 2:
                jsid = @"5";
                break;
            case 3:
                jsid = @"3";
                break;
            case 4:
                jsid = @"4";
                break;
            case 5:
                jsid = @"7";
                break;
            case 6:
                jsid = @"8";
                break;
                
            default:
                break;
        }
    } selectValue:^(NSString *selectValue) {
        NSLog(@"选择的值为%@",selectValue);
        _JSLabel.text = selectValue;
        _JSLabel.textColor= [UIColor blackColor];
        //self.titleLabel.text = selectValue;
        
    } showCloseButton:NO];
    

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
