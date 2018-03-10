//
//  StoresViewController.m
//  Administration
//
//  Created by 九尾狐 on 2017/11/1.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "StoresViewController.h"
#import "StoresModel.h"
#import "CLZoomPickerView.h"
#import "inftionTableViewCell.h"
#import "TargetViewController.h"
#import "CityChooseViewController.h"

#import "storesActivity.h"
@interface StoresViewController ()<UITableViewDataSource,UITableViewDelegate,CLZoomPickerViewDelegate, CLZoomPickerViewDataSource,UITextFieldDelegate>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,strong)CLZoomPickerView *pickerView;
@property (strong,nonatomic) NSIndexPath *index;
@property (nonatomic ,retain)NSArray *nameArrs;
@property (nonatomic ,retain)NSArray *ligtextArrs;
@property (nonatomic ,retain)NSArray *TexttagArrs;
@property (strong,nonatomic) NSArray *timeArray;
@property (strong,nonatomic) NSMutableArray *InterNameAry;

@property (nonatomic,strong)NSString *StoreName;//店名称
@property (nonatomic,strong)NSString *Province;//省
@property (nonatomic,strong)NSString *City;//市
@property (nonatomic,strong)NSString *County;//县
@property (nonatomic,strong)NSString *Address;//详细地址
@property (nonatomic,strong)NSString *RideInfo;//乘车
@property (nonatomic,strong)NSString *Area;//面积
@property (nonatomic,strong)NSString *BrandBusiness;//其他品牌
@property (nonatomic,strong)NSString *IntentionBrand;//意向品牌
@property (nonatomic,strong)NSString *Berths;//床位数
@property (nonatomic,strong)NSString *ValidNumber;//有效顾客信息
@property (nonatomic,strong)NSString *StaffNumber;//员工人数
@property (nonatomic,strong)NSString *JobExpires;//员工从业年限
@property (nonatomic,strong)NSString *Problems;//存在的优势问题
@property (nonatomic,strong)NSString *RunStatus;//经营状况
@property (nonatomic,strong)NSString *Oftencustomers;//常到顾客
@property (nonatomic,strong)NSString *TooKeenPlan;//拓客计划
@end

