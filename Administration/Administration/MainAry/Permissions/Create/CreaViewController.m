//
//  CreaViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/5/23.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

/*
 UIEdgeInsets UIEgde = UIEdgeInsetsMake(0, 15, 0, 15);
 [cell setSeparatorInset:UIEgde];
 */

#import "CreaViewController.h"
#import "SelectAlert.h"
#import "UserProfileManager.h"
@interface CreaViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *infonTableview;
    NSMutableArray *titles;
    NSMutableArray *numBS;
    NSMutableArray *zwlbNum;//职位类别
    NSMutableArray*zwlbAry;//职位类别数组
    NSMutableArray *gxbmNum;//管辖部门num
    NSMutableArray *gxbmAry;//管辖部门数组
    
    NSString *ssbmNum;

    NSString *jsid;
    NSString *NameorID;
    NSString *YZM;//验证码
    
    NSString *ccode;
    NSString *QRccode;
    
    int timeDown; //60秒后重新获取验证码
    NSTimer *timer;
    
}
@property (nonatomic,retain)NSMutableArray *Fieldarr;
@property (nonatomic,assign) BOOL hide;
@property (nonatomic,retain)NSMutableArray *arr;//黑色标签
@property (nonatomic,retain)NSMutableArray *HSarr;//灰色标签
@property (nonatomic,strong)UIButton *WCBtn;//完成按钮
@property (nonatomic,strong) UIButton *hideButton;//对勾
@property (nonatomic,strong)UILabel *promptLabel;//显示密码Label

@property (nonatomic,strong)UITextField *codeField;//验证码输入框
@property (nonatomic,strong)UITextField *PassField;//密码框
@property (nonatomic,strong)UITextField *QRPassField;//确认密码框

@property (nonatomic,strong) NSString *codeStr;//验证码
@property (nonatomic,strong) UIButton *TXImage;//获取验证码

@property (nonatomic,strong) NSString *MobileStr;
@property (nonatomic,strong)UILabel *PINPLabel;
@property (nonatomic,strong)UILabel *PINPLabel2;
@property (nonatomic,strong)UIButton *JsButton;//角色
@property (nonatomic,strong)UIButton *JsLBButton;//角色类别
@property (nonatomic,strong)UIView *view1;//   |
@property (nonatomic,strong)NSMutableArray *gxnumAry;
@end


@implementation CreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"创建角色";
    self.view.backgroundColor = [UIColor whiteColor];
    _Fieldarr = [[NSMutableArray alloc]init];
    ccode = [[NSString alloc]init];
    QRccode = [[NSString alloc]init];
    _hide = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    _gxnumAry = [[NSMutableArray alloc]init];
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    _arr = [[NSMutableArray alloc]initWithObjects:@"角色",@"姓名",@"手机号",@"验证码",@"密码",@"确认密码", nil];
    _HSarr = [[NSMutableArray alloc]initWithObjects:@"选择职位",@"输入姓名",@"请输入11位手机号",@"请输入验证码",@"输入密码(六位以上)",@"输入密码(六位以上)", nil];
    
        [self InterTableUI];
        [self ZwNetWork];
}

#pragma mark  请求角色
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
            [USER_DEFAULTS  setObject:@"" forKey:@"token"];
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时，请重新登录" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"0003"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"您没有权限创建角色" andInterval:1.0];
        }else{
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"网络错误" andInterval:1.0];
        }

    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}

