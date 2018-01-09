//
//  FillinfoViewController.m
//  Administration
//
//  Created by zhang on 2017/3/10.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "FillinfoViewController.h"
#import "StoreprofileController.h"
#import "InputboxController.h"
#import "FillTableViewCell.h"
#import "inftionTableViewCell.h"
#import "XFDaterView.h"
#import "CityChoose.h"
#import "SelectAlert.h"

#import "SiginViewController.h"

#import<BaiduMapAPI_Map/BMKMapView.h>

#import <CoreLocation/CoreLocation.h>

#import<BaiduMapAPI_Location/BMKLocationService.h>

#import<BaiduMapAPI_Search/BMKGeocodeSearch.h>

#import<BaiduMapAPI_Map/BMKMapComponent.h>

#import<BaiduMapAPI_Search/BMKPoiSearchType.h>

#import "ResponsibleArea.h"
@interface FillinfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,XFDaterViewDelegate>
{
      XFDaterView*dater;
    BMKLocationService *_locService;  //定位
    BOOL _islode;
    BMKGeoCodeSearch *_geocodesearch; //地理编码主类，用来查询、返回结果信息
}
@property (nonatomic, strong) CityChoose *cityChoose;/** 城市选择 */
@property (nonatomic,retain)UITableView *infonTableview;
@property (nonatomic,retain)NSArray *arr;
@property (nonatomic,retain)UILabel *rxLbale;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,retain) NSString *address;
@property (nonatomic,retain)NSIndexPath *Index;
@property (nonatomic,retain)NSString *storedate;//日期
@property (nonatomic,retain)NSString *storepersonnel;//人员
@property (nonatomic,retain)NSString *storeregion;//地区
@property (nonatomic,retain)NSString *storename;//店名
@property (nonatomic,retain)NSString *storeaddree;//地址
@property (nonatomic,retain)NSString *storehead;//负责人
@property (nonatomic,retain)NSString *storephone;//手机
@property (nonatomic,retain)NSString *storewxphone;//微信
@property (nonatomic,retain)NSString *storebrand;//品牌
@property (nonatomic,retain)NSString *clascation;//分类
@property (nonatomic,retain)NSString *stotrType;//门店类型
@property (nonatomic,retain)NSString *Abrief;//简要
@property (nonatomic,retain)NSString *instructions;//说明
@property (nonatomic,retain)NSString *note;//备注
@property (nonatomic,retain)NSString *brandBusin;//美容师人数
@property (nonatomic,retain)NSString *planDur;//经营年限
@property (nonatomic,retain)NSString *Berths;//床位

@property (nonatomic, strong) CLGeocoder *geoC;

@property (nonatomic,retain)NSString *sigincity;
@property (nonatomic,retain)NSString *ShopId;

@end

@implementation FillinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLocation];
    self.title=@"陌拜记录";
    [self NSStringalloc];

    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"···" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    _arr=@[@"日期",@"业务人员",@"地区",@"店名",@"店铺地址",@"负责人",@"手机",@"微信",@"主要经营品牌",@"店面评估档次分类",@"店面情况简介",@"关注项目及所需信息简要",@"会谈起止时间概要说明(必填)",@"备注"];
    [self vSubviews];
    _islode=YES;
}
-(void)NSStringalloc{
    _sigincity = [[NSString alloc]init];
    _ShopId = [[NSString alloc]init];

    _storephone = [[NSString alloc]init];
    _storephone = @"";
    _storewxphone = [[NSString alloc]init];
    _storewxphone = @"";
    _storebrand =  [[NSString alloc]init];
    _storebrand = @"";
    _clascation = [[NSString alloc]init];
    _clascation = @"";
    _stotrType = [[NSString alloc]init];
    _stotrType = @"";
    _Abrief = [[NSString alloc]init];
    _Abrief = @"";
    _instructions = [[NSString alloc]init];
    _instructions = @"";
    _note = [[NSString alloc]init];
    _note = @"";
    _brandBusin = [[NSString alloc]init];
    _brandBusin = @"";
    _planDur = [[NSString alloc]init];
    _planDur = @"";
    _Berths = [[NSString alloc]init];
    _Berths = @"";
    
    
}
-(void)startLocation
{   //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    //启动LocationService
    [_locService startUserLocationService];
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self;
}
- (CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count>0) {
            CLPlacemark *place = [placemarks objectAtIndex:0];
            if (place != nil) {
                NSString *XIAN = place.administrativeArea;
                NSLog(@"%@%@%@%@%@",place.country,XIAN,place.locality,place.subLocality,place.name);
                [_locService stopUserLocationService];
                //_sigincity = [[NSString alloc]init];
                _sigincity = [NSString stringWithFormat:@"%@%@%@%@%@",place.country,XIAN,place.locality,place.subLocality,place.name];
            }
        }
    }];
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error

