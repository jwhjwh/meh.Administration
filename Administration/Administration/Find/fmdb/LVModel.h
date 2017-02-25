//
//  LVModal.h
//  LVDatabaseDemo
//
//  Created by 刘春牢 on 15/3/26.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *Call;

@property (nonatomic, copy) NSString *ID_No;

@property (nonatomic, retain)NSString *image;

@property (nonatomic,retain)NSString *time;

@property (nonatomic,copy)NSString *roleld;
+ (instancetype)modalWith:(NSString *)name call:(NSString*)Call no:(NSString *)ID_No image:(NSString *)image time:(NSString*)time roleld:(NSString*)roleld;

@end
