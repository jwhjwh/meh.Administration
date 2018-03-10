//
//  AddCustomer.m
//  Administration
//
//  Created by 九尾狐 on 2017/12/6.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "AddCustomer.h"
#import "UIViewDatePicker.h"
#import "DPYJViewController.h"
@interface AddCustomer ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIViewDatePickerDelegate>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,strong) UILabel *DayLabel;//出生日期

@property (nonatomic ,retain)NSMutableArray *nameArrs;
@property (nonatomic,strong)NSMutableArray *ligary;
@property (nonatomic,strong)NSMutableArray *texttagary;
@property (nonatomic,strong)NSMutableArray *nsmuary;

@property (nonatomic,strong) NSString *namestr;//姓名
@property (nonatomic,strong) NSString *agestr;//年龄
@property (nonatomic,strong) NSString *SolarBirthday;
@property (nonatomic,strong) NSString *LunarBirthday;//生日
@property (nonatomic,strong) NSString *iphonestr;//电话
@property (nonatomic,strong) NSString *qqstr;//qq
@property (nonatomic,strong) NSString *wxstr;//wx
@property (nonatomic,strong) NSString *HobbyStr;//爱好
@property (nonatomic,strong) NSString *Personality;//性格
@property (nonatomic,strong) NSString *SalesBrand;//所做品牌
@property (nonatomic,strong) NSString *CustomerHealth;//顾客身体
@property (nonatomic,strong) NSString *OngoingItem;//正在 做的项目
@property (nonatomic,strong) NSString *Heedful;//特殊注意
@property (nonatomic,strong) NSString *Consumption;//消费分析
@property (nonatomic,strong) NSString *flaig;//阴--阳---历
@end