@implementation StoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门店信息";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buLiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(buringItem)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    
     _nameArrs = @[@"店名",@"门店地址",@"乘车信息",@"面积",@"其他经营品牌",@"意向品牌",@"床位数",@"有效顾客",@"员工人数",@"员工从业年限",@"存在优势及问题",@"经营状况",@"常到顾客",@"拓客计划",@"活动概要"];
    _ligtextArrs = @[@"填写店名",@"",@"填写乘车信息",@"填写面积",@"填写其他经营品牌",@"填写意向品牌",@"选择床位数",@"选择有效顾客数量",@"选择员工人数",@"选择员工从业年限"];
    _TexttagArrs = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    [self nsstingalloc];
    [self addViewremind];
    NSMutableArray *array=[NSMutableArray array];
    for (int i=1; i<101; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _timeArray=[NSArray arrayWithArray:array];
    if ([_isofyou isEqualToString:@"1"]) {
         [self networking];
        //说明已提交店铺
        
    }
   
}
-(void)buringItem{
    if (_isend==YES) {
        _isend= NO;
        
        [self.tableView reloadData];
    }else{
        _isend= YES;
        
        [self.tableView reloadData];
    }
    
}
-(void)networking{
    NSString *uStr =[NSString stringWithFormat:@"%@shop/selectstore.action",KURLHeader];
    NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
    NSDictionary *dic = [[NSDictionary alloc]init];
    dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Storeid":self.StoreId,@"store":@"1",@"RoleId":self.strId};
    [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            NSArray *array=[responseObject valueForKey:@"list"];
            _InterNameAry = [[NSMutableArray alloc]init];
            StoresModel *model=[[StoresModel alloc]init];
            NSMutableArray *nsaty = [[NSMutableArray alloc]init];
            [nsaty addObject:array];
            for (NSDictionary *dict in nsaty) {
                
                [model setValuesForKeysWithDictionary:dict];
                [self nstingallocinit:model];
                
            }
            
            _isend= NO;
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
        }else if([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]){
            
                UIButton *rightitem = [UIButton buttonWithType:UIButtonTypeCustom];
                rightitem.frame =CGRectMake(self.view.frame.size.width-30, 0, 28,28);
                [rightitem setBackgroundImage:[UIImage imageNamed:@"submit_ico01"] forState:UIControlStateNormal];
                [rightitem addTarget: self action: @selector(rightItemAction) forControlEvents: UIControlEventTouchUpInside];
                UIBarButtonItem *rbuttonItem=[[UIBarButtonItem alloc]initWithCustomView:rightitem];
                self.navigationItem.rightBarButtonItem = rbuttonItem;
                _isend= YES;
            
            [self.tableView reloadData];
            
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
}
-(void)nsstingalloc{
    
   _StoreName = [[NSString alloc]init];//点名称
   _Province= [[NSString alloc]init];//省
   _City= [[NSString alloc]init];//市
   _County= [[NSString alloc]init];//县
   _Address= [[NSString alloc]init];//详细地址
   _RideInfo= [[NSString alloc]init];//乘车
   _Area= [[NSString alloc]init];//面积
   _BrandBusiness= [[NSString alloc]init];//其他品牌
   _IntentionBrand= [[NSString alloc]init];//意向品牌
   _Berths= [[NSString alloc]init];//床位数
   _ValidNumber= [[NSString alloc]init];//有效顾客信息
   _StaffNumber= [[NSString alloc]init];//员工人数
   _JobExpires= [[NSString alloc]init];//员工从业年限
   _Problems= [[NSString alloc]init];//存在的优势问题
    
    _RunStatus= [[NSString alloc]init];//经营状况
    _Oftencustomers= [[NSString alloc]init];//常到顾客
    _TooKeenPlan= [[NSString alloc]init];//拓客计划
}
-(void)addViewremind{
    self.tableView= [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    NSString* phoneModel = [UIDevice devicePlatForm];
    if ([phoneModel isEqualToString:@"iPhone Simulator"]||[phoneModel isEqualToString:@"iPhone X"]) {
        self.tableView.frame =CGRectMake(0,88,self.view.bounds.size.width,self.view.bounds.size.height-90);
    }else{
        self.tableView.frame =CGRectMake(0,65,self.view.bounds.size.width,self.view.bounds.size.height-65);
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
    return _nameArrs.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    inftionTableViewCell *cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];

    if (cell ==nil)
    {
        cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
    /**
     *  单元格的选中类型一定不能设置为 UITableViewCellSelectionStyleNone，如果加上这一句，全选勾选不出来
     */
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *tlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 30)];
    tlelabel.text = _nameArrs[indexPath.row];
    tlelabel.font = [UIFont systemFontOfSize:14];
    [cell addSubview:tlelabel];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row<10) {
        if (indexPath.row<6) {
            if(indexPath.row ==1){
                 cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
            }else{
                UITextField *inforTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, self.view.frame.size.width-120, 30)];
                inforTextField.enabled = _isend;
                inforTextField.font = [UIFont systemFontOfSize:14];
                NSInteger k = [_TexttagArrs[indexPath.row] integerValue];
                inforTextField.tag = k;
                [cell addSubview:inforTextField];
                [inforTextField addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
                if ([self.isofyou isEqualToString:@"1"]) {
                    if ([_InterNameAry[indexPath.row] isEqualToString:@""]) {
                         inforTextField.placeholder = _ligtextArrs[indexPath.row];
                    }else{
                        if (indexPath.row>1) {
                            inforTextField.text = _InterNameAry[indexPath.row+3];
                        }else{
                            inforTextField.text = _InterNameAry[indexPath.row];
                        }
                        
                    }
                    
                }else{
                     inforTextField.placeholder = _ligtextArrs[indexPath.row];
                }
            }
        }else{
            cell.userInteractionEnabled = _isend;
            if([self.isofyou isEqualToString:@"1"]){
                NSString *stringInt = [NSString stringWithFormat:@"%@",_InterNameAry[indexPath.row+3]];
                if ([stringInt isEqualToString:@""]) {
                    cell.xingLabel.text =_ligtextArrs[indexPath.row];
                }else{
                    if (_InterNameAry.count==0) {
                         cell.xingLabel.text =_ligtextArrs[indexPath.row];
                    }else{
                        cell.xingLabel.text =stringInt;
                    }
                    
                }
                
            }else{
                cell.xingLabel.text =_ligtextArrs[indexPath.row];
            }
                
            
            
            cell.xingLabel.textColor =[UIColor lightGrayColor];
            
        }
        
    }else{
         cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    
    return cell;
}
-(void)FieldText:(UITextField *)textfield{
    switch (textfield.tag) {
        case 0:
            NSLog(@"填写点名");
            _StoreName = textfield.text;
            break;
        case 2:
            NSLog(@"填写乘车信息");
            _RideInfo = textfield.text;
            break;
        case 3:
            NSLog(@"填写面积");
            _Area = textfield.text;
            break;
        case 4:
            NSLog(@"填写其他经营品牌");
            _BrandBusiness = textfield.text;
            break;
        case 5:
            NSLog(@"填写意向品牌");
            _IntentionBrand = textfield.text;
            break;
        default:
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:{
            CityChooseViewController *CityVC = [[CityChooseViewController alloc]init];
            CityVC.isfoyou = @"1";
            CityVC.shopnanme = self.shopname;
            if ([self.isofyou isEqualToString:@"1"]) {
                CityVC.storespoince = _Province;
                CityVC.storescity = _City;
                CityVC.storesCount = _County;
                CityVC.storesaddes = _Address;
                CityVC.storesssss = @"1";
            }
            CityVC.selectedBlock = ^(NSString *province, NSString *city, NSString *area, NSString *zhadd) {
                _Address = zhadd;
                _Province= province;//省
                _City= city;//市
                _County= area;//县
                NSLog(@"%@-%@-%@/n%@",_Province,_City,_County,_Address);
            };
            [self.navigationController showViewController:CityVC sender:nil];
        }
            break;
        case 6:
            _index = indexPath;
            [self lodapickerView:@"选择床位"];
            break;
        case 7:_index = indexPath;
            [self lodapickerView:@"选择有效顾客数量"];
            break;
        case 8:
            _index = indexPath;
            [self lodapickerView:@"选择员工人数"];
            break;
        case 9:
            _index = indexPath;
            [self lodapickerView:@"选择员工从业年限"];
            break;
        case 10:{
            TargetViewController *targetVC=[[TargetViewController alloc]init];
            targetVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            targetVC.dateStr = _Problems;
            targetVC.modifi = _isend;
            targetVC.blcokStr=^(NSString *content,int num){
                if (num==10) {
                    if(_isend == YES) {
                        _Problems = content;
                    }
                   
                }
            };
            [self.navigationController pushViewController:targetVC animated:YES];
        }
            
            //存在优势及问题
            break;
        case 11:{
            TargetViewController *targetVC=[[TargetViewController alloc]init];
            targetVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            targetVC.dateStr = _RunStatus;
            targetVC.modifi = _isend;
            targetVC.blcokStr=^(NSString *content,int num){
                if (num==10) {
                    if(_isend == YES) {
                        _RunStatus = content;
                    }
                    
                }
            };
            [self.navigationController pushViewController:targetVC animated:YES];
            
            
            
            
        }
            break;
        case 12:{
            TargetViewController *targetVC=[[TargetViewController alloc]init];
            targetVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            targetVC.dateStr = _Oftencustomers;
            targetVC.modifi = _isend;
            targetVC.blcokStr=^(NSString *content,int num){
                if (num==10) {
                    if(_isend == YES) {
                        _Oftencustomers = content;
                    }
                    
                }
            };
            [self.navigationController pushViewController:targetVC animated:YES];
        }
            break;
        case 13:{
            TargetViewController *targetVC=[[TargetViewController alloc]init];
            targetVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            targetVC.dateStr = _TooKeenPlan;
            targetVC.modifi = _isend;
            targetVC.blcokStr=^(NSString *content,int num){
                if (num==10) {
                    if(_isend == YES) {
                        _TooKeenPlan = content;
                    }
                    
                }
            };
            [self.navigationController pushViewController:targetVC animated:YES];
        }
            break;
        case 14:{
            //活动概要
            NSString *storeid = [ShareModel shareModel].StoreId;
            if ([self.isofyou isEqualToString:@"1"]) {
                //合作客户---->可以进
                storesActivity *storesyear = [[storesActivity alloc]init];
                storesyear.shopId = self.shopId;
                storesyear.strId = self.strId;
                storesyear.shopname = self.shopname;
                [self.navigationController pushViewController:storesyear animated:YES];
            }else {
                //目标升级合作--->未提交不可进
                if (storeid ==nil){
                    //提示未提交店铺
                }else{
                    storesActivity *storesyear = [[storesActivity alloc]init];
                    storesyear.shopId = self.shopId;
                    storesyear.strId = self.strId;
                    storesyear.shopname = self.shopname;
                    [self.navigationController pushViewController:storesyear animated:YES];
                }
            }
        }
            break;
        default:
            break;
    }
}
-(void)lodapickerView:(NSString *)labelstr{
    self.pickerView=[[CLZoomPickerView alloc]initWithFrame:CGRectMake(0, 0, Scree_width, Scree_height)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.labelStr=labelstr;
    self.pickerView.topRowCount = 1;
    self.pickerView.bottomRowCount = 1;
    self.pickerView.selectedRow = 1;
    self.pickerView.rowHeight = 40;
    self.pickerView.selectedRowFont = [UIFont fontWithName:@"DIN Condensed" size:35];
    self.pickerView.textColor = [UIColor lightGrayColor];
    self.pickerView.unselectedRowScale = 0.5;
    [self.view addSubview:self.pickerView];
}
- (void)pickerView:(CLZoomPickerView *)pickerView changedIndex:(NSUInteger)indexPath
{
    
    inftionTableViewCell *cell = [self.tableView cellForRowAtIndexPath:_index];
        cell.xingLabel.text=_timeArray[indexPath];
        NSLog(@"%@,%@",_timeArray[indexPath],cell.xingLabel.text);
        cell.xingLabel.textColor = [UIColor blackColor];
    switch (_index.row) {
        case 6:
            _Berths =_timeArray[indexPath];
            break;
        case 7:
            _ValidNumber =_timeArray[indexPath];
            break;
        case 8:
            _StaffNumber =_timeArray[indexPath];
            break;
        case 9:
            _JobExpires =_timeArray[indexPath];
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)buLiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItemAction{
   
        NSString *uStr =[NSString stringWithFormat:@"%@shop/updateStore1.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS objectForKey:@"userid"],@"Storeid":self.StoreId,@"RoleId":self.strId,@"StoreName":_StoreName,@"Province":_Province,@"City":_City,@"County":_County,@"Address":_Address,@"RideInfo":_RideInfo,@"Area":_Area,@"BrandBusiness":_BrandBusiness,@"IntentionBrand":_IntentionBrand,@"Berths":_Berths,@"ValidNumber":_ValidNumber,@"StaffNumber":_StaffNumber,@"JobExpires":_JobExpires,@"Problems":_Problems};
        [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"修改成功" sureBtn:@"确认" cancleBtn:nil];
                alertView.resultIndex = ^(NSInteger index){
                    
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
-(void)nstingallocinit:(StoresModel*)model{
    _StoreName = model.storeName;
    [self nsmuary:_StoreName mostr:model.storeName];
    _Province = model.province;
    [self nsmuary:_Province mostr:model.province];
_City = model.city;
    [self nsmuary:_City mostr:model.city];
    _County = model.county;
    [self nsmuary:_County mostr:model.county];
_Address = model.address;
    [self nsmuary:_Address mostr:model.address];
_RideInfo = model.rideInfo;
    [self nsmuary:_RideInfo mostr:model.rideInfo];
_Area = model.area;
    [self nsmuary:_Area mostr:model.area];
_BrandBusiness = model.brandBusiness;
    [self nsmuary:_BrandBusiness mostr:model.brandBusiness];
_IntentionBrand = model.intentionBrand;
    [self nsmuary:_IntentionBrand mostr:model.intentionBrand];
_Berths = model.berths;
    [self nsmuary:_Berths mostr:model.berths];
_ValidNumber = model.validNumber;
    [self nsmuary:_ValidNumber mostr:model.validNumber];
_StaffNumber = model.staffNumber;
    [self nsmuary:_StaffNumber mostr:model.staffNumber];
_JobExpires = model.jobExpires;
    [self nsmuary:_JobExpires mostr:model.jobExpires];
_Problems = model.problems;
    [self nsmuary:_Problems mostr:model.problems];
}
-(void)nsmuary:(NSString *)str mostr:(NSString *)mostr{
    if (mostr == nil) {
        str=@"";
    }else{
        str=mostr;
    }
    [_InterNameAry addObject:str];
}
- (NSInteger)pickerView:(CLZoomPickerView *)pickerView
{
    return _timeArray.count;
}

// CLZoomPickerView 代理，返回指定行显示的字符串
- (NSString *)pickerView:(CLZoomPickerView *)pickerView titleForRow:(NSUInteger)indexPath
{
    return _timeArray[indexPath];
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
