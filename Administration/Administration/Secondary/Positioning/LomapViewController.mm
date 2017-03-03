//
//  LomapViewController.m
//  Administration
//
//  Created by zhang on 2017/3/2.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "LomapViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>

@interface LomapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKLocationServiceDelegate>{
    BMKMapView *_mapView;
    BMKLocationService *_locService;
   
}
@property (nonatomic,strong) BMKMapView *mapView;//地图视图
/** 用户当前位置*/
@property(nonatomic , strong) BMKUserLocation *userLocation;

/** 大头针*/
//@property (nonatomic, strong) BMKPointAnnotation *pointAnnotation;
@end

@implementation LomapViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

    self.tabBarController.tabBar.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的位置";
    self.view.backgroundColor=[UIColor redColor];
    self.userLocation = [[BMKUserLocation alloc] init];
    _locService = [[BMKLocationService alloc] init];
    _locService.distanceFilter = 200;//设定定位的最小更新距离，这里设置 200m 定位一次，频繁定位会增加耗电量
    _locService.desiredAccuracy = kCLLocationAccuracyHundredMeters;//设定定位精度
    //设置代理
     _locService .delegate = self;
    //开启定位服务
    [_locService startUserLocationService];
    //初始化BMKMapView
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, Scree_width, Scree_height - 64)];
      _mapView.delegate=self;
    [_mapView setMapType:BMKMapTypeStandard];
    _mapView.showsUserLocation=YES;//可以显示用户位置
    _mapView.showMapScaleBar = YES; // 设定是否显式比例尺
    [self.view addSubview:_mapView];
    
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    BMKLocationViewDisplayParam *userlocationStyle = [[BMKLocationViewDisplayParam alloc] init];
    userlocationStyle.isRotateAngleValid = YES;
    userlocationStyle.isAccuracyCircleShow = NO;
    [_mapView updateLocationData:self.userLocation];
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    
    //展示定位
    self.mapView.showsUserLocation = YES;
    
    //更新位置数据
    [self.mapView updateLocationData:userLocation];
    
    //获取用户的坐标
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    
    self.mapView.zoomLevel =16;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
