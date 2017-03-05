//
//  PerLomapController.m
//  Administration
//
//  Created by zhang on 2017/3/2.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "PerLomapController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "YLDropDownMenu.h"
@interface PerLomapController ()
{
    BMKMapView *_mapView;
    
}
@property (nonatomic, strong)YLDropDownMenu *menuView;
@property (nonatomic, strong)UIView *darkView;
@property (nonatomic, retain)UILabel *label;
@property (nonatomic, retain)UIImageView *iageV;
@property (nonatomic, retain) NSString *longitude;  // 经度

@property (nonatomic, retain) NSString *latitude; // 纬度
//地名
@property (nonatomic, copy) NSString *addressName;
@property (nonatomic, copy) NSString *time;//时间

@end

@implementation PerLomapController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"员工位置";
    NSString *urlStr =[NSString stringWithFormat:@"%@location/getLatestLoc.action",KURLHeader];
    NSString *appKey=[NSString stringWithFormat:@"%@%@",logokey,[USER_DEFAULTS objectForKey:@"token"]];
    NSString *appKeyStr=[ZXDNetworking encryptStringWithMD5:appKey];
    NSDictionary *info=@{@"appkey":appKeyStr,@"usersid":[USER_DEFAULTS  objectForKey:@"userid"],@"usid":_uesrId};
    [ZXDNetworking GET:urlStr parameters:info success:^(id responseObject) {
        if ([[responseObject valueForKey:@"status"]isEqualToString:@"0000"]) {
            self.latitude = [[responseObject valueForKey:@"userList"]valueForKey:@"lat"];
            self.longitude = [[responseObject valueForKey:@"userList"]valueForKey:@"log"];
            self.addressName = [[responseObject valueForKey:@"userList"]valueForKey:@"address"];
            self.time = [[responseObject valueForKey:@"userList"]valueForKey:@"time"];
            [self subView];
            _mapView =[[BMKMapView alloc]initWithFrame:CGRectMake(0,114, Scree_width, Scree_height - 114)];
            _mapView.zoomLevel =16;
            _mapView.showMapScaleBar = YES; // 设定是否显式比例尺
            [self.view addSubview:_mapView];
            
            CLLocationDegrees latitude=[self.latitude doubleValue];
            CLLocationDegrees longitude=[self.longitude doubleValue];
            CLLocationCoordinate2D coordinate =CLLocationCoordinate2DMake(latitude, longitude);
            //     添加一个PointAnnotation
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
            
            annotation.coordinate = coordinate;
            [ _mapView addAnnotation:annotation];
            
            // 将大头针放在地图中心点，
            [ _mapView setCenterCoordinate:coordinate animated:YES];
            
            //取消mapView的任何响应事件,地图不能拖动
            //_mapView.gesturesEnabled = NO;
        }else if ([[responseObject valueForKey:@"status"]isEqualToString:@"4444"]||[[responseObject valueForKey:@"status"]isEqualToString:@"1001"]) {
            PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"提示" message:@"登陆超时请重新登录" sureBtn:@"确认" cancleBtn:nil];
            
            alertView.resultIndex = ^(NSInteger index){
                ViewController *loginVC = [[ViewController alloc] init];
                UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNavC animated:YES completion:nil];
            };
            [alertView showMKPAlertView];
        }if ([[responseObject valueForKey:@"status"]isEqualToString:@"1002"]){
            [ELNAlerTool showAlertMassgeWithController:self andMessage:@"获取地理位置失败" andInterval:1.0f];
        }
    } failure:^(NSError *error) {
        
    } view:self.view MBPro:YES];
    
    
    
}

-(void)subView{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,64, Scree_width, 50)];
    [self.view addSubview:view];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(13,113.5, Scree_width,0.5)];
    view1.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view1];
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *sviewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDoenMenu)];
    sviewTap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:sviewTap];
    
    _label=[[UILabel alloc]initWithFrame:CGRectMake(13, 0, 100, 50)];
    _label.text=[NSString stringWithFormat:@"姓名 %@",_name];
    [view addSubview:_label];
    _iageV=[[UIImageView alloc]initWithFrame:CGRectMake(Scree_width-40,12.5, 20, 25)];
    _iageV.image=[UIImage imageNamed:@"jiantou_03"];
    [view addSubview:_iageV];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    singleTap.numberOfTapsRequired = 1;
    [self.darkView addGestureRecognizer:singleTap];
}
- (void)dropDoenMenu{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.iageV.transform = CGAffineTransformMakeRotation(M_PI/2);
                     }];
    [self.view addSubview:self.darkView];
    self.menuView = [[YLDropDownMenu alloc] initWithFrame:CGRectMake(0, 114,Scree_width, 130)];
    NSArray *array = [_time componentsSeparatedByString:@"."];
    self.menuView.dataSource = @[[NSString stringWithFormat:@"账号 %@",_account],[NSString stringWithFormat:@"现在位置 %@",_addressName],[NSString stringWithFormat:@"最近时间 %@",array[0]]];
    ;
    [self.view addSubview:self.menuView];
    __weak typeof(self)weakSelf = self;
    [self.menuView setFinishBlock:^(NSString *title){
        [UIView animateWithDuration:0.2
                         animations:^{
                             weakSelf.iageV.transform = CGAffineTransformMakeRotation(0);
                         }];
        
        [weakSelf handleSingleTapGesture];
    }];
}
- (void)handleSingleTapGesture{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.iageV.transform = CGAffineTransformMakeRotation(0);
                     }];
    [self.darkView removeFromSuperview];
    [self.menuView removeFromSuperview];
}
- (UIView *)darkView{
    if (!_darkView) {
        _darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        //_darkView.backgroundColor = [UIColor colorWithWhite:.7 alpha:.3];
        _darkView.userInteractionEnabled = YES;
    }
    return _darkView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
