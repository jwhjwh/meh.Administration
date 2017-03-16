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
#import<BaiduMapAPI_Map/BMKMapView.h>

#import<BaiduMapAPI_Location/BMKLocationService.h>

#import<BaiduMapAPI_Search/BMKGeocodeSearch.h>

#import<BaiduMapAPI_Map/BMKMapComponent.h>

#import<BaiduMapAPI_Search/BMKPoiSearchType.h>
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
@property (nonatomic,retain)NSString *storephone;//微信/手机
@property (nonatomic,retain)NSString *storebrand;//品牌
@property (nonatomic,retain)NSString *clascation;//分类
@property (nonatomic,retain)NSString *stotrType;//门店类型
@property (nonatomic,retain)NSString *Abrief;//简要
@property (nonatomic,retain)NSString *instructions;//说明
@property (nonatomic,retain)NSString *note;//备注
@property (nonatomic,retain)NSString *brandBusin;//美容师人数
@property (nonatomic,retain)NSString *planDur;//经营年限
@property (nonatomic,retain)NSString *Berths;//床位

@end

@implementation FillinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLocation];
    self.title=@"陌拜记录";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 28,28);
    btn.autoresizesSubviews=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(buiftItem) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=buttonItem;
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightItemAction:)];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    _arr=@[@"日期",@"业务人员",@"地区",@"店名",@"店铺地址",@"负责人",@"手机／微信",@"主要经营品牌",@"店面评估档次分类",@"店面情况简介",@"关注项目及所需信息简要",@"会谈起止时间概要说明(必填)",@"备注"];
    [self vSubviews];
    _islode=YES;
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
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation

{
    
   // NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //地理反编码
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    
    if(flag){
        
        NSLog(@"反geo检索发送成功");
        
        [_locService stopUserLocationService];
        
    }else{
        
        NSLog(@"反geo检索发送失败");
        
    }
    
}
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error

{
    
   // NSLog(@"address:%@----%@",result.addressDetail,result.address);
    _address=result.address;
    _storeaddree=result.address;
    [_infonTableview reloadData];
    //addressDetail:     层次化地址信息
    
    //address:    地址名称
    
    //businessCircle:  商圈名称
    
    // location:  地址坐标
    
    //  poiList:   地址周边POI信息，成员类型为BMKPoiInfo
    
}
-(void)vSubviews{
    _infonTableview= [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height+49) style:UITableViewStylePlain];
    _infonTableview.dataSource=self;
    _infonTableview.delegate =self;
    [self.view addSubview:_infonTableview];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{     CGRect labelRect2 = CGRectMake(120, 1, self.view.bounds.size.width-170, 48);
    if(indexPath.row<7){
    inftionTableViewCell *cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    if (cell ==nil)
    {
       cell = [[inftionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bcCell"];
    }
        if (indexPath.row>2) {
             _textField=[[UITextField alloc]initWithFrame:labelRect2];
             _textField.font = [UIFont boldSystemFontOfSize:14.0f];
            [_textField addTarget:self action:@selector(FieldText:) forControlEvents:UIControlEventEditingChanged];
            _textField.tag = indexPath.row;
            [cell addSubview:_textField];
            if (indexPath.row==4) {
            _textField.text=_address;
            }
            if(!(indexPath.row==6)){
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
    return cell;
}else{
    FillTableViewCell *cell = [[FillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FillTableCell"];
    if (cell == nil) {
        cell = [[FillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FillTableCell"];
    }
    if (!(indexPath.row==8)) {
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右箭头
    }
    cell.mingLabel.text=_arr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    return cell;
}
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   _Index=indexPath;
    inftionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
            dater.delegate=self;
            [dater showInView:self.view animated:YES];
            break;
        case 2:{
            self.cityChoose = [[CityChoose alloc] init];
            self.cityChoose.config = ^(NSString *province, NSString *city, NSString *town){
                cell.xingLabel.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,town];
                cell.xingLabel.textColor=[UIColor blackColor];
                _storeregion=[NSString stringWithFormat:@"%@ %@ %@",province,city,town];
            };
            [self.view addSubview:self.cityChoose];
        }
            break;
        case 7:{
            InputboxController *inputVC=[[InputboxController alloc]init];
            inputVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            inputVC.blcokStr=^(NSString *content,int num){
                if (num==7) {
                _storebrand=content;
                  
                }
            };
            [self.navigationController pushViewController:inputVC animated:YES];
        }
            break;
        case 8:{
         
            [SelectAlert showWithTitle:@"类型" titles:@[@"A类",@"B类",@"C类"] selectIndex:^(NSInteger selectIndex) {
                
            } selectValue:^(NSString *selectValue) {
                FillTableViewCell *cell = [_infonTableview cellForRowAtIndexPath:_Index];
                cell.xingLabel.text=selectValue;
                _clascation=selectValue;
            } showCloseButton:NO];
        }
            break;
        case 9:{
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
        case 10:{
            InputboxController *inputVC=[[InputboxController alloc]init];
            inputVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            inputVC.blcokStr=^(NSString *content,int num){
                _Abrief=content;
               
            };
            [self.navigationController pushViewController:inputVC animated:YES];
        }
            break;
        case 11:{
            InputboxController *inputVC=[[InputboxController alloc]init];
            inputVC.number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            inputVC.blcokStr=^(NSString *content,int num){
                _instructions=content;
                
            };
            [self.navigationController pushViewController:inputVC animated:YES];
        }
            break;
        case 12 :{
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
            
        default:
            break;
    }
}
-(void)buiftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightItemAction:(UIBarButtonItem*)sender{
    [self UploadInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)UploadInformation{
    if (_islode==YES) {
        NSString *uStr =[NSString stringWithFormat:@"%@shop/addrecord.action",KURLHeader];
        NSString *apKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
        NSString *apKeyStr=[ZXDNetworking encryptStringWithMD5:apKey];
        NSArray *array = [_storeregion componentsSeparatedByString:@" "];
        NSDictionary *dic=@{@"appkey":apKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"Dates":_storedate,@"Name":_storepersonnel,@"Province":array[0],@"City":array[1],@"County":array[2],@"StoreName":_storename,@"Address":_storeaddree,@"Principal":_storehead,@"Iphone":_storephone,@"BrandBusiness":_storebrand,@"StoreLevel":_clascation,@"StoreType":_stotrType,@"PlantingDuration":_planDur,@"BeauticianNU":_brandBusin,@"Berths":_Berths,@"ProjectBrief":_Abrief,@"MeetingTime":_instructions,@"Modified":_note};
        [ZXDNetworking GET:uStr parameters:dic success:^(id responseObject) {
            
            if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"提交成功" andInterval:1.0];
                _islode=NO;
            } else  if ([[responseObject valueForKey:@"status"]isEqualToString:@"5000"]) {
                [ELNAlerTool showAlertMassgeWithController:self andMessage:@"没有搜索到更多品牌信息" andInterval:1.0];
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
    }else{
         [ELNAlerTool showAlertMassgeWithController:self andMessage:@"已提交成功，请勿重复提交" andInterval:1.0];
    }
    
}
@end
