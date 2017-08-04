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
    #warning 必须先打开数据库才能创建表  否则提示数据库没有打开
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_modals(id INTEGER PRIMARY KEY, name TEXT NOT NULL, Call TEXT NOT NULL, ID_No TEXT NOT NULL,image TEXT  NOT NULL,time TEXT NOT NULL,roleld TEXT NOT NULL)"];
    
    NSMutableString *SQL = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS latelyPerson"];
    [SQL appendString:@" ("];
    [SQL appendString:@" id INTEGER IDENTITY(1,1)  PRIMARY KEY"];
    [SQL appendString:@" ,userid TEXT NOT NULL"];
    [SQL appendString:@" ,account"];
    [SQL appendString:@" ,name "];
    [SQL appendString:@" ,Call "];
    [SQL appendString:@" ,ID_No"];
    [SQL appendString:@" ,roleId "];
    [SQL appendString:@" ,uuid "];
    [SQL appendString:@" ,newName"];
    [SQL appendString:@" ,isCurrent"];
    [SQL appendString:@" ,image TEXT"];
    [SQL appendString:@" )"];
    [_fmdb executeUpdate:SQL];
    
}


+ (BOOL)insertModel:(LVModel *)model {
    NSString *insertSql =  [NSString stringWithFormat:@"INSERT INTO t_modals(name, Call, ID_No,image,time,roleld) VALUES ('%@', '%@', '%@','%@','%@','%@')",model.name,model.Call,model.ID_No,model.image,model.time,model.roleld];
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
        NSString *time =[set stringForColumn:@"time"];
        NSString *roleld =[set stringForColumn:@"roleld"];
        LVModel *modal = [LVModel modalWith:name call:Call no:ID_No image:image time:time roleld:roleld];
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

//+(void)createTable
//{
////    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LVSQLITE_NAME];
////    _fmdb = [FMDatabase databaseWithPath:filePath];
////    [_fmdb open];
//    
//    NSMutableString *SQL;
//    [SQL appendFormat:@"CREATE TABLE IF NOT EXISTS latelyPerson"];
//    [SQL appendString:@" ("];
//    [SQL appendString:@" userid INTEGER PRIMARY KEY "];
//    [SQL appendString:@" ,name TEXT"];
//    [SQL appendString:@" ,Call TEXT"];
//    [SQL appendString:@" ,ID_No TEXT"];
//    [SQL appendString:@" ,image TEXT"];
//    [SQL appendString:@" ,roleld TEXT"];
//    [SQL appendString:@" ,uuid TEXT"];
//    [SQL appendString:@" ,isCurrent"];
//    [SQL appendString:@" )"];
//    [_fmdb executeUpdate:SQL];
//
//}

+(NSMutableArray *)selectLately:(NSString *)isCurrent
{
    NSMutableString *SQL = [NSMutableString stringWithFormat:@"SELECT * FROM latelyPerson"];
   // [SQL appendFormat:@"SELECT * FROM latelyPerson"];
    [SQL appendString:@"  WHERE"];
    [SQL appendString:[NSString stringWithFormat:@"  isCurrent = '%@'",isCurrent]];
    
    FMResultSet *set = [_fmdb executeQuery:SQL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *arrM = [NSMutableArray array];
    
    while ([set next]) {
        NSString *userid = [set stringForColumn:@"userid"];
        NSString *name = [set stringForColumn:@"name"];
        NSString *account = [set stringForColumn:@"account"];
        NSString *ID_No = [set stringForColumn:@"ID_No"];
        NSString *image =[set stringForColumn:@"image"];
       // NSString *time =[set stringForColumn:@"time"];
        NSString *roleId =[set stringForColumn:@"roleId"];
        NSString *uuid = [set stringForColumn:@"uuid"];
        NSString *newName = [set stringForColumn:@"newName"];
        NSString *isCurrent = [set stringForColumn:@"isCurrent"];
        [dict setValue:userid forKey:@"userid"];
        [dict setValue:name forKey:@"name"];
        [dict setValue:account forKey:@"account"];
        [dict setValue:ID_No forKey:@"idNo"];
        [dict setValue:image forKey:@"imge"];
        [dict setValue:roleId forKey:@"roleId"];
        [dict setValue:newName forKey:@"newName"];
        [dict setValue:uuid forKey:@"uuid"];
        [dict setValue:isCurrent forKey:@"isCurrent"];
        [dict setObject:image forKey:@"image"];
        [arrM addObject:dict];
    }
    return arrM;

}

+(void)insertUser:(NSString *)currentUserID Userinfo:(NSDictionary *)dict
{
    NSMutableString *SQL = [NSMutableString stringWithFormat:@"INSERT INTO latelyPerson"];
    //[SQL appendFormat:@"  INSERT INTO latelyPerson"];
    [SQL appendString:@"  ("];
    [SQL appendString:@"  userid"];
    [SQL appendString:@" ,name"];
    [SQL appendString:@" ,account"];
    [SQL appendString:@" ,ID_No"];
    [SQL appendString:@" ,image"];
    [SQL appendString:@" ,roleId"];
    [SQL appendString:@" ,uuid"];
    [SQL appendString:@" ,newName"];
    [SQL appendString:@" ,isCurrent"];
    [SQL appendString:@" )"];
    [SQL appendString:@" VALUES"];
    [SQL appendString:@"("];
    [SQL appendString:[NSString stringWithFormat:@"  '%@'",dict[@"usersid"]]];
    [SQL appendString:[NSString stringWithFormat:@" ,'%@'",dict[@"name"]]];
    [SQL appendString:[NSString stringWithFormat:@" ,'%@'",dict[@"account"]]];
    [SQL appendString:[NSString stringWithFormat:@" ,'%@'",dict[@"idNo"]]];
    [SQL appendString:[NSString stringWithFormat:@" ,'%@'",dict[@"icon"]]];
    [SQL appendString:[NSString stringWithFormat:@" ,'%@'",dict[@"roleId"]]];
    [SQL appendString:[NSString stringWithFormat:@" ,'%@'",dict[@"uuid"]]];
    [SQL appendString:[NSString stringWithFormat:@" ,'%@'",dict[@"newName"]]];
    [SQL appendString:[NSString stringWithFormat:@" ,'%@'",currentUserID]];
    [SQL appendString:@")"];
    [_fmdb executeUpdate:SQL];
    
}

+(void)updateLatePerson:(NSDictionary *)dict userID:(NSString *)userid currentUser:(NSString *)currentUser
{
    NSMutableString *SQL = [NSMutableString stringWithFormat:@"UPDATE latelyPerson SET"];
    //[SQL appendFormat:@"UPDATE latelyPerson SET"];
    [SQL appendString:[NSString stringWithFormat:@" ,userid = '%@'",dict[@"userid"]]];
    [SQL appendString:[NSString stringWithFormat:@" ,name = '%@'",dict[@"name"]]];
    [SQL appendString:[NSString stringWithFormat:@" ,idNo = '%@'",dict[@"idNo"]]];
    [SQL appendString:[NSString stringWithFormat:@" ,image = '%@'",dict[@"icon"]]];
    [SQL appendString:[NSString stringWithFormat:@" ,uuid = '%@'",dict[@"uuid"]]];
    [SQL appendString:[NSString stringWithFormat:@" ,account = '%@'",dict[@"account"]]];
    [SQL appendString:[NSString stringWithFormat:@" ,roleId = '%@'",dict[@"roleId"]]];
    [SQL appendString:[NSString stringWithFormat:@" ,roleId = '%@'",dict[@"newName"]]];
   // [SQL appendString:[NSString stringWithFormat:@" ,currentUserID = %@",currentUser]];
    [SQL appendString:@"WHERE"];
    [SQL appendString:[NSString stringWithFormat:@"  userid = %@",userid]];
    [SQL appendString:[NSString stringWithFormat:@" ,isCurrent = %@",currentUser]];
    [SQL appendFormat:@""];
    
}

//查询当前用户的最近联系人是否存在某条记录
+(BOOL)isExist:(NSString *)userid Current:(NSString *)currentUserID
{
    NSMutableString *SQL = [NSMutableString stringWithFormat:@"  SELECT *  FROM latelyPerson"];
    [SQL appendString:@"  WHERE"];
    [SQL appendString:[NSString stringWithFormat:@"  userid = '%@'",userid]];
    [SQL appendString:@"  AND"];
    [SQL appendString:[NSString stringWithFormat:@"  isCurrent = '%@'",currentUserID]];
    FMResultSet *set = [_fmdb executeQuery:SQL];
    if ([set next]) {
        return YES;
    }
    
    return NO;
}



@end