{
    
   // NSLog(@"address:%@----%@",result.addressDetail,result.address);
    _address=result.address;
    _storeaddree=result.address;
    NSLog(@"address:%@",_address);
    [_infonTableview reloadData];    
}
-(void)vSubviews{
    _infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    _infonTableview.dataSource=self;
    _infonTableview.delegate =self;
    [self.view addSubview:_infonTableview];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{

    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }else{
        return _arr.count;
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{     CGRect labelRect2 = CGRectMake(120, 1, self.view.bounds.size.width-170, 48);
   
    if(indexPath.row<8){
    inftionTableViewCell *cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell ==nil)
    {
       cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
        if (indexPath.section == 0) {
            UIImageView *SiginImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-30, 10, 30, 30)];
            SiginImage.image = [UIImage imageNamed:@"qd_ico"];
            [cell addSubview:SiginImage];
            UILabel *SiginLabel = [[UILabel alloc]initWithFrame:CGRectMake(((self.view.frame.size.width/2)-30)+30, 10, 50, 30)];
            SiginLabel.text = @"签到";
            [cell addSubview:SiginLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
        }
        if (indexPath.section ==1) {
            if (indexPath.row>2) {
                _textField=[[UITextField alloc]initWithFrame:labelRect2];
                _textField.font = [UIFont boldSystemFontOfSize:14.0f];
                [_textField addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
                _textField.tag = indexPath.row;
                [cell addSubview:_textField];
                if (indexPath.row==4) {
                    _textField.text=_address;
                }
                if((!(indexPath.row==6))&&(!(indexPath.row == 7))){
                    _textField.placeholder=@"必填";
                }
            }else{
                if(indexPath.row==1){
                    cell.xingLabel.text=[USER_DEFAULTS objectForKey:@"name"];
                    _storepersonnel=[USER_DEFAULTS objectForKey:@"name"];
                    
                }else{
                    cell.xingLabel.textColor=[UIColor lightGrayColor];
                    cell.xingLabel.text=@"必填";
                }
                if (indexPath.row==0&&!(_storedate==nil)) {
                    cell.xingLabel.text= _storedate;
                    cell.xingLabel.textColor=[UIColor blackColor];
                }
            }
            cell.mingLabel.text=_arr[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    
    return cell;
    }else{
    FillTableViewCell *cell = [[FillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FillTableCell"];
    if (cell == nil) {
        cell = [[FillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FillTableCell"];
    }
    if (!(indexPath.row==9)) {
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    cell.mingLabel.text=_arr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    return cell;
}
    
}
-(void)SigintNetWorking{
    
        NSArray *array = [_storeregion componentsSeparatedByString:@" "];
        if (_storedate == nil) {
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写时间" andInterval:1.0];
        }else if (array[0]==nil && array[1] ==nil  && array[2] ==nil){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写地区" andInterval:1.0];
        }else if( _storename ==nil){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写店名" andInterval:1.0];
        }else if(_storeaddree == nil){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写详细地址" andInterval:1.0];
        }else if(_storehead == nil){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"请填写负责人" andInterval:1.0];
        }else{
            if([_ShopId isEqualToString:@""]){
                NSString *uwStr =[NSString stringWithFormat:@"%@shop/insertShop.action",KURLHeader];
                NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
                NSString *RoleId=[NSString stringWithFormat:@"%@",self.points];
                NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
                
                NSDictionary *dic=[[NSDictionary alloc]init];
                dic = @{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"Dates":_storedate,@"Province":array[0],@"City":array[1],@"County":array[2],@"StoreName":_storename,@"Address":_storeaddree,@"Name":_storehead,@"RoleId":RoleId,@"Draft":@"1"};
                [ZXDNetworking POST:uwStr parameters:dic success:^(id responseObject) {
                    if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                        SiginViewController *siginVC = [[SiginViewController alloc]init];
                        _ShopId = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"ShopId"]];
                        siginVC.shopid =_ShopId;
                        siginVC.Address = _sigincity;
                        siginVC.Types = @"1";
                        [self.navigationController pushViewController:siginVC animated:YES];
                        
                    }
                    
                    
                    //ShopId = 10;  WorshipRecordId = 1;
                    
                } failure:^(NSError *error) {
                    
                } view:self.view];
            }
            
        }

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   _Index=indexPath;
    inftionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        [self SigintNetWorking];
        
        
    }else{
        switch (indexPath.row) {
            case 0:
                dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
                dater.delegate=self;
                [dater showInView:self.view animated:YES];
                break;
            case 2:{
//                [self.view endEditing:YES];
//                self.cityChoose = [[CityChoose alloc] init];
//                self.cityChoose.config = ^(NSString *province, NSString *city, NSString *town){
//                    cell.xingLabel.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,town];
//                    cell.xingLabel.textColor=[UIColor blackColor];
//                    _storeregion=[NSString stringWithFormat:@"%@ %@ %@",province,city,town];
//                };
               [self.view addSubview:self.cityChoose];
                ResponsibleArea *resVC = [[ResponsibleArea alloc]init];
                resVC.points = self.points;
                resVC.DepartmentId = self.depant;
                [self.navigationController pushViewController:resVC animated:YES];
            
            }
                break;
            case 8:{
                InputboxController *inputVC=[[InputboxController alloc]init];
                inputVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
                inputVC.blcokStr=^(NSString *content,int num){
                    if (num==8) {
                        _storebrand=content;
                        
                    }
                };
                [self.navigationController pushViewController:inputVC animated:YES];
            }
                break;
            case 9:{
                
                [SelectAlert showWithTitle:@"类型" titles:@[@"A类",@"B类",@"C类"] selectIndex:^(NSInteger selectIndex) {
                    
                } selectValue:^(NSString *selectValue) {
                    FillTableViewCell *cell = [_infonTableview cellForRowAtIndexPath:_Index];
                    cell.xingLabel.text=selectValue;
                    _clascation=selectValue;
                } showCloseButton:NO];
            }
                break;
            case 10:{
                StoreprofileController *stireVC=[[StoreprofileController alloc]init];
                stireVC.blcokString=^(NSString *type,NSString *year,NSString *perpon,NSString *beds){
                    _stotrType=type;
                    _planDur=year;
                    _brandBusin=perpon;
                    _Berths=beds;
                    
                };
                [self.navigationController pushViewController:stireVC animated:YES];
            }
                break;
            case 11:{
                InputboxController *inputVC=[[InputboxController alloc]init];
                inputVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
                inputVC.blcokStr=^(NSString *content,int num){
                    _Abrief=content;
                    
                };
                [self.navigationController pushViewController:inputVC animated:YES];
            }
                break;
            case 12:{
                InputboxController *inputVC=[[InputboxController alloc]init];
                inputVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
                inputVC.blcokStr=^(NSString *content,int num){
                    _instructions=content;
                    
                };
                [self.navigationController pushViewController:inputVC animated:YES];
            }
                break;
            case 13 :{
                InputboxController *inputVC=[[InputboxController alloc]init];
                inputVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
                inputVC.blcokStr=^(NSString *content,int num){
                    _note=content;
                    
                };
                [self.navigationController pushViewController:inputVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
    
    
    
}

- (void)daterViewDidClicked:(XFDaterView *)daterView{
    //NSLog(@"dateString=%@ timeString=%@",dater.dateString,dater.timeString);
    inftionTableViewCell *cell = [_infonTableview cellForRowAtIndexPath:_Index];
    cell.xingLabel.text=dater.dateString;
    _storedate=dater.dateString;
    cell.xingLabel.textColor=[UIColor blackColor];
}
-(void)FieldText:(UITextField*)sender{
   
    switch (sender.tag) {
        case 3:{
            _storename=sender.text;
     
        }
            break;
        case 4:{
            _storeaddree=sender.text;
            
        }
            break;
        case 5:{
            _storehead=sender.text;
           
        }
            break;
        case 6:{
            _storephone=sender.text;
           
        }
            break;
        case 7:{
            _storewxphone = sender.text;
            NSLog(@"%@",sender.text);
        } break;
        default:
            break;
    }
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItemAction:(UIBarButtonItem*)sender{
    NSArray *zwlbAry = [[NSArray alloc]init];
    zwlbAry = @[@"提交",@"保存至草稿箱"];
    [SelectAlert showWithTitle:nil titles:zwlbAry selectIndex:^(NSInteger selectIndex) {
        NSLog(@"选择了第%ld个",(long)selectIndex);
        if (selectIndex == 0) {
            [self UploadInformation];
        }else{
            [self Savetodraftbox];
        }
        
    } selectValue:^(NSString *selectValue) {
        
    } showCloseButton:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)UploadInformation{
    if (_islode==YES) {
        NSString *uStr =[NSString stringWithFormat:@"%@shop/insertShop.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSArray *array = [_storeregion componentsSeparatedByString:@" "];
         NSString *RoleId=[NSString stringWithFormat:@"%@",self.points];
        NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
        NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"Dates":_storedate,@"Name":_storehead,@"Province":array[0],@"City":array[1],@"County":array[2],@"StoreName":_storename,@"Address":_storeaddree,@"Iphone":_storephone,@"Wcode":_storewxphone,@"BrandBusiness":_storebrand,@"StoreLevel":_clascation,@"StoreType":_stotrType,@"PlantingDuration":_planDur,@"BeauticianNU":_brandBusin,@"Berths":_Berths,@"ProjectBrief":_Abrief,@"MeetingTime":_instructions,@"Modified":_note,@"RoleId":RoleId,@"Draft":@"1",@"CompanyId":compid,@"UsersName":[USER_DEFAULTS objectForKey:@"name"],@"DepartmentID":self.depant};
        [ZXDNetworking POST:uStr parameters:dic success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"提交成功" andInterval:1.0];
                _islode=NO;
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
            
        } view:self.view];
    }else{
         [ELNAlerTool showAlertMassgeWithController:self andMessage:@"已提交成功，请勿重复提交" andInterval:1.0];
    }
}

-(void)Savetodraftbox{
    if (_islode==YES) {
        NSString *uStr =[NSString stringWithFormat:@"%@shop/insertShop.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSArray *array = [_storeregion componentsSeparatedByString:@" "];
        NSString *RoleId=[NSString stringWithFormat:@"%@",self.points];
        NSString *compid=[NSString stringWithFormat:@"%@",[USER_DEFAULTS objectForKey:@"companyinfoid"]];
        NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"Dates":_storedate,@"Name":_storehead,@"Province":array[0],@"City":array[1],@"County":array[2],@"StoreName":_storename,@"Address":_storeaddree,@"Iphone":_storephone,@"Wcode":_storewxphone,@"BrandBusiness":_storebrand,@"StoreLevel":_clascation,@"StoreType":_stotrType,@"PlantingDuration":_planDur,@"BeauticianNU":_brandBusin,@"Berths":_Berths,@"ProjectBrief":_Abrief,@"MeetingTime":_instructions,@"Modified":_note,@"RoleId":RoleId,@"Draft":@"0",@"CompanyId":compid,@"UsersName":[USER_DEFAULTS objectForKey:@"name"]};
        [ZXDNetworking POST:uStr parameters:dic success:^(id responseObject) {
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"保存成功" andInterval:1.0];
                _islode=NO;
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
            
        } view:self.view];
    }else{
        [ELNAlerTool showAlertMassgeWithController:self andMessage:@"已提交成功，请勿重复提交" andInterval:1.0];
    }


}
#pragma mark - 补全分隔线左侧缺失
- (void)viewDidLayoutSubviews {
    if ([_infonTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [_infonTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([_infonTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [_infonTableview setLayoutMargins:UIEdgeInsetsZero];
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
@end