#pragma mark  确定
-(void)action_button{
    
    if (jsid ==nil) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请选择职位" andInterval:1.0];
    }else if(NameorID == nil){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请输入姓名" andInterval:1.0];
    }else if(_MobileStr == nil){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请输入手机号" andInterval:1.0];
    }else if(YZM ==nil){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请输入验证码" andInterval:1.0];
    }else  if((ccode.length<6)||(QRccode.length<6)){
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"密码不够六位" andInterval:1.0];
    }else {
        if([ccode isEqualToString:QRccode]){
            
                NSString *poower = [NSString stringWithFormat:@"%@", _gxnumAry];
                NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
                NSString *urlStr = [NSString stringWithFormat:@"%@user/adduser.action", KURLHeader];
                NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
                NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
                NSDictionary *dic = [[NSDictionary alloc]init];
                
                NSString *ltoken=[ZXDNetworking encryptStringWithMD5:ccode];
                
                if ([jsid isEqual:@"2"]||[jsid isEqual:@"6"]) {
                    if (_gxnumAry.count == 0) {
                        dic= @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"password":ltoken,@"realName":NameorID,@"RoleId":jsid,@"LevelID":ssbmNum,@"mobile":_MobileStr};
                    }else{
                    dic= @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"password":ltoken,@"realName":NameorID,@"RoleId":jsid,@"DepartmentID":_gxnumAry,@"LevelID":ssbmNum,@"mobile":_MobileStr};
                    }
                    
                }else{
                    if (_gxnumAry.count == 0) {
                        dic= @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"password":ltoken,@"realName":NameorID,@"RoleId":jsid,@"mobile":_MobileStr};
                    }else{
                        dic= @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"password":ltoken,@"realName":NameorID,@"RoleId":jsid,@"DepartmentID":poower,@"mobile":_MobileStr};
                    }
                    
                }
                [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
                    if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"])
                    {
                        
                        PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"创建成功" sureBtn:@"确认" cancleBtn:nil];
                        alertView.resultIndex = ^(NSInteger index){
                            [self.navigationController popViewControllerAnimated:YES];
                        };
                        [alertView showMKPAlertView];
                    }else if([[responseObject valueForKey:@"status"]isEqualToString:@"2000"]){
                        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"用户已存在" andInterval:1.0];
                    }else if([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]){
                        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
                    }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
                        [USER_DEFAULTS  setObject:@"" forKey:@"token"];
                        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时，请重新登录" andInterval:1.0];
                    }else{
                        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"创建失败" andInterval:1.0];
                    }
                } failure:^(NSError *error) {
                    
                } view:self.view MBPro:YES];

            
            
            
        }else{
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"两次密码不相同" andInterval:1.0];
        }

    }
}

