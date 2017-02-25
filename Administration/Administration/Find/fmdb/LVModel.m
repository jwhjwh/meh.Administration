//
//  LVModal.m
//  LVDatabaseDemo
//
//  Created by 刘春牢 on 15/3/26.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import "LVModel.h"

@implementation LVModel


+ (instancetype)modalWith:(NSString *)name call:(NSString*)Call no:(NSString *)ID_No image:(NSString *)image time:(NSString*)time{
    LVModel *model = [[self alloc] init];
    model.name = name;
    model.Call = Call;
    model.ID_No = ID_No;
    model.image=image;
    model.time=time;
    return model;
}

@end