@implementation AddCustomer

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"顾客信息";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    if ([self.shopname isEqualToString:@"1"]) {
          [self AFNetworking];
    }else{
        if (self.issend == NO) {
            UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
            [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = rightitem;
            [self AFNetworking];
        }else{
            UIButton *rightitem = [UIButton buttonWithType:UIButtonTypeCustom];
            rightitem.frame =CGRectMake(self.view.frame.size.width-30, 0, 28,28);
            [rightitem setBackgroundImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
            [rightitem addTarget: self action: @selector(rightItemAction:) forControlEvents: UIControlEventTouchUpInside];
            UIBarButtonItem *rbuttonItem=[[UIBarButtonItem alloc]initWithCustomView:rightitem];
            self.navigationItem.rightBarButtonItem = rbuttonItem;
        }
    }
    
    _nameArrs = [[NSMutableArray alloc]initWithObjects:@[@"姓名",@"年龄"],@[@"生日",@"电话",@"QQ",@"微信",@"爱好",@"性格",@"所做品牌"], @[@"顾客身体情况简介",@"正在做的项目",@"特殊注意说明",@"消费分析"],nil];
    _ligary = [[NSMutableArray alloc]initWithObjects:@[@"填写姓名",@"选择年龄"],@[@"填写生日",@"填写电话",@"填写QQ",@"填写微信",@"填写爱好",@"填写性格",@"填写所做品牌"], nil];
    _texttagary = [[NSMutableArray alloc]initWithObjects:@[@"0",@"1"],@[@"2",@"3",@"4",@"5",@"6",@"7",@"8"], nil];
    [self addViewremind];
    [self nsstringallocinit];
}
-(void)AFNetworking{
    //selectstore
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectstore.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Storeid":self.shopid,@"store":@"4",@"StoreCustomerId":self.StoreClerkId};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
           NSArray *list_ary = [responseObject valueForKey:@"list"];
            NSMutableArray *nameary = [[NSMutableArray alloc]init];
            NSMutableArray *dayary = [[NSMutableArray alloc]init];
            NSMutableArray *xiangmuary = [[NSMutableArray alloc]init];
            _nsmuary = [[NSMutableArray alloc]init];
            for (NSDictionary *list_dic in list_ary) {
                _namestr = [list_dic valueForKey:@"name"];
                [nameary addObject:_namestr];
                _agestr =[list_dic valueForKey:@"age"];
                [nameary addObject:_agestr];
                
                if ([[list_dic valueForKey:@"flag"]isEqual:[NSNull null]]) {
                    [dayary addObject:@""];
                }else{
                    NSInteger k = [[list_dic valueForKey:@"flag"] integerValue];
                    NSString *stringInt = [NSString stringWithFormat:@"%ld",k];
                    _flaig = stringInt;
                    _LunarBirthday = [list_dic valueForKey:@"lunarBirthday"];
                    _SolarBirthday = [list_dic valueForKey:@"solarBirthday"];
                    if ([stringInt isEqualToString:@"1"]) {
                        [dayary addObject:_LunarBirthday];
                    }else{
                        [dayary addObject:_SolarBirthday];
                    }
                }
                
                _iphonestr =[list_dic valueForKey:@"phone"];
                [dayary addObject:_iphonestr];
                _qqstr =[list_dic valueForKey:@"qcode"];
                [dayary addObject:_qqstr];
                _wxstr =[list_dic valueForKey:@"wcode"];
                [dayary addObject:_wxstr];
                _HobbyStr =[list_dic valueForKey:@"hobbies"];
                [dayary addObject:_HobbyStr];
                _Personality =[list_dic valueForKey:@"personality"];
                [dayary addObject:_Personality];
                _SalesBrand=[list_dic valueForKey:@"salesBrand"];
                [dayary addObject:_SalesBrand];
                
                _CustomerHealth=[list_dic valueForKey:@"customerHealth"];
                [xiangmuary addObject:_CustomerHealth];
                _OngoingItem=[list_dic valueForKey:@"ongoingItem"];
                [xiangmuary addObject:_OngoingItem];
                _Heedful=[list_dic valueForKey:@"heedful"];
                [xiangmuary addObject:_Heedful];
                _Consumption=[list_dic valueForKey:@"consumption"];
                [xiangmuary addObject:_Consumption];
            }
            [_nsmuary addObject:nameary];
            [_nsmuary addObject:dayary];
            [_nsmuary addObject:xiangmuary];
            [self.tableView reloadData];
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
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)nsstringallocinit{
     _namestr = [[NSString alloc]init];//姓名
     _agestr = [[NSString alloc]init];//年龄
     _SolarBirthday = [[NSString alloc]init];
     _LunarBirthday = [[NSString alloc]init];//生日
     _iphonestr = [[NSString alloc]init];//电话
     _qqstr = [[NSString alloc]init];//qq
     _wxstr = [[NSString alloc]init];//wx
     _HobbyStr = [[NSString alloc]init];//爱好
     _Personality = [[NSString alloc]init];//性格
     _SalesBrand = [[NSString alloc]init];//所做品牌
     _CustomerHealth = [[NSString alloc]init];//顾客身体
     _OngoingItem = [[NSString alloc]init];//正在 做的项目
     _Heedful = [[NSString alloc]init];//特殊注意
     _Consumption = [[NSString alloc]init];//消费分析
     _flaig = [[NSString alloc]init];//阴--阳---历
}
-(void)addViewremind{
    self.tableView= [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    NSString* phoneModel = [UIDevice devicePlatForm];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        self.tableView.frame =CGRectMake(0,88,self.view.bounds.size.width,self.view.bounds.size.height-50);
    }else{
        self.tableView.frame =CGRectMake(0,65,self.view.bounds.size.width,self.view.bounds.size.height-70);
    }
    self.tableView.dataSource=self;
    self.tableView.delegate =self;
    [ZXDNetworking setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        return 50.0f;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nameArrs[section]count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
        return 10;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * str = [NSString stringWithFormat:@"  "];
    return str;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    view.tintColor = GetColor(230,230,230,1);
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor grayColor];
    header.textLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _nameArrs.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"gameeCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifi];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *tlelabel = [[UILabel alloc]init];
    if (indexPath.section == 2) {
        tlelabel.frame = CGRectMake(10, 15, 150, 30);
         cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }else{
        if (indexPath.row==6) {
             tlelabel.frame = CGRectMake(10, 10, 80, 30);
        }else{
             tlelabel.frame = CGRectMake(10, 10, 50, 30);
        }
    }
    tlelabel.text =  _nameArrs[indexPath.section][indexPath.row];
    tlelabel.font = [UIFont systemFontOfSize:15.0f];
    [cell addSubview:tlelabel];
    if (indexPath.section<2) {
        cell.userInteractionEnabled = _issend;
        if (indexPath.section==1) {
            if (indexPath.row==0) {
                [_DayLabel removeFromSuperview];
                _DayLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, self.view.bounds.size.width-170, 38)];
                if (self.StoreClerkId ==nil) {
                    _DayLabel.text = [NSString stringWithFormat:@"%@",_ligary[indexPath.section][indexPath.row]];
                    _DayLabel.textColor = [UIColor lightGrayColor];
                    
                }else{
                    if ([_nsmuary[indexPath.section][indexPath.row]isEqualToString:@""]) {
                        _DayLabel.text = [NSString stringWithFormat:@"%@",_ligary[indexPath.section][indexPath.row]];
                        _DayLabel.textColor = [UIColor lightGrayColor];
                    }else{
                        _DayLabel.text = _nsmuary[indexPath.section][indexPath.row];
                    }
                    
                }
                [cell addSubview:_DayLabel];
                _DayLabel.font = [UIFont boldSystemFontOfSize:13.0f];
            }else{
                UITextField *bossname = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
                bossname.placeholder = _ligary[indexPath.section][indexPath.row];
                bossname.font = [UIFont systemFontOfSize:14.0f];
                placeholder(bossname);
                NSInteger k = [_texttagary[indexPath.section][indexPath.row] integerValue];
                bossname.tag = k;
                bossname.delegate = self;
                [bossname addTarget:self action:@selector(PersonFieldText:) forControlEvents:UIControlEventEditingChanged];
                bossname.enabled = self.issend;
                if ([_nsmuary[indexPath.section][indexPath.row]isEqualToString:@""]) {
                    
                }else{
                    bossname.text = _nsmuary[indexPath.section][indexPath.row];
                }
                
                [cell addSubview:bossname];
            }
        }else{
            UITextField *bossname = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, cell.width-120, 30)];
            bossname.placeholder = _ligary[indexPath.section][indexPath.row];
            bossname.font = [UIFont systemFontOfSize:14.0f];
            placeholder(bossname);
            NSInteger k = [_texttagary[indexPath.section][indexPath.row] integerValue];
            bossname.tag = k;
            bossname.delegate = self;
            [bossname addTarget:self action:@selector(PersonFieldText:) forControlEvents:UIControlEventEditingChanged];
            bossname.enabled = self.issend;
            if (indexPath.row==1) {
                if ([_agestr isEqual:@""]) {
                    
                }else{
                    NSInteger k = [_nsmuary[indexPath.section][indexPath.row] integerValue];
                    NSString *stringInt = [NSString stringWithFormat:@"%ld",k];
                    bossname.text = stringInt;
                }
            }else{
                bossname.text = _nsmuary[indexPath.section][indexPath.row] ;
            }
           
            [cell addSubview:bossname];
        }
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            
                UIViewDatePicker *datePick = [[UIViewDatePicker alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
                datePick.delegate = self;
                [self.view endEditing:YES];
                [self.view.window addSubview:datePick];
                datePick.blcokStrrrr = ^(NSString *content, NSString *oldcontent, NSString *flag) {
                    NSLog(@"222---%@----%@----%@",content,oldcontent,flag);
                    _flaig = [[NSString alloc]init];
                    _flaig = flag;
                    _SolarBirthday = content;
                    _LunarBirthday = oldcontent;
                    if ([_flaig isEqualToString:@"1"]) {
                        //阴历 == 农历
                        _DayLabel.text = oldcontent;
                        _DayLabel.textColor = [UIColor blackColor];
                        
                    }else{
                        //阳历 ==公历
                        _DayLabel.text = content;
                        _DayLabel.textColor = [UIColor blackColor];
                    }
                };
                
            
        }
    }else if (indexPath.section==2){
        switch (indexPath.row) {
            case 0:
            {
                DPYJViewController *targetVC=[[DPYJViewController alloc]init];
                targetVC.number=@"1";
                targetVC.dateStr = _nsmuary[indexPath.section][indexPath.row]; //点评建议
                targetVC.modifi = _issend;//可否编辑
                targetVC.blcokStr=^(NSString *content,int num){
                    if (num==1) {
                        if (_issend == YES) {
                             _CustomerHealth = content;
                        }
                        //顾客身体情况简介
                        
                    }
                };
                [self.navigationController pushViewController:targetVC animated:YES];
            }
                break;
                
            case 1:
            {
                DPYJViewController *targetVC=[[DPYJViewController alloc]init];
                targetVC.number=@"2";
                 targetVC.dateStr = _nsmuary[indexPath.section][indexPath.row]; //点评建议
                targetVC.modifi = _issend;//可否编辑
                targetVC.blcokStr=^(NSString *content,int num){
                    if (num==2) {
                        if (_issend == YES) {
                             _OngoingItem = content;
                        }
                        //正在做的项目
                        
                    }
                };
                [self.navigationController pushViewController:targetVC animated:YES];
            }
                break;
                
            case 2:
            {
                DPYJViewController *targetVC=[[DPYJViewController alloc]init];
                targetVC.number=@"3";
                 targetVC.dateStr = _nsmuary[indexPath.section][indexPath.row]; //点评建议
                targetVC.modifi = _issend;//可否编辑
                targetVC.blcokStr=^(NSString *content,int num){
                    if (num==3) {
                        if (_issend == YES) {
                             _Heedful = content;
                        }
                        //特殊注意说明
                        
                    }
                };
                [self.navigationController pushViewController:targetVC animated:YES];
            }
                break;
                
            case 3:
            {
                DPYJViewController *targetVC=[[DPYJViewController alloc]init];
                targetVC.number=@"4";
                 targetVC.dateStr = _nsmuary[indexPath.section][indexPath.row]; //点评建议
                targetVC.modifi = _issend;//可否编辑
                targetVC.blcokStr=^(NSString *content,int num){
                    if (num==4) {
                        if (_issend == YES) {
                             _Consumption = content;
                        }
                        //消费分析
                        
                    }
                };
                [self.navigationController pushViewController:targetVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }

}
- (void)PersonFieldText:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
            _namestr = textField.text;
            break;
        case 1:
            _agestr = textField.text;
            break;
            
        case 3:
            _iphonestr = textField.text;
            break;
        case 4:
            _qqstr = textField.text;
            break;
        case 5:
            _wxstr = textField.text;
            break;
        case 6:
            _HobbyStr = textField.text;
            break;
        case 7:
            _Personality = textField.text;
            break;
        case 8:
            _SalesBrand = textField.text;
            break;
        default:
            break;
    }
}
-(void)rightItemAction:(UIBarButtonItem *)btn{
    if ([btn.title isEqualToString:@"编辑"]) {
        btn.title = @"完成";
        self.issend = YES;
        [self.tableView reloadData];
        NSLog(@"编辑");
    }else if ([btn.title isEqualToString:@"完成"]){
        
        NSLog(@"完成");
        
        [self updateStoreCustomer1:btn];
    }else{
        NSLog(@"提交");
        [self insertStoreCustomer];
    }
}
-(void)updateStoreCustomer1:(UIBarButtonItem *)btn{
    //upta
    if ([_namestr isEqualToString:@""]) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写姓名" andInterval:1.0];
    }else{
        NSString *uStr =[NSString stringWithFormat:@"%@shop/updateStoreCustomer1.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Storeid":self.shopid,@"Name":_namestr,@"Age":_agestr,@"SolarBirthday":_SolarBirthday,@"LunarBirthday":_LunarBirthday,@"flag":_flaig,@"Phone":_iphonestr,@"QCode":_qqstr,@"WCode":_wxstr,@"Hobbies":_HobbyStr,@"Personality":_Personality,@"SalesBrand":_SalesBrand,@"CustomerHealth":_CustomerHealth,@"OngoingItem":_OngoingItem,@"Heedful":_Heedful,@"Consumption":_Consumption,@"id":self.StoreClerkId};
        [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"修改成功" sureBtn:@"确认" cancleBtn:nil];
                alertView.resultIndex = ^(NSInteger index){
                    [self.tableView reloadData];
                    btn.title =@"编辑";
                    self.issend = NO;
                    [self.tableView reloadData];
                };
                [alertView showMKPAlertView];
                
                
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
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
    }
    
}
-(void)insertStoreCustomer{
    //add
    if ([_namestr isEqualToString:@""]) {
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写姓名" andInterval:1.0];
    }else{
        NSString *uStr =[NSString stringWithFormat:@"%@shop/insertStoreCustomer.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Storeid":self.shopid,@"Name":_namestr,@"Age":_agestr,@"SolarBirthday":_SolarBirthday,@"LunarBirthday":_LunarBirthday,@"flag":_flaig,@"Phone":_iphonestr,@"QCode":_qqstr,@"WCode":_wxstr,@"Hobbies":_HobbyStr,@"Personality":_Personality,@"SalesBrand":_SalesBrand,@"CustomerHealth":_CustomerHealth,@"OngoingItem":_OngoingItem,@"Heedful":_Heedful,@"Consumption":_Consumption};
        [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"添加成功" sureBtn:@"确认" cancleBtn:nil];
                alertView.resultIndex = ^(NSInteger index){
                    [self.tableView reloadData];
                };
                [alertView showMKPAlertView];
                
                
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
        } failure:^(NSError *error) {
            
        } view:self.view MBPro:YES];
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