#pragma mark 角色类别
-(void)JsLBButtonbtn:(UIButton *)btn{
    NSString *urlStr = [NSString stringWithFormat:@"%@manager/queryPositionLevel.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    NSString *RoleId=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"roleId"]];
    NSString *nuum = [[NSString alloc]init];
    NSString *String = jsid.description;
    if ([String isEqual:@"5"]) {
        nuum = @"2";
    }else if([String isEqual:@"2"]){
        nuum = @"1";
    }
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"RoleId":RoleId,@"Num":nuum};
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"])
        {
            NSArray *arr= [responseObject valueForKey:@"list"];
            zwlbAry = [[NSMutableArray alloc]init];
            zwlbNum = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arr) {
                    [zwlbNum  addObject:[dic valueForKey:@"num"]];
                    [zwlbAry addObject:[dic valueForKey:@"levelName"]];
            }
            //[self showAlert:zwlbAry button:btn];
            [SelectAlert showWithTitle:@"选择职业类别" titles:zwlbAry selectIndex:^(NSInteger selectIndex) {
                NSLog(@"选择了第%ld个",(long)selectIndex);
                ssbmNum = [[NSString alloc]init];
                ssbmNum = zwlbNum[selectIndex];
                
            } selectValue:^(NSString *selectValue) {
                [_JsLBButton setTitle:selectValue forState:UIControlStateNormal];
                [_JsLBButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                NSLog(@"_JsLBButton.titleLabel.tex:%@",_JsLBButton.titleLabel.text);
            } showCloseButton:NO];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            [USER_DEFAULTS  setObject:@"" forKey:@"token"];
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时，请重新登录" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"您的公司没有设置职位类别，请先设置职位类别" andInterval:1.0];
        }else{
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"网络超时" andInterval:1.0];
        }
        
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
#pragma mark  选择角色
-(void)JsButtonbtn:(UIButton *)btn{
    [self showAlert:titles button:btn];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


#pragma mark  选择部门
-(void)submShowAlert{
    if (_HSarr.count >7) {
        infonTableview.scrollEnabled =YES;
    }else{
        infonTableview.scrollEnabled =NO;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@manager/queryDepartment.action", KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *companyinfoid = [NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
    dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"CompanyInfoId":companyinfoid,@"RoleId":jsid};
    [ZXDNetworking GET:urlStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"])
        {
            NSArray *arr= [responseObject valueForKey:@"list"];
            if (arr.count == 0) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"您的公司没有创建部门 " andInterval:1.0];
            }else{
                gxbmNum = [[NSMutableArray alloc]init];
                gxbmAry = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in arr) {
                    [gxbmNum  addObject:[dic valueForKey:@"id"]];
                    [gxbmAry addObject:[dic valueForKey:@"departmentName"]];
                }
               
                [SelectAlert showWithTitle:@"选择部门" titles:gxbmAry selectIndex:^(NSInteger selectIndex) {
                    NSLog                                                                                                                                                                                                                                                                                                                                                                                                                                                                     (@"选择了第%ld个",(long)selectIndex);
                    
                    if (_gxnumAry.count>0) {
                            NSString *ovje = gxbmNum[selectIndex];
                            BOOL isbool = [_gxnumAry containsObject: ovje];
                            if (isbool == 1) {
                                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"不能重复选择哦 " andInterval:1.0];
                            }else{
                            [_gxnumAry addObject:gxbmNum[selectIndex]];
                                if ([_arr[4]isEqualToString:@"所属部门"]) {
                                }else
                                {
                                    [_arr insertObject:@"" atIndex:5];
                                    //[_HSarr insertObject:gxbmAry[selectIndex] atIndex:5];
                                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
                                    [indexPaths addObject: indexPath];
                                    [infonTableview beginUpdates];
                                    [infonTableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
                                    [infonTableview endUpdates];
                                }

                            }
                        }else{
                        [_gxnumAry addObject:gxbmNum[selectIndex]];
                        if ([_arr[4]isEqualToString:@"所属部门"]) {
                        }else
                        {
                            [_arr insertObject:@"" atIndex:5];
                           // [_HSarr insertObject:gxbmAry[selectIndex] atIndex:5];
                            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
                            [indexPaths addObject: indexPath];
                            [infonTableview beginUpdates];
                            [infonTableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
                            [infonTableview endUpdates];
                        }

                        }
                    } selectValue:^(NSString *selectValue) {
                    if ([_arr[4]isEqualToString:@"所属部门"]) {
                        _PINPLabel.text = selectValue;
                        _PINPLabel.textColor = [UIColor blackColor];
                        [_HSarr insertObject:selectValue atIndex:5];

                    }else
                    {
                       
                        BOOL isbool = [_HSarr containsObject: selectValue];
                        if (isbool == YES) {
                            
                        }else{
                             [_HSarr insertObject:selectValue atIndex:5];
                            _PINPLabel2.text = selectValue;
                            _PINPLabel2.textColor = [UIColor blackColor];
                        }
                    }
                    } showCloseButton:NO];
            }
            
           
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"非法请求" andInterval:1.0];
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"1001"]){
            [USER_DEFAULTS  setObject:@"" forKey:@"token"];
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请求超时，请重新登录" andInterval:1.0];
        }else{
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"网络超时" andInterval:1.0];
        }
        

    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
