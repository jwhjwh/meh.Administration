//
//  Provice.m
//  PickView
//
//  Created by 袁志浦 on 16/6/23.
//  Copyright © 2016年 北京内圈科技有限公司. All rights reserved.
//

#import "Provice.h"

@implementation Provice

- (instancetype)initWithProviceDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.code = dic[@"code"];
        self.proID = dic[@"proID"];
        self.name = dic[@"name"];
    }
    return self;
}

@end

@implementation City

- (instancetype)initWithCityDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.code = dic[@"code"];
        self.proID = dic[@"proID"];
        self.name = dic[@"name"];
        self.cityID = dic[@"cityID"];
    }
    return self;
}

@end

@implementation Area

- (instancetype)initWithAreaDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.code = dic[@"code"];
        self.cityID = dic[@"cityID"];
        self.name = dic[@"name"];
    }
    return self;
}

@end


@implementation UnCodePlace

//根据地区码返回地址信息
+ (NSMutableString *)addressWithProviceCode:(NSString*)proCode withCityCode:(NSString*)citCode withAreaCode:(NSString*)areaCode{
    NSMutableString *str = [NSMutableString string];
    NSArray *cityArr = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"city" withExtension:@"plist"]];
    NSArray *provinceArr = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"province" withExtension:@"plist"]];
    NSArray *districtArr = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"area" withExtension:@"plist"]];
    for (int i=0; i<3; i++) {
        if (i==0) {
            for (NSDictionary *dic in provinceArr) {
                if ([proCode isEqual:dic[@"code"]]) {
                    [str appendString:[NSString stringWithFormat:@"%@",dic[@"name"]]];
                }
            }
            
        }else if (i==1){
            for (NSDictionary *dic in cityArr) {
                if ([citCode isEqual:dic[@"code"]]) {
                    [str appendString:dic[@"name"]];
                }
            }
        }else if (i==2){
            for (NSDictionary *dic in districtArr) {
                if ([areaCode isEqual:dic[@"code"]]) {
                    [str appendString:dic[@"name"]];
                }
            }
        }
    }
    return str;
}

@end