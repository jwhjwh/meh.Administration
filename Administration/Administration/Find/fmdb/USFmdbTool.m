//
//  USFmdbTool.m
//  Administration
//
//  Created by zhang on 2017/5/20.
//  Copyright © 2017年 九尾狐. All rights reserved.
//

#import "USFmdbTool.h"
#import "Userpas.h"
#define USSQLITE_NAME @"userpas.sqlite"
@implementation USFmdbTool
static FMDatabase *_fmdb;
+ (void)initialize{
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:USSQLITE_NAME];
    _fmdb = [FMDatabase databaseWithPath:filePath];
    
    [_fmdb open];
    
#warning 必须先打开数据库才能创建表  否则提示数据库没有打开
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_userpas(id INTEGER PRIMARY KEY, userid TEXT NOT NULL, password TEXT NOT NULL,isopen  TEXT NOT NULL)"];
}

+ (BOOL)insertModel:(Userpas *)model {
    NSString *insertSql =  [NSString stringWithFormat:@"INSERT INTO t_userpas(userid, password,isopen) VALUES ('%@', '%@','%@')",model.userid,model.password,model.isopen];
    return [_fmdb executeUpdate:insertSql];
}

+ (NSArray *)queryData:(NSString *)querySql {
    if (querySql == nil) {
        querySql = @"SELECT * FROM t_userpas;";
    }
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    while ([set next]) {
        NSString *userid = [set stringForColumn:@"userid"];
        NSString *password = [set stringForColumn:@"password"];
        NSString *isopen = [set stringForColumn:@"isopen"];
        Userpas *modal = [Userpas modalWith:userid password:password isopen:isopen];
        [arrM addObject:modal];
    }
    return arrM;
}

+ (BOOL)deleteData:(NSString *)deleteSql {
    if (deleteSql == nil) {
        deleteSql = @"DELETE FROM t_userpas";
    }
    return [_fmdb executeUpdate:deleteSql];
}

+ (BOOL)modifyData:(NSString *)modifySql {
    if (modifySql == nil) {
        modifySql = @"UPDATE t_userpas SET password = '789789' WHERE userid = 'lisi'";
    }
    return [_fmdb executeUpdate:modifySql];  
}


@end