#pragma mark  选择职业
-(void)showAlert :(NSArray *)arr button:(UIButton*)bbtn{
    
    [ SelectAlert showWithTitle:@"选择职业" titles:arr selectIndex:^(NSInteger selectIndex) {
        NSLog(@"选择了第%ld个",(long)selectIndex);
         jsid = numBS[selectIndex];
        
        NSLog(@":::%@",jsid);
        NSString *String = jsid.description;
        if ([String isEqualToString:@"7"]) {
            if (_arr.count == 7) {
                _HSarr = [[NSMutableArray alloc]initWithObjects:@"选择职位",@"输入姓名",@"请输入11位手机号",@"请输入验证码",@"输入密码(六位以上)",@"输入密码(六位以上)", nil];
                _arr = [[NSMutableArray alloc]initWithObjects:@"职位",@"姓名",@"手机号",@"验证码",@"密码",@"确认密码", nil];
                [infonTableview reloadData];
                [_gxnumAry removeAllObjects];
            }
            
        }else{
        if (_arr.count == 6) {
            if ([String isEqualToString:@"2"]||[String isEqualToString:@"5"]||[String isEqualToString:@"3"]||[String isEqualToString:@"4"]||[String isEqualToString:@"14"]||[String isEqualToString:@"16"]||[String isEqualToString:@"17"]) {
                
                _arr = [[NSMutableArray alloc]initWithObjects:@"职位",@"姓名",@"手机号",@"验证码",@"所属部门",@"密码",@"确认密码", nil];
            }else{
                _arr = [[NSMutableArray alloc]initWithObjects:@"职位",@"姓名",@"手机号",@"验证码",@"管辖部门",@"密码",@"确认密码", nil];
                
            }
            _HSarr = [[NSMutableArray alloc]initWithObjects:@"选择职位",@"输入姓名",@"请输入11位手机号",@"请输入验证码",@"选择部门",@"输入密码(六位以上)",@"输入密码(六位以上)", nil];
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
            [indexPaths addObject: indexPath];
            [infonTableview beginUpdates];
            [infonTableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
            [infonTableview endUpdates];
            if ([String isEqualToString:@"2"]||[String isEqualToString:@"5"]) {
                _view1.backgroundColor = [UIColor lightGrayColor];
                [_JsLBButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [_JsLBButton setTitle:@"选择职业类别" forState:UIControlStateNormal];
                _JsLBButton.enabled = YES;
            }else{
                _view1.backgroundColor = [UIColor whiteColor];
                [_JsLBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_JsLBButton setTitle:@"选择职业类别" forState:UIControlStateNormal];
                _JsLBButton.enabled = NO;
            }
            
        }else{
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
            UITableViewCell *cell = [infonTableview cellForRowAtIndexPath:indexPath];
            if ([String isEqualToString:@"2"]||[String isEqualToString:@"5"]||[String isEqualToString:@"3"]||[String isEqualToString:@"4"]||[String isEqualToString:@"14"]||[String isEqualToString:@"16"]||[String isEqualToString:@"17"]) {
                _arr[4] = @"所属部门";
                cell.textLabel.text= @"所属部门";
                _PINPLabel.text = @"选择部门";
                _PINPLabel.textColor = [UIColor lightGrayColor];
                for (int u = 0; u<_arr.count; u++) {
                    NSString *obj = _arr[u];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:u inSection:0];
                    UITableViewCell *cell = [infonTableview cellForRowAtIndexPath:indexPath];
                    
                    if ([obj isEqualToString:@""]) {
                        
                        [infonTableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        cell.hidden= YES;
                        [_arr removeObject:_arr[u]];
                        _HSarr = [[NSMutableArray alloc]initWithObjects:@"选择职位",@"输入姓名",@"请输入11位手机号",@"请输入验证码",@"选择部门",@"输入密码(六位以上)",@"输入密码(六位以上)", nil];
                    }
                }
                NSLog(@"%@",_HSarr);
                [infonTableview reloadData];
                
                [_gxnumAry removeAllObjects];
            }else{
                _arr[4] = @"管辖部门";
                cell.textLabel.text= @"管辖部门";
                _PINPLabel.text = @"管辖部门";
                _HSarr = [[NSMutableArray alloc]initWithObjects:@"选择职位",@"输入姓名",@"请输入11位手机号",@"请输入验证码",@"选择部门",@"输入密码(六位以上)",@"输入密码(六位以上)", nil];
                _PINPLabel.textColor = [UIColor lightGrayColor];
                [_gxnumAry removeAllObjects];
            }
            if ([String isEqualToString:@"2"]||[String isEqualToString:@"5"]) {
                _view1.backgroundColor = [UIColor lightGrayColor];
                [_JsLBButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [_JsLBButton setTitle:@"选择职业类别" forState:UIControlStateNormal];
                _JsLBButton.enabled = YES;
            }else{
                _view1.backgroundColor = [UIColor whiteColor];
                [_JsLBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_JsLBButton setTitle:@"选择职业类别" forState:UIControlStateNormal];
                _JsLBButton.enabled = NO;
            }
                 
        }
        }
        } selectValue:^(NSString *selectValue) {
        
        [bbtn setTitle:selectValue forState:UIControlStateNormal];
        [bbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
    } showCloseButton:NO];

}
-(void)uiarde{
    
}
#pragma mark 验证码倒计时
-(void)handleTimer{
    if(timeDown>=0)
    {
        [_TXImage setUserInteractionEnabled:NO];
        [_TXImage setTitleColor: GetColor(144, 75, 174, 1) forState:UIControlStateNormal];
        int sec = ((timeDown%(24*3600))%3600)%60;
        [_TXImage setTitle:[NSString stringWithFormat:@"(%d)秒",sec] forState:UIControlStateNormal];
    }else{
        [_TXImage setUserInteractionEnabled:YES];
        [_TXImage setTitleColor:GetColor(144, 75, 174, 1) forState:UIControlStateNormal];
        [_TXImage setTitle:@"重发验证码" forState:UIControlStateNormal];
        
        [timer invalidate];
    }
    timeDown = timeDown - 1;
}
#pragma mark 验证码
-(void)callIphone:(UIButton*)sender{
    /*
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
                timeDown = 59;
                timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
            }else{
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"网络堵塞了" andInterval:1.0];
            }
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
        
    }
    */
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([infonTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [infonTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([infonTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [infonTableview setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark 显示密码对勾
- (void)action_hideBUtton:(UIButton *)sender{
    _hide = !_hide;
    if (_hide == YES) {
        [_hideButton setBackgroundImage:[UIImage imageNamed:@"对-选中"] forState:UIControlStateNormal];
        _PassField =_Fieldarr[0];
        _QRPassField =_Fieldarr[1];
        _PassField.secureTextEntry = NO;
        _QRPassField.secureTextEntry = NO;
        
        
    }else{
        [_hideButton setBackgroundImage:[UIImage imageNamed:@"对-未选"] forState:UIControlStateNormal];
        _PassField =_Fieldarr[0];
        _QRPassField =_Fieldarr[1];
        _PassField.secureTextEntry = YES;
        _QRPassField.secureTextEntry = YES;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_arr.count == 7) {
        if (indexPath.row==4) {
            UIEdgeInsets UIEgde = UIEdgeInsetsMake(0, 15, 0, 15);
            [cell setSeparatorInset:UIEgde];
        }

    }else{
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        } 
    }
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
- (void)PassFieldWithText:(UITextField *)textField
{
    
            ccode = textField.text;
            NSLog(@"1:%@",textField.text);
    
    if ((ccode.length > 5 && QRccode.length > 5)&&([ccode isEqualToString:QRccode]) ) {
        
        _WCBtn.backgroundColor = GetColor(144, 75, 174, 1);
        _WCBtn.enabled = YES;
        
    }else{
        _WCBtn.backgroundColor = [UIColor lightGrayColor];
        _WCBtn.enabled = NO;
        
    }
}
-(void)QRPassFieldWithText:(UITextField *)textField
{
    
    QRccode = textField.text;
    NSLog(@"2:%@",textField.text);
    if ((ccode.length > 5 && QRccode.length > 5)&&([ccode isEqualToString:QRccode])) {
        
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
    if(indexPath.row == 4){
        
        if ([_arr[4] isEqualToString:@"管辖部门"]) {
            [self submShowAlert];
        }else if ([_arr[4]isEqualToString:@"所属部门"]){
            [self submShowAlert];
        }
        
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
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)InterTableUI{
    infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    infonTableview.scrollEnabled =NO;
    
    infonTableview.dataSource=self;
    infonTableview.delegate =self;
    infonTableview.backgroundColor = [UIColor clearColor];
    [self setExtraCellLineHidden:infonTableview];
    [self.view addSubview:infonTableview];
    
    
    UIView *fotView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, Scree_width, 180)];
    fotView.backgroundColor = [UIColor whiteColor];
    infonTableview.tableFooterView=fotView;
    
    _WCBtn = [[UIButton alloc]init];
    [_WCBtn setTitle:@"确定" forState:UIControlStateNormal];
    _WCBtn.layer.cornerRadius =5.0f;
    _WCBtn.tintColor = [UIColor whiteColor];
    _WCBtn.backgroundColor = [UIColor lightGrayColor];
    [_WCBtn addTarget:self action:@selector(action_button) forControlEvents:UIControlEventTouchUpInside];
    [fotView addSubview:_WCBtn];
    [_WCBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fotView.mas_left).offset(80);
        make.right.mas_equalTo(fotView.mas_right).offset(-80);
        make.top.mas_equalTo(fotView.mas_top).offset(15);
        make.height.mas_equalTo(30);
    }];
    _hideButton = [[UIButton alloc]init];
    _hideButton.layer.cornerRadius =10;
    _hideButton.layer.masksToBounds = YES;
    [_hideButton setBackgroundImage:[UIImage imageNamed:@"对-未选"] forState:UIControlStateNormal];
    [_hideButton addTarget:self action:@selector(action_hideBUtton:) forControlEvents:UIControlEventTouchUpInside];
    [fotView addSubview:_hideButton];
    [_hideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_WCBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(fotView.mas_left).offset(40);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    _promptLabel = [[UILabel alloc]init];
    _promptLabel.font = FONT(13);
    _promptLabel.text = @"显示密码";
    _promptLabel.textAlignment = NSTextAlignmentLeft;
    _promptLabel.textColor = GetColor(128, 128, 128, 1);
    [fotView addSubview:_promptLabel];
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_WCBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(_hideButton.mas_right).offset(5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
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
    cell.textLabel.font =[UIFont boldSystemFontOfSize:13.0f];
    CGRect labelRect2 = CGRectMake(100, 1, self.view.bounds.size.width-100, 38);
    CGRect labelRect3 = CGRectMake(100, 1, self.view.bounds.size.width-200, 38);
    if ([cell.textLabel.text isEqualToString:@"角色"] ) {
        
        _JsButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 1, self.view.bounds.size.width-300, 38)];
        [_JsButton setTitle:_HSarr[indexPath.row] forState:UIControlStateNormal];
        _JsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _JsButton.font = [UIFont boldSystemFontOfSize:13.0f];
        [_JsButton addTarget:self action:@selector(JsButtonbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_JsButton setTitleColor:GetColor(199, 199, 205, 1) forState:UIControlStateNormal];
        [cell addSubview:_JsButton];
        //self.view.bounds.size.width/2+30, 70, 1, 30
        
        _view1 = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2+30, 6, 1, 30 )];
        [cell addSubview:_view1];
       
        _JsLBButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2+31, 1, self.view.bounds.size.width-(self.view.bounds.size.width/2+31), 38)];
        _JsLBButton.font = [UIFont boldSystemFontOfSize:13.0f];
        [_JsLBButton setTitle:@"选择职业类别" forState:UIControlStateNormal];
        [_JsLBButton addTarget:self action:@selector(JsLBButtonbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_JsLBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _JsLBButton.enabled = NO;
        [cell addSubview:_JsLBButton];
    }
    if([cell.textLabel.text isEqualToString:@"姓名"]||[cell.textLabel.text isEqualToString:@"手机号"]||[cell.textLabel.text isEqualToString:@"验证码"]){
        for(_codeField in cell.subviews){
            if([_codeField isKindOfClass:[UITextField class]])
            {
                [_codeField removeFromSuperview];
            }
        }
        _codeField =[[UITextField alloc]initWithFrame:labelRect3];
        _codeField.backgroundColor=[UIColor whiteColor];
        _codeField.font = [UIFont boldSystemFontOfSize:13.0f];
        _codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeField.adjustsFontSizeToFitWidth = YES;
        [_codeField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        _codeField.tag = row;
        _codeField.placeholder =_HSarr[indexPath.row];
        
       
        placeholder(_codeField);
        [cell addSubview:_codeField];
    }
    if ([cell.textLabel.text isEqualToString:@"手机号"]) {
        for(_TXImage in cell.subviews){
            if([_TXImage isKindOfClass:[UIButton class]])
            {
                [_TXImage removeFromSuperview];
            }
        }
        _TXImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [_TXImage setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_TXImage addTarget:self action:@selector(callIphone:) forControlEvents:UIControlEventTouchUpInside];
        _TXImage.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _TXImage.frame=CGRectMake(self.view.bounds.size.width-100,0, 99, 39);
        [_TXImage setTitleColor:GetColor(144, 75, 174, 1) forState:UIControlStateNormal];
        [cell addSubview:_TXImage];
        
        UIView *view =[[UIView alloc]init];
        view.backgroundColor = [UIColor lightGrayColor];
        view.frame = CGRectMake(self.view.bounds.size.width-101,0, 1, 38);
        [cell addSubview:view];
        
    }
    if ([cell.textLabel.text isEqualToString:@"所属部门"]||[cell.textLabel.text isEqualToString:@"管辖部门"]){
        for(_PINPLabel in cell.subviews){
            if([_PINPLabel isKindOfClass:[UILabel class]])
            {
                [_PINPLabel removeFromSuperview];
            }
        }
        _PINPLabel = [[UILabel alloc]initWithFrame:labelRect2];
        _PINPLabel.textColor = GetColor(199, 199, 205, 1);
        _PINPLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _PINPLabel.text = _HSarr[indexPath.row];
        [cell addSubview:_PINPLabel];
        
    }
    if ([cell.textLabel.text isEqualToString:@""]) {
        for(_PINPLabel2 in cell.subviews){
            if([_PINPLabel2 isKindOfClass:[UILabel class]])
            {
                [_PINPLabel2 removeFromSuperview];
            }
        }
        for(_PassField in cell.subviews){
            if([_PassField isKindOfClass:[UITextField class]])
            {
                [_PassField removeFromSuperview];
            }
        }
        for(_QRPassField in cell.subviews){
            if([_QRPassField isKindOfClass:[UITextField class]])
            {
                [_QRPassField removeFromSuperview];
            }
        }
        _PINPLabel2 = [[UILabel alloc]initWithFrame:labelRect2];
        _PINPLabel2.textColor = GetColor(199, 199, 205, 1);
        _PINPLabel2.font = [UIFont boldSystemFontOfSize:13.0f];
        _PINPLabel2.text = _HSarr[indexPath.row];
        [cell addSubview:_PINPLabel2];
        
    }
    if ([cell.textLabel.text isEqualToString:@"密码"]){
        for(_PassField in cell.subviews){
            if([_PassField isKindOfClass:[UITextField class]])
            {
                [_PassField removeFromSuperview];
            }
        }
        _PassField =[[UITextField alloc]initWithFrame:labelRect2];
        _PassField.backgroundColor=[UIColor whiteColor];
        _PassField.font = [UIFont boldSystemFontOfSize:13.0f];
        _PassField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _PassField.adjustsFontSizeToFitWidth = YES;
        [_PassField addTarget:self action:@selector(PassFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        _PassField.placeholder =_HSarr[indexPath.row];
        placeholder(_PassField);
        _PassField.secureTextEntry= YES;
        
        [_Fieldarr addObject:_PassField];
        
        [cell addSubview:_PassField];
        
    }
    if ([cell.textLabel.text isEqualToString:@"确认密码"]){
        for(_QRPassField in cell.subviews){
            if([_QRPassField isKindOfClass:[UITextField class]])
            {
                [_QRPassField removeFromSuperview];
            }
        }
        _QRPassField =[[UITextField alloc]initWithFrame:labelRect2];
        _QRPassField.backgroundColor=[UIColor whiteColor];
        _QRPassField.font = [UIFont boldSystemFontOfSize:13.0f];
        _QRPassField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _QRPassField.adjustsFontSizeToFitWidth = YES;
        [_QRPassField addTarget:self action:@selector(QRPassFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        _QRPassField.placeholder =_HSarr[indexPath.row];
        placeholder(_QRPassField);
        _QRPassField.secureTextEntry = YES;
         [_Fieldarr addObject:_QRPassField];
        [cell addSubview:_QRPassField];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
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
