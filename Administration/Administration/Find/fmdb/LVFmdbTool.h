//
//  LVFmdbTool.h
//  LVDatabaseDemo
//
//  Created by 刘春牢 on 15/3/26.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@class LVModel;
@interface LVFmdbTool : NSObject

// 插入模型数据
+ (BOOL)insertModel:(LVModel*)model;

/** 查询数据,如果 传空 默认会查询表中所有数据 */
+ (NSArray *)queryData:(NSString *)querySql;

/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(NSString *)deleteSql;

/** 修改数据 */
+ (BOOL)modifyData:(NSString *)modifySql;

+(void)createTable;

+(NSMutableArray *)selectLately:(NSString *)isCurrent;

+(void)insertUser:(NSString *)currentUserID Userinfo:(NSDictionary *)dict;

+(void)updateLatePerson:(NSDictionary *)dict userID:(NSString *)userid currentUser:(NSString *)currentUser;

+(BOOL)isExist:(NSString *)userid Current:(NSString *)currentUserID;
@end
