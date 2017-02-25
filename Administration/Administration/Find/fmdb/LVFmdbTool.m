//
//  LVFmdbTool.m
//  LVDatabaseDemo
//
//  Created by 刘春牢 on 15/3/26.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import "LVFmdbTool.h"
#import "LVModel.h"

#define LVSQLITE_NAME @"modals.sqlite"

@implementation LVFmdbTool


static FMDatabase *_fmdb;

+ (void)initialize {
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LVSQLITE_NAME];
    _fmdb = [FMDatabase databaseWithPath:filePath];
    
    [_fmdb open];
    
#warning 必须先打开数据库才能创建表。。。否则提示数据库没有打开
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_modals(id INTEGER PRIMARY KEY, name TEXT NOT NULL, Call TEXT NOT NULL, ID_No TEXT NOT NULL,image TEXT  NOT NULL,time TEXT NOT NULL)"];
   
}

+ (BOOL)insertModel:(LVModel *)model {
    NSString *insertSql =  [NSString stringWithFormat:@"INSERT INTO t_modals(name, Call, ID_No,image,time) VALUES ('%@', '%@', '%@','%@','%@')",model.name,model.Call,model.ID_No,model.image,model.time];
    return [_fmdb executeUpdate:insertSql];
}

+ (NSArray *)queryData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = @"SELECT * FROM t_modals;";
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *name = [set stringForColumn:@"name"];
        NSString *Call = [set stringForColumn:@"Call"];
        NSString *ID_No = [set stringForColumn:@"ID_No"];
        NSString *image =[set stringForColumn:@"image"];
        LVModel *modal = [LVModel modalWith:name call:Call no:ID_No image:image];
        [arrM addObject:modal];
    }
    
    return arrM;
}

+ (BOOL)deleteData:(NSString *)deleteSql {
    
    if (deleteSql == nil) {
        deleteSql = @"DELETE FROM t_modals";
    }
    
    return [_fmdb executeUpdate:deleteSql];

}

+ (BOOL)modifyData:(NSString *)modifySql {
    
    if (modifySql == nil) {
        modifySql = @"UPDATE t_modals SET ID_No = '789789' WHERE name = 'lisi'";
    }
    return [_fmdb executeUpdate:modifySql];
}



@end
