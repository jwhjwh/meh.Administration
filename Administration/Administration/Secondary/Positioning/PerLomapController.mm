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
@interface PerLomapController ()
{
    BMKMapView *_mapView;
   
}
@property (nonatomic, retain) NSString *longitude;  // 经度

@property (nonatomic, retain) NSString *latitude; // 纬度
//地名
@property (nonatomic, copy) NSString *addressName;
@end

@implementation PerLomapController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
